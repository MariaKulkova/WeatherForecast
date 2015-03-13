//
//  WFManager.m
//  WeatherForecast
//
//  Created by Maria on 17.02.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import "WFManager.h"
#import "WFJSONParser.h"
#import "WFRequest.h"
#import "CoreDataHelper.h"

@implementation WFManager

- (id) init{
    if (self = [super init]){
        
        forecastCache = [[NSMutableArray alloc] init];
        requestsQueue = [[NSMutableArray alloc] init];
        weatherServiceClient = [[WFClient alloc] init];
        forecastCacheSemaphor = dispatch_semaphore_create(1);
        requestsQueueSemaphor = dispatch_semaphore_create(1);
        
        // receive data from data base
        @try {
            [forecastCache addObjectsFromArray:[self readDataFromDataBase]];
        }
        @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
    };
    return self;
}

+ (WFManager*)sharedWeatherManager
{
    static dispatch_once_t once;
    static WFManager *sharedWeatherManager;
    dispatch_once(&once, ^{
        sharedWeatherManager = [[self alloc] init];
    });
    return sharedWeatherManager;
}

#pragma mark - CoreDataMethods

- (NSURL *) applicationDocumentsDirectory{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

// reads weather forecasts for locations from data base
- (NSArray*) readDataFromDataBase{
    
    // receive current context (for current thread)
    NSManagedObjectContext *context = [CoreDataHelper getCurrentContext];
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"WFLocation"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedData = [context executeFetchRequest:fetchRequest error:&error];
    if (error != nil) {
        // data base reading problems
        NSLog(@"Unresolved error: %@. %@", error, [error userInfo]);
        fetchedData = nil;
    }
    return fetchedData;
}

#pragma mark - ManagerServiceInteraction

// Organize weather forecast updating for specified date in definite location from service
- (void) updateForecastForLocation:(GeographyLocation *)location{
    
    // create asynchronous block for data updating
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    
        [[NSThread currentThread] setName:[[NSUUID UUID] UUIDString]];
        
        // receive context for current thread
        NSManagedObjectContext *managedContext = [CoreDataHelper getCurrentContext];
        
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"WFLocation"
                                                             inManagedObjectContext:managedContext];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDescription];
        
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(location.latitude LIKE '%@') AND (location.longitude LIKE '%@')", location.latitude, location.longitude];
//        [request setPredicate:predicate];
        
        // check whether current location has already had forecast in forecastCache
        // determines whether object is contained in data base
        
        WFLocation *locationWeather;
        BOOL objectInDataBase = YES;
        NSError *error;
        NSArray *array = [managedContext executeFetchRequest:request error:&error];
        
        if (array.count == 0){
            locationWeather = [[WFLocation alloc] initWithEntity];
            objectInDataBase = NO;
        }
        else{
            locationWeather = [array objectAtIndex:0];
        }
        
        @try{
            
            // receive json-data from service
            NSString* position = [location makePositionFromCoordinates];
            NSData *currentData = [weatherServiceClient getCurrentWeatherForLocation:position];
            NSData *averageData = [weatherServiceClient getAverrageWeatherForLocation:position];
            NSData *hourlyData = [weatherServiceClient getHourlyWeatherForLocation:position];
            
            // set data to object
            locationWeather.location = [[GeographyLocation alloc] initWithEntity];
            locationWeather.location.areaName = location.areaName;
            locationWeather.location.country = location.country;
            locationWeather.location.latitude = location.latitude;
            locationWeather.location.longitude = location.longitude;
            
            locationWeather.lastUpdate = [NSDate date];
            
            // parse data to form forecast for location
            locationWeather.locationForecast = [NSSet setWithArray:[WFJSONParser parseLocationForecast:currentData
                                                                                 withAverageConditions:averageData
                                                                                  withHourlyConditions:hourlyData]];
        }
        @catch (NSException *exception) {
            
            // TODO: notify about service interaction exceptions and parsing exceptions
            NSLog(@"%@ occured. Description: %@", exception.name, exception.description);
            
            if (objectInDataBase) {
                // object is turned into a fault and any pending changes are lost if object was in data base
                [managedContext refreshObject:locationWeather mergeChanges:NO];
            }
            else{
                // if object weasn't in data base
                locationWeather = nil;
            }
        }
        
        if (locationWeather != nil){
            
            // If object wasn't in context (data base)
            if (!objectInDataBase) {
                
                // add object to cache and insert into context
                dispatch_semaphore_wait(forecastCacheSemaphor, DISPATCH_TIME_FOREVER);
                [forecastCache addObject:locationWeather];
                dispatch_semaphore_signal(forecastCacheSemaphor);
            }
            
            // push to parent
            NSError *error;
            if (![managedContext save:&error])
            {
                // handle error
                NSLog(@"Unresolved error %@. %@", error, [error userInfo]);
                
            }
            
            // save changes
            // save parent to disk asynchronously
            NSManagedObjectContext *mainContext = [CoreDataHelper getMainContext];
            [mainContext performBlock:^{
                NSError *error;
                if (![mainContext save:&error])
                {
                    // handle error
                    NSLog(@"Unresolved error %@. %@", error, [error userInfo]);
                }
            }];
        }
        //------------------------------------------------------------------------------------------------------
    
        [[NSNotificationCenter defaultCenter] postNotificationName:FINISH_LOCATION_UPDATING_NOTIFICATION object:nil userInfo:nil];
    });
}

// Organize weather forecast updating for specified date in definite location from service
- (void) updateForecastForDay:(int) dayIndex inLocation:(GeographyLocation *)location{
    
}

// Organize receiving weather forecast for specified date in definite location from service
- (WFDaily*) getForecastForDay:(int) dayIndex inLocation:(GeographyLocation *)location{
    
    WFLocation *locationForecast = [self checkForecastExistance:location];
    NSArray *dailyForecast = locationForecast.locationForecast.allObjects;
    WFDaily *dayWeather = nil;
    if (dailyForecast.count != 0) {
       dayWeather = [dailyForecast objectAtIndex:dayIndex];
    }
    return dayWeather;
}

// Organize receiving of locations sets which correspond to searching query
- (void) getLocationsForSearchingWord:(NSString *)searchingWord withCompletionHandler:(void (^)(NSArray *))completionHandler{
    
    NSArray *locationsList = [[NSArray alloc] init];
    
    @try {
        NSData *queryResultSet = [weatherServiceClient getLocationsForSearchString:searchingWord];
        locationsList = [WFJSONParser parseLocationsSet:queryResultSet];
    }
    @catch (NSException *exception) {
        // throw exceptions about parsing problems
        // TODO: notify about service interaction exceptions and parsing exceptions
        NSLog(@"%@ occured. Description: %@", exception.name, exception.description);
        locationsList = nil;
    }
    @finally {
        
        // Anyway notify controller that data receiving process was finished
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            completionHandler(locationsList);
        }];
    }
}

- (WFLocation*) checkForecastExistance: (GeographyLocation*) location{
    for (WFLocation* item in forecastCache){
        if ([item.location isEqualToLocation:location]){
            return item;
        }
    }
    return nil;
}

#pragma mark - ManagerRequestQueue

- (void) addRequestToQueue: (WFRequest*) request{
    dispatch_semaphore_wait(requestsQueueSemaphor, DISPATCH_TIME_FOREVER);
    
    
    
    dispatch_semaphore_signal(requestsQueueSemaphor);
}

- (void) launchNextRequest{
    
}

- (void) executeRequest: (WFRequest*) request{
    
}

@end
