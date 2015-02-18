//
//  WFClient.h
//  WeatherForecast
//
//  Created by Maria on 17.02.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WFClient : NSObject

- (NSData*) getCurrentWeatherForLocation: (NSString*) location;

- (NSData*) getHourlyWeatherForLocation: (NSString*) location;

- (NSData*) getAverrageWeatherForLocation: (NSString*) location;

+ (void)downloadDataFromURL:(NSURL *)url withCompletionHandler:(void (^)(NSData *))completionHandler;

@end
