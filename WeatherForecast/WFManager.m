//
//  WFManager.m
//  WeatherForecast
//
//  Created by Maria on 17.02.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import "WFManager.h"

@implementation WFManager

- (id) init{
    if (self = [super init]){
        forecastCache = [[NSCache alloc] init];
        weatherServiceClient = [[WFClient alloc] init];
    }
    return self;
}

- (void) getDailyForecastForLocation:(NSString *)location{
    
    [WFClient downloadDataFromURL:url withCompletionHandler:^(NSData *data) {
        // Check if any data returned.
        if (data != nil) {
            
            receivedForecast = data;
        }
    }];

    
    NSData *currentWeatherData = [weatherServiceClient getCurrentWeatherForLocation:location];
    
    // Convert the returned data into a dictionary.
    NSError *error;
    NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:currentWeatherData options:kNilOptions error:&error];

//    if (error != nil) {
//        NSLog(@"%@", [error localizedDescription]);
//    }
//    else{
//        self.townWeatherDictionary = [[returnedDict objectForKey:@"data"] objectForKey:@"current_condition"];
//        NSLog(@"%@", self.townWeatherDictionary);
//    }
}

@end
