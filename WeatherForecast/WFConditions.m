//
//  WFConditions.m
//  WeatherForecast
//
//  Created by Maria on 17.02.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import "WFConditions.h"
#import "WFManager.h"
#import "CoreDataHelper.h"

@implementation WFConditions

@dynamic temperature;
@dynamic time;
@dynamic weatherType;

- (id) initWithEntity{
    NSManagedObjectContext *currentContext = [CoreDataHelper getCurrentContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"WFConditions"
                                              inManagedObjectContext:currentContext];
    self = [[WFConditions alloc] initWithEntity:entity insertIntoManagedObjectContext:currentContext];
    return self;
}

@end
