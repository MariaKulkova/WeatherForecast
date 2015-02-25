//
//  WFManager.m
//  WeatherForecast
//
//  Created by Maria on 17.02.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import "WFManager.h"
#import "WFJSONParser.h"
#import "GeographyLocation.h"

@implementation WFManager

- (id) init{
    if (self = [super init]){
        forecastCache = [[NSCache alloc] init];
        weatherServiceClient = [[WFClient alloc] init];
    }
    return self;
}

// Organize receiving weather forecast for specified location from service
- (void) getForecastForLocation:(GeographyLocation *)location withCompletionHandler:(void (^)(WFLocation *))completionHandler{

    WFLocation *locationWeather = [[WFLocation alloc] init];
    
    @try {
        // receive data from service in json format
        NSString* position = [location makePositionFromCoordinates];
        NSData *currentData = [weatherServiceClient getCurrentWeatherForLocation:position];
        NSData *averageData = [weatherServiceClient getAverrageWeatherForLocation:position];
        NSData *hourlyData = [weatherServiceClient getHourlyWeatherForLocation:position];
    
        locationWeather.location= location;
        locationWeather.lastForecastUpdate = [NSDate date];
        
        // receive array of daily forecasts for specified location from parser
        locationWeather.locationForecast = [WFJSONParser parseLocationForecast:currentData withAverageConditions:averageData withHourlyConditions:hourlyData];
    }
    @catch (NSException *exception) {
        
        // TODO: notify about service interaction exceptions and parsing exceptions
        NSLog(@"%@ occured. Description: %@", exception.name, exception.description);
        locationWeather = nil;
    }
    @finally{
        
        // Anyway notify controller that data receiving process was finished
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            completionHandler(locationWeather);
        }];
    }
}

// Organize receiving of locations sets which correspond to searching query
- (void) getLocationsForSearchingWord:(NSString *)searchingWord withCompletionHandler:(void (^)(NSArray *))completionHandler{
    
    NSArray *locationsList = [[NSArray alloc] init];
    
    @try {
        NSData *queryResultSet = [weatherServiceClient getLocationsForSearchString:searchingWord];
        locationsList = [WFJSONParser parseLocationsSet:queryResultSet];
    }
    @catch (NSException *exception) {
        // throw exceptions about parsing problems
        // TODO: notify about service interaction exceptions and parsing exceptions
        NSLog(@"%@ occured. Description: %@", exception.name, exception.description);
        locationsList = nil;
    }
    @finally {
        
        // Anyway notify controller that data receiving process was finished
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            completionHandler(locationsList);
        }];
    }
}

@end
