//
//  WFDaily.m
//  WeatherForecast
//
//  Created by Maria on 17.02.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import "WFDaily.h"
#import "WFManager.h"

@implementation WFDaily

@dynamic lastUpdated;
@dynamic forecastDate;
@dynamic currentCondition;
@dynamic hourlyCondition;

- (id) initWithEntity{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"WFDaily"
                                              inManagedObjectContext:[WFManager sharedWeatherManager].managedObjectContext];
    self = [[WFDaily alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    return self;
}

@end
