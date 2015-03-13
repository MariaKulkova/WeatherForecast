//
//  CoreDataHelper.h
//  WeatherForecast
//
//  Created by Maria on 10.03.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#define MAIN_QUEUE_LABEL @"mainQueueLabel"
#define BACKGROUND_QUEUE_LABEL @"backgroundQueueLabel"

@interface CoreDataHelper : NSObject

+ (NSManagedObjectContext*) getCurrentContext;

+ (NSManagedObjectContext*) getMainContext;

@end
