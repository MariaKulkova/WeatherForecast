//
//  GeographyLocation.h
//  WeatherForecast
//
//  Created by Maria on 25.02.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface GeographyLocation : NSManagedObject

/// Name of location
@property(strong, nonatomic) NSString* areaName;

/// Country which location belongs to
@property(strong, nonatomic) NSString* country;

/// Represents latitude part of location's geographic coordinates
@property(strong, nonatomic) NSString* latitude;

/// Represents longitude part of location's geographic coordinates
@property(strong, nonatomic) NSString* longitude;

- (id) initWithEntity;

- (BOOL)isEqualToLocation:(GeographyLocation *)location;

/**
 Makes location position string for service interaction by latitude and longitude concatination
 @return location's position string in format: latitude,longitude
 */
- (NSString*) makePositionFromCoordinates;

@end
