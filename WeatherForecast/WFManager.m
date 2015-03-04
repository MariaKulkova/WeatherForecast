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

@implementation WFManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (id) init{
    if (self = [super init]){
        forecastCache = [[NSMutableArray alloc] init];
        requestsQueue = [[NSMutableArray alloc] init];
        weatherServiceClient = [[WFClient alloc] init];
        forecastCacheSemaphor = dispatch_semaphore_create(1);
        requestsQueueSemaphor = dispatch_semaphore_create(1);
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

#pragma mark - CoreDataProperties

- (NSManagedObjectModel *) managedObjectModel {
    if (_managedObjectModel != nil){
        return _managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"WeatherForecastModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *) persistentStoreCoordinator {
    if(_persistentStoreCoordinator != nil){
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"WeatherForecastApp.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    if(![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]){
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *) managedObjectContext {
    if(_managedObjectContext != nil){
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if(coordinator != nil){
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    return _managedObjectContext;
}

#pragma mark - CoreDataMethods

- (NSURL *) applicationDocumentsDirectory{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void) saveCoreDataContext {
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    
    if(managedObjectContext != nil) {
        if([managedObjectContext hasChanges] && ![managedObjectContext save:&error]){
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (void) insertDataToContext:(WFLocation *)locationForecast{
    
    [self.managedObjectContext insertObject:locationForecast];
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        //Respond to the error
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

- (NSArray*) readDataFromDataBase{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"WFLocation"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedData = [context executeFetchRequest:fetchRequest error:&error];
    if (error != nil) {
        // data base reading problems
        fetchedData = nil;
    }
    return fetchedData;
}

#pragma mark - ManagerServiceInteraction

- (void) updateForecastForLocation:(GeographyLocation *)location{
    
    // create asynchronous block for data updating
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        // check whether current location has already had forecast in forecastCache
        dispatch_semaphore_wait(forecastCacheSemaphor, DISPATCH_TIME_FOREVER);
        
        // determines whether object is contained in cache
        BOOL objectInDataBase = YES;
        WFLocation *locationWeather = [self checkForecastExistance:location];
        if (locationWeather == nil) {
            // if object doesnt't exist in cache create new entity without inserting into model object context
            locationWeather = [[WFLocation alloc] initWithEntity];
            objectInDataBase = NO;
        }
        
        dispatch_semaphore_signal(forecastCacheSemaphor);
    
        @try {
            
            // receive json-data from service
            NSString* position = [location makePositionFromCoordinates];
            NSData *currentData = [weatherServiceClient getCurrentWeatherForLocation:position];
            NSData *averageData = [weatherServiceClient getAverrageWeatherForLocation:position];
            NSData *hourlyData = [weatherServiceClient getHourlyWeatherForLocation:position];
            
            locationWeather.location= location;
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
                [self.managedObjectContext refreshObject:locationWeather mergeChanges:NO];
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
                
                [self insertDataToContext:locationWeather];
            }
            // save changes
            [self saveCoreDataContext];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:FINISH_LOCATION_UPDATING_NOTIFICATION object:nil userInfo:nil];
        }
    });
}

- (void) updateForecastForDay:(int) dayIndex inLocation:(GeographyLocation *)location{
    
    // create asynchronous block for data updating
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        // check whether current location has already had forecast in forecastCache
        dispatch_semaphore_wait(forecastCacheSemaphor, DISPATCH_TIME_FOREVER);
        
        // determines whether object is contained in cache
        BOOL objectInDataBase = YES;
        WFLocation *locationWeather = [self checkForecastExistance:location];
        if (locationWeather == nil) {
            // if object doesnt't exist in cache create new entity without inserting into model object context
            locationWeather = [[WFLocation alloc] initWithEntity];
            objectInDataBase = NO;
        }
        
        dispatch_semaphore_signal(forecastCacheSemaphor);
        
        @try {
            
            // receive json-data from service
            NSString* position = [location makePositionFromCoordinates];
            //NSData *dayData =
            
            locationWeather.location = location;
            locationWeather.lastUpdate = [NSDate date];
            // parse data to form forecast for location
//            locationWeather.locationForecast = [NSSet setWithArray:[WFJSONParser parseLocationForecast:currentData
//                                                                                 withAverageConditions:averageData
//                                                                                  withHourlyConditions:hourlyData]];
        }
        @catch (NSException *exception) {
            
            // TODO: notify about service interaction exceptions and parsing exceptions
            NSLog(@"%@ occured. Description: %@", exception.name, exception.description);
            
            if (objectInDataBase) {
                // object is turned into a fault and any pending changes are lost if object was in data base
                [self.managedObjectContext refreshObject:locationWeather mergeChanges:NO];
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
                
                [self insertDataToContext:locationWeather];
            }
            // save changes
            [self saveCoreDataContext];
        }
    });
}

- (WFDaily*) getForecastForDay:(int) dayIndex inLocation:(GeographyLocation *)location{
    
    WFLocation *locationForecast = [self checkForecastExistance:location];
    NSArray *dailyForecast = locationForecast.locationForecast.allObjects;
    WFDaily *dayWeather = [dailyForecast objectAtIndex:dayIndex];
//    for (WFDaily *item in dailyForecast){
//        if (item.forecastDate isEqual:forecastDate]){
//            dayWeather = item;
//        }
//    }
    
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
