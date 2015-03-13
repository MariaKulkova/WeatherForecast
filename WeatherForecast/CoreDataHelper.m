//
//  CoreDataHelper.m
//  WeatherForecast
//
//  Created by Maria on 10.03.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import "CoreDataHelper.h"
#import "AppDelegate.h"

@implementation CoreDataHelper

+ (NSManagedObjectContext*) getCurrentContext{
   
    NSManagedObjectContext *currentContext;
    NSThread *currentThread = [NSThread currentThread];
    
    if ([currentThread isMainThread]){
        currentContext = [CoreDataHelper getMainContext];
    }
    else{

        NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] getContextForThread:currentThread.name];
        if (context != nil){
            return context;
        }
        else{
            currentContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
            currentContext.parentContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] mainManagedObjectContext];
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] addContext:currentContext forThread:currentThread.name];
        }
    }
    return currentContext;
}

+ (NSManagedObjectContext*) getMainContext{
    
    return [(AppDelegate *)[[UIApplication sharedApplication] delegate] mainManagedObjectContext];
}

@end
