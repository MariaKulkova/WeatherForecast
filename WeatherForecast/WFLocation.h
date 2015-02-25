//
//  WFLocation.h
//  WeatherForecast
//
//  Created by Maria on 17.02.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WFDaily.h"
#import "GeographyLocation.h"

@interface WFLocation : NSObject

@property (strong, nonatomic) GeographyLocation *location;

@property (strong, nonatomic) NSDate *lastForecastUpdate;

@property (strong, nonatomic) NSArray *locationForecast;

@end
