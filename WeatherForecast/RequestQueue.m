//
//  RequestQueue.m
//  WeatherForecast
//
//  Created by Maria on 04.03.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import "RequestQueue.h"

@implementation RequestQueue

- (id) init{
    if (self = [super init]){
        queue = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) pushObjectToQueue:(WFRequest *)object{
    
    BOOL isFullUpdate = false;
    if (object.dayNumber == AllDays) {
        isFullUpdate = true;
    }
    // push object to queue with a help of priority rules
    switch ([self findSameUpdationsForRequest:object]) {
        case SearchResultFullFound:
            // don't add to queue because all data which is bound with location will be updated
            break;
        
        case SearchResultEqualFound:
            
            break;
        
        case SearchResultNoMatches:
            
            break;
            
        default:
            break;
    }
}

- (SearchResult) findSameUpdationsForRequest: (WFRequest*) request{
    SearchResult result = SearchResultNoMatches;
    for (WFRequest* item in queue){
        if ([item.location isEqual:request.location]) {
            if (item.dayNumber == request.dayNumber) {
                result = SearchResultEqualFound;
            }
            else{
                // Attention. Incorrect const
                if (item.dayNumber == AllDays) {
                    result = SearchResultFullFound;
                }
            }
        }
    }
    return result;
}

@end
