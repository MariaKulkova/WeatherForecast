//
//  WFClient.m
//  WeatherForecast
//
//  Created by Maria on 17.02.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import "WFClient.h"
#import "WFRequestAPIStrings.h"

@interface WFClient ()

/**
 Initializes data downloading process
 @param url represents query to service
 @return json data which was received from service
 */
- (NSData*) initializeDownloadProcess: (NSURL*) url;

/**
 Makes query to service from specified parameters
 @param baseURL represents base url for query
 @param location represents location for query
 @param params represents optional parameters for query
 @return whole service query string
 */
- (NSString*) constructRequestWithBaseURL: (NSString*) baseURL forLocation: (NSString*) location withParams: (NSArray*) params;

/**
 */
- (void)downloadDataFromURL:(NSURL *)url withCompletionHandler:(void (^)(NSData *))completionHandler;

@end

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

//  Determines current weather conditions
- (NSData*) getCurrentWeatherForLocation:(NSString *)locationPosition{
    
    NSString *URLString = [self constructRequestWithBaseURL:WEATHER_API_LOCALWEATHER_URL forLocation:locationPosition withParams:[NSArray arrayWithObjects: WEATHER_API_PARAMS_CURRENT_CONDITIONS, nil]];
    NSData* downloadedData = [self initializeDownloadProcess:[NSURL URLWithString:URLString]];
    return downloadedData;
}

// Determines hourly forecast for all available days
- (NSData*) getAverrageWeatherForLocation:(NSString *)locationPosition{

    NSString *URLString = [self constructRequestWithBaseURL:WEATHER_API_LOCALWEATHER_URL forLocation:locationPosition withParams:[NSArray arrayWithObjects: WEATHER_API_PARAMS_AVERRAGE, nil]];
    NSData* downloadedData = [self initializeDownloadProcess:[NSURL URLWithString:URLString]];
    return downloadedData;
}

// Determines average weather conditions for all available days
- (NSData*) getHourlyWeatherForLocation:(NSString *)locationPosition{
    
    NSString *URLString = [self constructRequestWithBaseURL:WEATHER_API_LOCALWEATHER_URL forLocation:locationPosition withParams:[NSArray arrayWithObjects: WEATHER_API_PARAMS_HOURLY, nil]];
    NSData* downloadedData = [self initializeDownloadProcess:[NSURL URLWithString:URLString]];
    return downloadedData;
}

// Determines weather conditions for today for specified location
- (NSData*) getTodayWeatherForLocation:(NSString *)locationPosition{
    NSString *URLString = [self constructRequestWithBaseURL:WEATHER_API_LOCALWEATHER_URL forLocation:locationPosition withParams:[NSArray arrayWithObjects: WEATHER_API_PARAMS_TODAY_WEATHER, nil]];
    NSData* downloadedData = [self initializeDownloadProcess:[NSURL URLWithString:URLString]];
    return downloadedData;
}

// Determines locations which are the best suited to searching string
- (NSData*) getLocationsForSearchString:(NSString *)searchingString{
    
    NSString *URLString = [self constructRequestWithBaseURL:WEATHER_API_SEARCH_URL forLocation:searchingString withParams:nil];
    NSData* downloadedData = [self initializeDownloadProcess:[NSURL URLWithString:URLString]];
    return downloadedData;
}


- (NSData*) initializeDownloadProcess: (NSURL*) url{
    
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

- (NSString*) constructRequestWithBaseURL: (NSString*) baseURL forLocation: (NSString*) location withParams: (NSArray*) params{
    
    NSString* requestString = baseURL;
    
    // Add required location parameter
    requestString = [requestString stringByAppendingString:[NSString stringWithFormat:WEATHER_API_PARAMS_REQUIRED, WEATHER_API_FREE_KEY, location]];
    
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
