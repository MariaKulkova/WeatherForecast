//
//  WFDaily.h
//  WeatherForecast
//
//  Created by Maria on 17.02.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WFConditions.h"

@interface WFDaily : NSObject

@property (strong, nonatomic) NSDate *dayDate;

@property (strong, nonatomic) WFConditions *currentConditions;

@property (strong, nonatomic) NSArray *hourlyConditions;

@end
