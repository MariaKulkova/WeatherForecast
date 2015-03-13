//
//  AppDelegate.h
//  WeatherForecast
//
//  Created by Maria on 17.02.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ViewController.h"
#import "WFManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@property (strong, nonatomic) NSManagedObjectContext *mainManagedObjectContext;

@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;

@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSManagedObjectContext*) getContextForThread: (NSString*) threadName;

- (void) addContext: (NSManagedObjectContext*) context forThread: (NSString*) threadName;

@end

