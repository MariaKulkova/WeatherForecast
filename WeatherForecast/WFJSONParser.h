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

/**
 Parses three json objects and convert results to array of all available days forecast. Amount of available days is 5.
 @param currentConditionsData represents current weather conditions
 @param averageConditionsData represents hourly weather conditions for all available day with 3-hours time period (hourly conditions)
 @param hourlyConditionsData represents hourly weather conditions for all available day with 24-hours time period (average conditions)
 @return array of WFDaily objects which represents forecasts for all available days
 */
+ (NSArray*) parseLocationForecast: (NSData*) currentConditionsData
                     withAverageConditions: (NSData*) averageConditionsData
                      withHourlyConditions: (NSData*) hourlyConditionsData;

/**
 Parses json object and convert results to weather forecast for today
 @param todayConditionsData represents today weather conditions specifically current conditions and hourly forecast with 3-hours time interval
 @return WFDaily object which corresponds to weather forecast for today
 */
+ (WFDaily*) parseDailyForecast: (NSData*) todayConditionsData;

/**
 Parses json object and convert results to location objects
 @param queryResultData represents set of locations which were the best suited to searching phrase
 @return array of location objects corresponding to search query results
 */
+ (NSArray*) parseLocationsSet: (NSData*) queryResultData;

@end
