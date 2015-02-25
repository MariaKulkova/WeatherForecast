//
//  GeographyLocation.m
//  WeatherForecast
//
//  Created by Maria on 25.02.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import "GeographyLocation.h"

@implementation GeographyLocation

@synthesize areaName, country, latitude, longitude;

// Makes location position string for service interaction by latitude and longitude concatination
- (NSString*) makePositionFromCoordinates{
    return [NSString stringWithFormat:@"%@,%@", self.latitude, self.longitude];
}

@end
