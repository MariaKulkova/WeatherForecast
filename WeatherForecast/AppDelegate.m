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
{
    NSMutableDictionary *threadsContextDictionary;
    
    dispatch_semaphore_t threadsContextSemaphore;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // contexts working
    threadsContextDictionary = [[NSMutableDictionary alloc] init];
    threadsContextSemaphore = dispatch_semaphore_create(1);
    
    // Initialize Core Data stack
    [self setupCoreDataStack];
    
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
    
    // TODO: save last shown location in default plist and update for it forecast
    [weatherForecastManager updateForecastForLocation:location];
    
    return YES;
}

- (void) addContext:(NSManagedObjectContext *)context forThread:(NSString *)threadName{
    
    dispatch_semaphore_wait(threadsContextSemaphore, DISPATCH_TIME_FOREVER);
    [threadsContextDictionary setObject:context forKey:threadName];
    dispatch_semaphore_signal(threadsContextSemaphore);
}

- (NSManagedObjectContext*) getContextForThread:(NSString *)threadName{
    
    NSManagedObjectContext *result = [threadsContextDictionary objectForKey:threadName];
    return result;
}

- (NSURL *) applicationDocumentsDirectory{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void) setupCoreDataStack {
    
    // setup managed object model
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"WeatherForecastModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    // setup persistent store coordinator
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"WeatherForecastApp.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: _managedObjectModel];
    if(![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]){
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    // create main managed object context
    self.mainManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [self.mainManagedObjectContext setPersistentStoreCoordinator: _persistentStoreCoordinator];
}

- (void) getUpdatedData: (NSNotification*) notification{
    
    // For testing
    GeographyLocation* location = [[GeographyLocation alloc] initWithEntity];
    location.areaName = @"Taganrog";
    location.country = @"Russia";
    location.latitude = @"47.221";
    location.longitude = @"38.909";
    
    WFDaily *dayWeather = [[WFManager sharedWeatherManager] getForecastForDay:0 inLocation:location];
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
