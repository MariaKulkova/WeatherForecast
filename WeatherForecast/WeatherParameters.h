//
//  WeatherParameters.h
//  WeatherForecast
//
//  Created by Maria on 17.02.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WeatherParameters : NSObject

@property (strong, nonatomic) NSString* weatherType;

@property (strong, nonatomic) NSString* weatherDescription;

@property (strong, nonatomic) UIImage* weatherBackground;

@end
