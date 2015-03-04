//
//  RequestQueue.h
//  WeatherForecast
//
//  Created by Maria on 04.03.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WFRequest.h"

typedef enum{
    
    SearchResultFullFound,
    SearchResultEqualFound,
    SearchResultNoMatches
    
} SearchResult;

@interface RequestQueue : NSObject
{
    NSMutableArray *queue;
}

- (void) pushObjectToQueue: (WFRequest*) object;

- (WFRequest*) popObjectFromQueue;

@end
