//
//  WFLocation.m
//  WeatherForecast
//
//  Created by Maria on 17.02.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import "WFLocation.h"
#import "WFManager.h"

@implementation WFLocation

@dynamic lastUpdate;
@dynamic location;
@dynamic locationForecast;

- (id) initWithEntity{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"WFLocation"
                                              inManagedObjectContext:[WFManager sharedWeatherManager].managedObjectContext];
    self = [[WFLocation alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    return self;
}

@end
