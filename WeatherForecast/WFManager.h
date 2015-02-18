//
//  WFManager.h
//  WeatherForecast
//
//  Created by Maria on 17.02.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WFDaily.h"
#import "WFClient.h"

@interface WFManager : NSObject
{
    NSCache *forecastCache;
    
    WFClient* weatherServiceClient;
}

//- (WFDaily*) getDailyForecastForLocation: (NSString*) location;
- (void) getDailyForecastForLocation: (NSString*) location;


@end
