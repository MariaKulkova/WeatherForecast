//
//  WFRequest.h
//  WeatherForecast
//
//  Created by Maria on 04.03.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GeographyLocation.h"

extern int const AllDays;

@interface WFRequest : NSObject

@property (strong, nonatomic) GeographyLocation *location;

@property int dayNumber;

@end
