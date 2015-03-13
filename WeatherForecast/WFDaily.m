//
//  WFDaily.m
//  WeatherForecast
//
//  Created by Maria on 17.02.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import "WFDaily.h"
#import "WFManager.h"
#import "CoreDataHelper.h"

@implementation WFDaily

@dynamic lastUpdated;
@dynamic forecastDate;
@dynamic currentCondition;
@dynamic hourlyCondition;

- (id) initWithEntity{
    NSManagedObjectContext *currentContext = [CoreDataHelper getCurrentContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"WFDaily"
                                              inManagedObjectContext:currentContext];
    self = [[WFDaily alloc] initWithEntity:entity insertIntoManagedObjectContext:currentContext];
    return self;
}

@end
