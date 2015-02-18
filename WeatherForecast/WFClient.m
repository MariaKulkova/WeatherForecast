//
//  WFClient.m
//  WeatherForecast
//
//  Created by Maria on 17.02.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import "WFClient.h"
#import "WFRequestAPIStrings.h"

@implementation WFClient

- (NSData*) getCurrentWeatherForLocation:(NSString *)location{
    
    NSString *URLString = [NSString stringWithFormat:WEATHER_API_LOCALWEATHER_URL, location, WEATHER_API_FREE_KEY];
    NSURL *url = [NSURL URLWithString:URLString];
    
    __block NSData *receivedForecast;
    [WFClient downloadDataFromURL:url withCompletionHandler:^(NSData *data) {
        // Check if any data returned.
        if (data != nil) {
            
            receivedForecast = data;
        }
    }];
    return receivedForecast;
}

- (NSData*) getAverrageWeatherForLocation:(NSString *)location{
    NSString *URLString = [NSString stringWithFormat:WEATHER_API_LOCALWEATHER_URL, location, WEATHER_API_FREE_KEY];
    NSURL *url = [NSURL URLWithString:URLString];
    
    __block NSData *receivedForecast;
    [WFClient downloadDataFromURL:url withCompletionHandler:^(NSData *data) {
        // Check if any data returned.
        if (data != nil) {
            receivedForecast = data;
        }
    }];
    return receivedForecast;
}

- (NSData*) getHourlyWeatherForLocation:(NSString *)location{
    
    NSString *URLString = [NSString stringWithFormat:WEATHER_API_LOCALWEATHER_URL, location, WEATHER_API_FREE_KEY];
    NSURL *url = [NSURL URLWithString:URLString];
    
    __block NSData *receivedForecast;
    [WFClient downloadDataFromURL:url withCompletionHandler:^(NSData *data) {
        // Check if any data returned.
        if (data != nil) {
            receivedForecast = data;
        }
    }];
    return receivedForecast;
}


+ (void)downloadDataFromURL:(NSURL *)url withCompletionHandler:(void (^)(NSData *))completionHandler{
    
    // Instantiate a session configuration object.
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    // Instantiate a session object.
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    // Create a data task object to perform the data downloading.
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error != nil) {
            // If any error occurs then just display its description on the console.
            NSLog(@"%@", [error localizedDescription]);
        }
        else{
            // If no error occurs, check the HTTP status code.
            NSInteger HTTPStatusCode = [(NSHTTPURLResponse *)response statusCode];
            
            // If it's other than 200, then show it on the console.
            if (HTTPStatusCode != 200) {
                NSLog(@"HTTP status code = %d", HTTPStatusCode);
            }
            
            // Call the completion handler with the returned data on the main thread.
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                completionHandler(data);
            }];
        }
    }];
    
    // Resume the task.
    [task resume];
}


@end
