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
#import "NotificationConstants.h"

@interface WFManager : NSObject
{
    NSMutableArray *forecastCache;
    
    NSMutableArray *requestsQueue;
    
    WFClient* weatherServiceClient;
    
    dispatch_semaphore_t forecastCacheSemaphor;
    
    dispatch_semaphore_t requestsQueueSemaphor;
}

/**
 Static method which alows to receive instance of manager
 @return singleton instance of manager
 */
+ (WFManager*) sharedWeatherManager;

/**
 Organize receiving weather forecast for specified date in definite location from service
 @param forecastDate represents date for which forecast must be received
 @param location represents place where it is necessary to receive weather conditions
 @return weather forecast for specified date in location if this data exists in memory.
         Otherwise, it returns nil.
 */
- (WFDaily*) getForecastForDay: (int) dayIndex inLocation: (GeographyLocation*) location;

/**
 Organize weather forecast updating for specified date in definite location from service
 @param forecastDate represents date for which forecast must be updated
 @param location represents place where it is necessary to update weather conditions
 */
- (void) updateForecastForDay: (int) dayIndex inLocation: (GeographyLocation*) location;

/**
 Organize weather forecast updating for specified date in definite location from service
 @param location represents place where it is necessary to update weather conditions
 */
- (void) updateForecastForLocation: (GeographyLocation*) location;

/**
 Organize receiving of locations sets which correspond to searching query
 @param searchingWord represents name of locations which must be shown
 @param completionHandler is a block which will be excuted when all necessary operation are performed
 */
- (void) getLocationsForSearchingWord: (NSString*) searchingWord withCompletionHandler:(void (^)(NSArray *))completionHandler;

@end
