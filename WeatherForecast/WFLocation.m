//
//  WFLocation.m
//  WeatherForecast
//
//  Created by Maria on 17.02.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import "WFLocation.h"
#import "WFManager.h"
#import "CoreDataHelper.h"

@implementation WFLocation

@dynamic lastUpdate;
@dynamic location;
@dynamic locationForecast;

- (id) initWithEntity{
    NSManagedObjectContext *currentContext = [CoreDataHelper getCurrentContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"WFLocation"
                                              inManagedObjectContext:currentContext];
    self = [[WFLocation alloc] initWithEntity:entity insertIntoManagedObjectContext:currentContext];
    return self;
}

@end
