//
//  GeographyLocation.m
//  WeatherForecast
//
//  Created by Maria on 25.02.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import "GeographyLocation.h"
#import "WFManager.h"
#import "CoreDataHelper.h"

@implementation GeographyLocation

@dynamic areaName;
@dynamic country;
@dynamic latitude;
@dynamic longitude;

- (id) initWithEntity{
    NSManagedObjectContext *currentContext = [CoreDataHelper getCurrentContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"GeographyLocation"
                                              inManagedObjectContext:currentContext];
    self = [[GeographyLocation alloc] initWithEntity:entity insertIntoManagedObjectContext:currentContext];
    NSLog(@"%@", currentContext);
    return self;
}

- (BOOL)isEqualToLocation:(GeographyLocation *)location {
    
    if (!location) {
        return NO;
    }
    
    BOOL haveEqualLatitude = (!self.latitude && !location.latitude) || [self.latitude isEqualToString:location.latitude];
    BOOL haveEqualLongitude = (!self.longitude && !location.longitude) || [self.longitude isEqualToString:location.longitude];
    
    return haveEqualLatitude && haveEqualLongitude;
}

//- (BOOL)isEqual:(id)object {
//    
//    if (self == object) {
//        return YES;
//    }
//    
//    if (![object isKindOfClass:[GeographyLocation class]]) {
//        return NO;
//    }
//    
//    return [self isEqualToLocation:(GeographyLocation*) object];
//}
//
//- (NSUInteger)hash {
//    return [self.latitude hash] ^ [self.longitude hash];
//}

// Makes location position string for service interaction by latitude and longitude concatination
- (NSString*) makePositionFromCoordinates{
    return [NSString stringWithFormat:@"%@,%@", self.latitude, self.longitude];
}

@end
