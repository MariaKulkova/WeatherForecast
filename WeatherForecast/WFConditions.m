//
//  WFConditions.m
//  WeatherForecast
//
//  Created by Maria on 17.02.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import "WFConditions.h"
#import "WFManager.h"

@implementation WFConditions

@dynamic temperature;
@dynamic time;
@dynamic weatherType;

- (id) initWithEntity{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"WFConditions"
                                              inManagedObjectContext:[WFManager sharedWeatherManager].managedObjectContext];
    self = [[WFConditions alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    return self;
}

@end
