//
//  WFConditions.h
//  WeatherForecast
//
//  Created by Maria on 17.02.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherParameters.h"

@interface WFConditions : NSObject

@property (strong, nonatomic) NSDate *forcastDateTime;

@property (nonatomic) double *temperature;

@property (strong, nonatomic) WeatherParameters *weatherSpecification;

@end
