//
//  WFManager.m
//  WeatherForecast
//
//  Created by Maria on 17.02.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import "WFManager.h"
#import "WFJSONParser.h"

@implementation WFManager

- (id) init{
    if (self = [super init]){
        forecastCache = [[NSCache alloc] init];
        weatherServiceClient = [[WFClient alloc] init];
    }
    return self;
}

- (void) getForecastForLocation:(NSString *)location withCompletionHandler:(void (^)(WFLocation *))completionHandler{

    NSData* dataCur = [weatherServiceClient getCurrentWeatherForLocation:location];
    NSData* dataAver = [weatherServiceClient getAverrageWeatherForLocation:location];
    NSData* dataHour = [weatherServiceClient getHourlyWeatherForLocation:location];
    
    NSError *error;
    NSMutableDictionary *currentDictionary = [[NSJSONSerialization JSONObjectWithData:dataCur options:kNilOptions error:&error] objectForKey:@"data"];
    NSMutableDictionary *averageDictionary = [[NSJSONSerialization JSONObjectWithData:dataAver options:kNilOptions error:&error] objectForKey:@"data"];
    NSMutableDictionary *hourlyDictionary = [[NSJSONSerialization JSONObjectWithData:dataHour options:kNilOptions error:&error] objectForKey:@"data"];

    WFLocation *locationWeather = [[WFLocation alloc] init];
    locationWeather.locationName = location;
    locationWeather.lastForecastUpdate = [NSDate date];
    
    if (error != nil) {
        NSLog(@"%@", [error localizedDescription]);
    }
    else{
        locationWeather.locationForecast = [WFJSONParser getLocationForecastForJSON:currentDictionary withAverageConditions:averageDictionary withHourlyConditions:hourlyDictionary];
    }

    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        completionHandler(locationWeather);
    }];
}

@end
