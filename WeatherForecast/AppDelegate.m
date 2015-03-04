//
//  AppDelegate.m
//  WeatherForecast
//
//  Created by Maria on 17.02.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import "AppDelegate.h"
#import "WFManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // Subscribe to event of size calculation finish
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(getUpdatedData:)
     name:FINISH_LOCATION_UPDATING_NOTIFICATION
     object:nil];

    
    WFManager *weatherForecastManager = [WFManager sharedWeatherManager];
    //For testing
    GeographyLocation* location = [[GeographyLocation alloc] initWithEntity];
    location.areaName = @"Taganrog";
    location.country = @"Russia";
    location.latitude = @"47.221";
    location.longitude = @"38.909";
    //For testing
    
    // TODO: save last shown location in default plist and update for it forecast
    [weatherForecastManager updateForecastForLocation:location];
    
//    [self createData];
//    
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    
//    self.viewController = [[ViewController alloc] init];
//    self.window.rootViewController = self.viewController;
//    [self.window makeKeyAndVisible];
//    
//    NSManagedObjectContext *context = [self managedObjectContext];
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"WFLocation"
//                                              inManagedObjectContext:context];
//    [fetchRequest setEntity:entity];
//    NSError *error;
//    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
//    for (WFLocation *info in fetchedObjects) {
//        NSLog(@"Date: %@", info.lastUpdate);
//        GeographyLocation *location = info.location;
//        NSLog(@"Location: %@", location.areaName);
//        for (WFDaily *item in info.locationForecast) {
//            NSLog(@"%@", item.forecastDate);
//        }
//    }
    
    return YES;
}

- (void) getUpdatedData: (NSNotification*) notification{
    
    GeographyLocation* location = [[GeographyLocation alloc] init];
    location.areaName = @"Taganrog";
    location.country = @"Russia";
    location.latitude = @"47.221";
    location.longitude = @"38.909";
    
    WFDaily *dayWeather = [[WFManager sharedWeatherManager] getForecastForDay:0 inLocation:location];
    int t = 0;
}

- (void)createData
{
//    NSManagedObjectContext *context = [self managedObjectContext];
//    
//    WFLocation *locationForecast = [NSEntityDescription insertNewObjectForEntityForName:@"WFLocation"
//                                                                 inManagedObjectContext:context];
//    GeographyLocation *location = [NSEntityDescription insertNewObjectForEntityForName:@"GeographyLocation"
//                                                                inManagedObjectContext:context];
//    
//    location.areaName = @"Taganrog";
//    location.country = @"Russia";
//    location.latitude = @"43.123";
//    location.longitude = @"34.678";
//    
//    NSMutableArray *dailyForecast = [[NSMutableArray alloc] init];
//    for (int i = 0; i < 5; i++) {
//        WFDaily *daily = [NSEntityDescription insertNewObjectForEntityForName:@"WFDaily"
//                                                       inManagedObjectContext:context];
//        daily.forecastDate = [NSDate date];
//        
//        WFConditions *currentCondition = [NSEntityDescription insertNewObjectForEntityForName:@"WFConditions"
//                                                                       inManagedObjectContext:context];
//
//        currentCondition.time = [NSDate date];
//        currentCondition.temperature = [NSNumber numberWithInt:15];
//        currentCondition.weatherType = [NSNumber numberWithInt:WFWeatherTypeClearSunny];
//        daily.currentCondition = currentCondition;
//        
//        NSMutableArray *hourlyForecast = [[NSMutableArray alloc] init];
//        for (int j = 0; j < 5; j++) {
//            WFConditions *condition = [NSEntityDescription insertNewObjectForEntityForName:@"WFConditions"
//                                                                    inManagedObjectContext:context];
//            condition.time = [NSDate date];
//            condition.temperature = [NSNumber numberWithInt:15];
//            condition.weatherType = [NSNumber numberWithInt:WFWeatherTypeClearSunny];
//            [hourlyForecast addObject:condition];
//        }
//        
//        daily.hourlyCondition = [NSSet setWithArray: hourlyForecast];
//        
//        [dailyForecast addObject:daily];
//    }
//    
//    locationForecast.location = location;
//    locationForecast.lastUpdate = [NSDate date];
//    locationForecast.locationForecast = [NSSet setWithArray: dailyForecast];
//    
//    [self saveContext];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
