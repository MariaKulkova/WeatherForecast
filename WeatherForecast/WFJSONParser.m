//
//  WFJSONParser.m
//  WeatherForecast
//
//  Created by Maria on 19.02.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import "WFJSONParser.h"

@implementation WFJSONParser

+ (WFDaily*) getDailyForecastForJSON:(NSMutableDictionary *)hourlyConditions{
    
    WFDaily *dailyForecast = [[WFDaily alloc] init];
    
    NSMutableDictionary *weatherForDay = [[hourlyConditions objectForKey:@"weather"] objectAtIndex:0];
    dailyForecast.dayDate = [weatherForDay objectForKey:@"date"];
    
    // receives current weather conditions
    dailyForecast.currentConditions = [WFJSONParser getCurrentConditionsForJSON:hourlyConditions];
    // receives weather forecast by hours
    dailyForecast.hourlyConditions = [WFJSONParser getHourlyForecastForJSON:[weatherForDay objectForKey:@"hourly"]];

    return dailyForecast;
}


+ (NSArray*) getLocationForecastForJSON:(NSMutableDictionary *)currentConditions
                     withAverageConditions:(NSMutableDictionary *)averageConditions
                      withHourlyConditions:(NSMutableDictionary *)hourlyConditions{
    
    NSMutableArray *forecastForLocation = [[NSMutableArray alloc] init];
    
    // receive average weather conditions for all days
    NSMutableArray *weatherAverage = [averageConditions objectForKey:@"weather"];
    // receive hourly weather conditions for all days
    NSMutableArray *weatherHourly = [hourlyConditions objectForKey:@"weather"];
    
    // create day forecast representing objects
    for (int i = 0; i < weatherAverage.count; i++) {
        NSMutableDictionary *currentDayAverage = [weatherAverage objectAtIndex:i];
        NSMutableDictionary *currentDayHourly = [weatherHourly objectAtIndex:i];
        WFDaily *dayWeather = [[WFDaily alloc] init];
        
        dayWeather.dayDate = [currentDayAverage objectForKey:@"date"];
        // for today current conditions are not average. They are contained in special section
        if (i == 0){
            dayWeather.currentConditions = [WFJSONParser getCurrentConditionsForJSON:currentConditions];
        }
        else{
            // for other days average conditions are contained in hourly section but there is only one value in this section for a whole day
            dayWeather.currentConditions = [[WFJSONParser getHourlyForecastForJSON:[currentDayAverage objectForKey:@"hourly"]] objectAtIndex:0];
        }
        
        dayWeather.hourlyConditions = [WFJSONParser getHourlyForecastForJSON:[currentDayHourly objectForKey:@"hourly"]];
        
        [forecastForLocation addObject:dayWeather];
    }

    return [NSArray arrayWithArray:forecastForLocation];
}

+ (WFConditions*) getCurrentConditionsForJSON: (NSMutableDictionary*) dataDictionary{
    
    NSMutableDictionary *currentConditions = [[dataDictionary objectForKey:@"current_condition"] objectAtIndex:0];
    WFConditions* weatherConditions = [[WFConditions alloc] init];
    
    if (currentConditions != nil){
        weatherConditions.forcastDateTime = [currentConditions objectForKey:@"observation_time"];
        weatherConditions.weatherType = (WFWeatherType)[[currentConditions objectForKey:@"weatherCode"] integerValue];
        weatherConditions.temperature = [[currentConditions objectForKey:@"temp_C"] doubleValue];
    }
    else{
        weatherConditions = nil;
    }
    
    return weatherConditions;
}

+ (WFConditions*) getConditionByHourForJSON: (NSMutableDictionary*) dataDictionary{
    
    WFConditions *weatherConditions = [[WFConditions alloc] init];
    
    if (dataDictionary != nil){
        weatherConditions.forcastDateTime = [dataDictionary objectForKey:@"time"];
        weatherConditions.weatherType = (WFWeatherType)[[dataDictionary objectForKey:@"weatherCode"] integerValue];
        weatherConditions.temperature = [[dataDictionary objectForKey:@"tempC"] doubleValue];
    }
    else{
        weatherConditions = nil;
    }
    
    return weatherConditions;

}

+ (NSMutableArray*) getHourlyForecastForJSON: (NSMutableDictionary*) dataDictionary{
    
    NSMutableArray *weatherForcastByHours = [[NSMutableArray alloc] init];
    
    for (NSMutableDictionary *weatherAtHour in dataDictionary) {
        [weatherForcastByHours addObject:[WFJSONParser getConditionByHourForJSON:weatherAtHour]];
    }
    
    return weatherForcastByHours;
}

@end
