//
//  WFDaily.h
//  WeatherForecast
//
//  Created by Maria on 17.02.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "WFConditions.h"

@interface WFDaily : NSManagedObject

@property (strong, nonatomic) NSDate *lastUpdated;

@property (strong, nonatomic) NSDate *forecastDate;

@property (strong, nonatomic) WFConditions *currentCondition;

@property (strong, nonatomic) NSSet *hourlyCondition;

- (id) initWithEntity;

@end

@interface WFDaily (CoreDataGeneratedAccessors)

- (void)addHourlyConditionObject:(WFConditions *)value;

- (void)removeHourlyConditionObject:(WFConditions *)value;

- (void)addHourlyCondition:(NSSet *)values;

- (void)removeHourlyCondition:(NSSet *)values;

@end
