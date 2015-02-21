//
//  WFJSONParser.h
//  WeatherForecast
//
//  Created by Maria on 19.02.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WFConditions.h"
#import "WFLocation.h"
#import "WFDaily.h"

@interface WFJSONParser : NSObject

+ (NSArray*) getLocationForecastForJSON: (NSMutableDictionary*) currentConditions
                     withAverageConditions: (NSMutableDictionary*) averageConditions
                      withHourlyConditions: (NSMutableDictionary*) hourlyConditions;

+ (WFDaily*) getDailyForecastForJSON: (NSMutableDictionary*) hourlyConditions;

@end