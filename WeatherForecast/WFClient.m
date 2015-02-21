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

- (id) init{
    if (self = [super init]){
        
        // Instantiate a session configuration object.
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        // Instantiate a session object.
        URLSession = [NSURLSession sessionWithConfiguration:configuration];
        
        // Create semaphore with signal state
        dataDidLoadSemaphore = dispatch_semaphore_create(0);
    }
    return self;
}

- (NSData*) getCurrentWeatherForLocation:(NSString *)location{
    
    NSString *URLString = [self constructRequestForLocation:location withParams:[NSArray arrayWithObjects: WEATHER_API_PARAMS_CURRENT_DAY, WEATHER_API_PARAMS_HOURLY_EXCLUDE, nil]];
    NSURL *url = [NSURL URLWithString:URLString];
    
    __block NSData* receivedData = [[NSData alloc] init];
    [self downloadDataFromURL:url withCompletionHandler:^(NSData *data){
        if (data != nil) {
            receivedData = data;
        }
        
        dispatch_semaphore_signal(dataDidLoadSemaphore);
    }];
    
    dispatch_semaphore_wait(dataDidLoadSemaphore, DISPATCH_TIME_FOREVER);
    return receivedData;
}

- (NSData*) getAverrageWeatherForLocation:(NSString *)location{

    NSString *URLString = [self constructRequestForLocation:location withParams:[NSArray arrayWithObjects: WEATHER_API_PARAMS_AVERRAGE, nil]];
    NSURL *url = [NSURL URLWithString:URLString];
    
    __block NSData* receivedData = [[NSData alloc] init];
    [self downloadDataFromURL:url withCompletionHandler:^(NSData *data){
        if (data != nil) {
            receivedData = data;
        }
        
        dispatch_semaphore_signal(dataDidLoadSemaphore);
    }];
    
    dispatch_semaphore_wait(dataDidLoadSemaphore, DISPATCH_TIME_FOREVER);
    return receivedData;

}

- (NSData*) getHourlyWeatherForLocation:(NSString *)location{
    
    NSString *URLString = [self constructRequestForLocation:location withParams:[NSArray arrayWithObjects: WEATHER_API_PARAMS_HOURLY, nil]];
    NSURL *url = [NSURL URLWithString:URLString];
    
    __block NSData* receivedData = [[NSData alloc] init];
    [self downloadDataFromURL:url withCompletionHandler:^(NSData *data){
        if (data != nil) {
            receivedData = data;
        }
        
        dispatch_semaphore_signal(dataDidLoadSemaphore);
    }];
    
    dispatch_semaphore_wait(dataDidLoadSemaphore, DISPATCH_TIME_FOREVER);
    return receivedData;
}

- (NSString*) constructRequestForLocation: (NSString*) location withParams: (NSArray*) params{
    
    NSString* requestString = WEATHER_API_LOCALWEATHER_URL;
    
    // Add required location parameter
    requestString = [requestString stringByAppendingString:[NSString stringWithFormat:@"&q=%@", location]];
    
    for (NSString* item in params) {
        requestString = [requestString stringByAppendingString:[NSString stringWithFormat:@"&%@", item]];
    }
    return requestString;
}

- (void)downloadDataFromURL:(NSURL *)url withCompletionHandler:(void (^)(NSData *))completionHandler{
  
    // Create a data task object to perform the data downloading.
    NSURLSessionDataTask *task = [URLSession dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error != nil) {
            // If any error occurs then just display its description on the console.
            NSLog(@"%@", [error localizedDescription]);
            [[NSOperationQueue currentQueue] addOperationWithBlock:^{
                completionHandler(nil);
            }];

        }
        else{
            // If no error occurs, check the HTTP status code.
            NSInteger HTTPStatusCode = [(NSHTTPURLResponse *)response statusCode];
            
            // If it's other than 200, then show it on the console.
            if (HTTPStatusCode != 200) {
                NSLog(@"HTTP status code = %d", HTTPStatusCode);
            }
            
            // Call the completion handler with the returned data on the main thread.
            [[NSOperationQueue currentQueue] addOperationWithBlock:^{
                completionHandler(data);
            }];
        }
    }];
    
    // Resume the task.
    [task resume];
}


@end
