//
//  WFClient.m
//  WeatherForecast
//
//  Created by Maria on 17.02.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import "WFClient.h"
#import "WFRequestAPIStrings.h"

NSString* const WFClientErrorDomain = @"WFClientErrorDomain";

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
 Receives data from service
 @param url represents url query for service with all necessary parameters
 @param withCompletionHandler represents block which will be executed when downloading process is finished
 */
- (void)downloadDataFromURL:(NSURL *)url withCompletionHandler:(void (^)(NSData *receivedData, NSError *occuredError))completionHandler;

/**
 Constructs date parameter for service query
 @param date represents date in standart format
 @return string date parameter with valu in a right format: "date=yyyy-MM-dd"
 */
- (NSString*) constructDateParameter: (NSDate*) date;

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

// Determines weather average conditions for a definite day for specified location
- (NSData*) getAverageDayWeatherForLocation:(NSString *)locationPosition withDate:(NSDate *)date{
    
    NSString *URLString = [self constructRequestWithBaseURL:WEATHER_API_LOCALWEATHER_URL forLocation:locationPosition withParams:[NSArray arrayWithObjects: [self constructDateParameter:date], WEATHER_API_PARAMS_AVERRAGE, nil]];
    NSData* downloadedData = [self initializeDownloadProcess:[NSURL URLWithString:URLString]];
    return downloadedData;
}

// Determines weather hourly conditions for a definite day for specified location
- (NSData*) getHourlyDayWeatherForLocation:(NSString *)locationPosition withDate:(NSDate *)date{
    NSString *URLString = [self constructRequestWithBaseURL:WEATHER_API_LOCALWEATHER_URL forLocation:locationPosition withParams:[NSArray arrayWithObjects: [self constructDateParameter:date], WEATHER_API_PARAMS_HOURLY, nil]];
    NSData* downloadedData = [self initializeDownloadProcess:[NSURL URLWithString:URLString]];
    return downloadedData;
}

// Constructs date parameter for service query
- (NSString*) constructDateParameter: (NSDate*) date{
    
    static NSDateFormatter *dateFormat = nil;
    if (dateFormat == nil){
        dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
    }
    
    NSString* dateParameter;
    @try {
        NSString* dateWithFormat = [dateFormat stringFromDate:date];
        dateParameter = [NSString stringWithFormat:WEATHER_API_PARAMS_DATE, dateWithFormat];
    }
    @catch (NSException *exception) {
        NSLog(@"%@. Description: %@", exception.name, exception.description);
    }
    
    return dateParameter;
}

// Determines locations which are the best suited to searching string
- (NSData*) getLocationsForSearchString:(NSString *)searchingString{
    
    NSString *URLString = [self constructRequestWithBaseURL:WEATHER_API_SEARCH_URL forLocation:searchingString withParams:nil];
    NSData* downloadedData = [self initializeDownloadProcess:[NSURL URLWithString:URLString]];
    return downloadedData;
}

// Initializes data downloading process
- (NSData*) initializeDownloadProcess: (NSURL*) url{
    
    __block NSData* receivedData = [[NSData alloc] init];
    
    @try {
        
        [self downloadDataFromURL:url withCompletionHandler:^(NSData *data, NSError *error){
            // If some errors occured during downloading process
            if (error != nil) {
                // TODO: notify controller
            }
            else{
                receivedData = data;
            }
            dispatch_semaphore_signal(dataDidLoadSemaphore);
        }];
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception: %@. Reason: %@", exception.name, exception.reason);
        dispatch_semaphore_signal(dataDidLoadSemaphore);
    }

    dispatch_semaphore_wait(dataDidLoadSemaphore, DISPATCH_TIME_FOREVER);
    return receivedData;
}

// Makes query to service from specified parameters
- (NSString*) constructRequestWithBaseURL: (NSString*) baseURL forLocation: (NSString*) location withParams: (NSArray*) params{
    
    NSString* requestString = baseURL;
    
    // Add required location parameter
    requestString = [requestString stringByAppendingString:[NSString stringWithFormat:WEATHER_API_PARAMS_REQUIRED, WEATHER_API_FREE_KEY, location]];
    
    // Parameters concatination with "&" symbol
    for (NSString* item in params) {
        requestString = [requestString stringByAppendingString:[NSString stringWithFormat:@"&%@", item]];
    }
    return requestString;
}

// Receives data from service
- (void)downloadDataFromURL:(NSURL *)url withCompletionHandler:(void (^)(NSData *receivedData, NSError *occuredError))completionHandler{
  
    NSLog(@"Service query: %@", url);
    // Create a data task object to perform the data downloading.
    NSURLSessionDataTask *task = [URLSession dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        // error for process result identifying
        NSError *occuredError;
        
        if (error != nil) {
            
            // If any error occurs then just display its description on the console.
            NSLog(@"%@", [error localizedDescription]);
            data = nil;
            occuredError = [NSError errorWithDomain:WFClientErrorDomain
                                               code:WFClientServiceConnectionError
                                           userInfo:nil];
        }
        else{
            // If no error occurs, check the HTTP status code.
            NSInteger HTTPStatusCode = [(NSHTTPURLResponse *)response statusCode];
            
            // If it's other than 200, then show it on the console.
            if (HTTPStatusCode != 200) {
                NSLog(@"HTTP status code = %ld", (long)HTTPStatusCode);
                occuredError = [NSError errorWithDomain:WFClientErrorDomain
                                                   code:WFClientDataReceivingError
                                               userInfo:nil];
            }
        }
        // Call the completion handler with the returned data and error state on the current thread.
        [[NSOperationQueue currentQueue] addOperationWithBlock:^{
            completionHandler(data, occuredError);
        }];
    }];
    
    // Resume the task.
    [task resume];
}

@end
