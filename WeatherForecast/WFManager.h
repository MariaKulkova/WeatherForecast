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
#import "WFLocation.h"
#import "GeographyLocation.h"

@interface WFManager : NSObject
{
    NSCache *forecastCache;
    
    WFClient* weatherServiceClient;
}

/**
 Organize receiving weather forecast for specified location from service
 @param location represents place where it is necessary to receive weather conditions
 @param completionHandler is a block which will be excuted when all necessary operation are performed
 */
- (void) getForecastForLocation: (GeographyLocation*) location withCompletionHandler:(void (^)(WFLocation *))completionHandler;

/**
 Organize receiving of locations sets which correspond to searching query
 @param searchingWord represents name of locations which must be shown
@param completionHandler is a block which will be excuted when all necessary operation are performed
 */
- (void) getLocationsForSearchingWord: (NSString*) searchingWord withCompletionHandler:(void (^)(NSArray *))completionHandler;

@end
