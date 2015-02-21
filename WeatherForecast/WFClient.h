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
    NSURLSession *URLSession;
    
    dispatch_semaphore_t dataDidLoadSemaphore;
}

- (NSData*) getCurrentWeatherForLocation: (NSString*) location;

- (NSData*) getHourlyWeatherForLocation: (NSString*) location;

- (NSData*) getAverrageWeatherForLocation: (NSString*) location;

- (NSDate*) getLocationsForSearchString: (NSString*) location;

@end
