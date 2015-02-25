//
//  WFClient.h
//  WeatherForecast
//
//  Created by Maria on 17.02.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WFClient : NSObject
{
    // URL session for service interaction
    NSURLSession *URLSession;
    
    // Semaphor that allows to track download process
    dispatch_semaphore_t dataDidLoadSemaphore;
}

/**
 Determines current weather conditions
 @param locationPosition represents place defined by geographic coordinates (latitude, longitude) where it is necessary to determine weather conditions
 @return data in json-format that represents current weather conditions in definite location
 */
- (NSData*) getCurrentWeatherForLocation: (NSString*) locationPosition;

/**
 Determines hourly forecast for all available days
 @param location represents place where it is necessary to determine weather conditions
 @return data in json-format which represents hourly forecast for all available days
 */
- (NSData*) getHourlyWeatherForLocation: (NSString*) locationPosition;

/**
 Determines average weather conditions for all available days
 @param location represents place where it is necessary to determine weather conditions
 @return data in json-format which represents average weather characteristics (forecast for 24-hour period)
 */
- (NSData*) getAverrageWeatherForLocation: (NSString*) locationPosition;

/**
 Determines weather conditions for today for specified location
 @param location represents place where it is necessary to determine weather conditions
 @return data in json-format that represents today weather conditions in definite location
 */
- (NSData*) getTodayWeatherForLocation: (NSString*) locationPosition;

/**
 Determines locations which are the best suited to searching string
 @param searching string represents search word which user associates with sought-for location
 @return data in json-format which represents set of locations which matches to searching word
 */
- (NSData*) getLocationsForSearchString: (NSString*) searchingString;

@end
