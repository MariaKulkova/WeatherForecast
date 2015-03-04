//
//  WFLocation.h
//  WeatherForecast
//
//  Created by Maria on 17.02.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "WFDaily.h"
#import "GeographyLocation.h"

@interface WFLocation : NSManagedObject

@property (strong, nonatomic) GeographyLocation *location;

@property (strong, nonatomic) NSDate *lastUpdate;

@property (strong, nonatomic) NSSet *locationForecast;

- (id) initWithEntity;

@end

@interface WFLocation (CoreDataGeneratedAccessors)

- (void)addDailyForecastObject:(WFDaily *)value;

- (void)removeDailyForecastObject:(WFDaily *)value;

- (void)addDailyForecast:(NSSet *)values;

- (void)removeDailyForecast:(NSSet *)values;

@end
