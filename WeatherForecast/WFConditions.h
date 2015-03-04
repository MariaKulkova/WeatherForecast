//
//  WFConditions.h
//  WeatherForecast
//
//  Created by Maria on 17.02.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef enum{
    
    WFWeatherTypeClearSunny = 113,
    WFWeatherTypePartlyCloudy = 116,
    WFWeatherTypeCloudy = 119,
    WFWeatherTypeOvercast = 122,
    WFWeatherTypeMist = 143,
    WFWeatherTypePatchyRainNearby = 176,
    WFWeatherTypePatchyShowNearby = 179,
    WFWeatherTypePatchySleetNearby = 182,
    WFWeatherTypePatchyFreezingDrizzleNearby = 185,
    WFWeatherTypeThunderyOutbreaksNearby = 200,
    WFWeatherTypeBlowingSnow = 227,
    WFWeatherTypeBlizzard = 230,
    WFWeatherTypeFog = 248,
    WFWeatherTypeFreezingFog = 260,
    WFWeatherTypePatchyLightDrizzle = 263,
    WFWeatherTypeLightDrizzle = 266,
    WFWeatherTypeFreezingDrizzle = 281,
    WFWeatherTypeHeavyFreezingDrizzle = 284,
    WFWeatherTypePatchyLightRain = 293,
    WFWeatherTypeLightRain = 296,
    WFWeatherTypeModerateRainTimes = 299,
    WFWeatherTypeModerateRain = 302,
    WFWeatherTypeHeavyRainTimes = 305,
    WFWeatherTypeLightFreezingRain = 311,
    WFWeatherTypeModerateHeavyFreezingRain = 314,
    WFWeatherTypeLightSleet = 317,
    WFWeatherTypeModerateHeavySleet = 320,
    WFWeatherTypePatchyLightSnow = 323,
    WFWeatherTypeLightSnow = 326,
    WFWeatherTypePatchyModerateSnow = 329,
    WFWeatherTypeModerateSnow = 332,
    WFWeatherTypePatchyHeavySnow = 335,
    WFWeatherTypeHeavySnow = 338,
    WFWeatherTypeIcePellets = 350,
    WFWeatherTypeLightRainShower = 353,
    WFWeatherTypeModerateHeavyRainShower = 356,
    WFWeatherTypeTorrentialRainShower = 359,
    WFWeatherTypeLightSleetShowers = 362,
    WFWeatherTypeModerateHeavySleetShower = 365,
    WFWeatherTypeLightSnowShowers = 368,
    WFWeatherTypeModerateHeavySnowShowers = 371,
    WFWeatherTypeLightShowersIcePellets = 374,
    WFWeatherTypeModerateHeavyShowersIcePellets = 377,
    WFWeatherTypePatchyLightRainThunder = 386,
    WFWeatherTypeModerateHeavyRainThunder = 389,
    WFWeatherTypePatchyLightSnowThunder = 392,
    WFWeatherTypeModerateHeavySnowThunder = 395
    
}WFWeatherType;


@interface WFConditions : NSManagedObject

@property (strong, nonatomic) NSDate *time;

@property (nonatomic) NSNumber *temperature;

@property (nonatomic) NSNumber *weatherType;

- (id) initWithEntity;

@end
