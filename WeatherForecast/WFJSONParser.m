//
//  WFJSONParser.m
//  WeatherForecast
//
//  Created by Maria on 19.02.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import "WFJSONParser.h"
#import "GeographyLocation.h"

@interface WFJSONParser ()

/**
 Parse json-dictionary and convert section of "current_conditions" to WFConditions object
 @param dataDictionary represents json-dictionary received from server and parsed from NSData
 @return WFCondition object which corresponds to current weather conditions
 */
+ (WFConditions*) parseCurrentConditions: (NSMutableDictionary*) dataDictionary;

/**
 Parse json-dictionary and construct conditions object
 @param dataDictionary represents element of "hourly"-section in common json-dictionary
 @return WFConditions object which represents wether forecast for specified moment
 */
+ (WFConditions*) parseHourlyConditions: (NSMutableDictionary*) dataDictionary;

/**
 Parse json-dictionary and construct hourly weather forecast
 @param dataDictionary represents "hourly" section of common dictionary
 @return array of weather conditions which corresponds to hourly weather forecast
 */
+ (NSMutableArray*) parseHourlyForecast: (NSMutableDictionary*) dataDictionary;

@end

@implementation WFJSONParser

// Parses json object and convert results to weather forecast for today
+ (WFDaily*) parseDailyForecast:(NSData *)todayConditionsData{

    NSError *error;
    NSMutableDictionary *todayWeatherDictionary = [[NSJSONSerialization JSONObjectWithData:todayConditionsData options:kNilOptions error:&error] objectForKey:@"data"];
    WFDaily *dailyForecast = [[WFDaily alloc] init];
    
    if (error != nil){
        // throw exception about json convertion
    }
    else{
        
        @try{
            NSMutableDictionary *weatherForDay = [[todayWeatherDictionary objectForKey:@"weather"] objectAtIndex:0];
            dailyForecast.dayDate = [weatherForDay objectForKey:@"date"];
            
            // receives current weather conditions
            dailyForecast.currentConditions = [WFJSONParser parseCurrentConditions:todayWeatherDictionary];
            // receives weather forecast by hours
            dailyForecast.hourlyConditions = [WFJSONParser parseHourlyForecast:[todayWeatherDictionary objectForKey:@"hourly"]];
        }
        @catch(NSException *exception){
            // throw exception about parsing errors
        }
    }

    return dailyForecast;
}


// Parses three json objects and convert results to array of all available days forecast
+ (NSArray*) parseLocationForecast:(NSData *)currentConditionsData
                     withAverageConditions:(NSData *)averageConditionsData
                      withHourlyConditions:(NSData *)hourlyConditionsData{
    
    // Convert json from NSData to dictionary
    NSError *currentParsingError;
    NSError *averageParsingError;
    NSError *hourlyParsingError;
    
    NSMutableDictionary *currentConditions = [[NSJSONSerialization JSONObjectWithData:currentConditionsData options:kNilOptions error:&currentParsingError] objectForKey:@"data"];
    NSMutableDictionary *averageConditions = [[NSJSONSerialization JSONObjectWithData:averageConditionsData options:kNilOptions error:&averageParsingError] objectForKey:@"data"];
    NSMutableDictionary *hourlyConditions = [[NSJSONSerialization JSONObjectWithData:hourlyConditionsData options:kNilOptions error:&hourlyParsingError] objectForKey:@"data"];
    
    NSMutableArray *forecastForLocation = [[NSMutableArray alloc] init];
    if ((currentParsingError != nil) || (averageParsingError != nil) || (hourlyParsingError != nil)) {
        // throw exception about json convertion exception
    }
    else{
        
        @try{
            
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
                    dayWeather.currentConditions = [WFJSONParser parseCurrentConditions:currentConditions];
                }
                else{
                    // for other days average conditions are contained in hourly section but there is only one value in this section for a whole day
                    dayWeather.currentConditions = [[WFJSONParser parseHourlyForecast:[currentDayAverage objectForKey:@"hourly"]] objectAtIndex:0];
                }
                
                dayWeather.hourlyConditions = [WFJSONParser parseHourlyForecast:[currentDayHourly objectForKey:@"hourly"]];
                
                [forecastForLocation addObject:dayWeather];
            }
        }
        @catch(NSException *exception){
            
            // throw exception about parsing error
        }
    }
    
    return [NSArray arrayWithArray:forecastForLocation];
}

// Parses json object and convert results to location objects
+ (NSArray*) parseLocationsSet:(NSData *)queryResultData{
    
    NSError *error;
    NSMutableDictionary *queryResult = [[NSJSONSerialization JSONObjectWithData:queryResultData options:kNilOptions error:&error] objectForKey:@"search_api"];
    NSMutableArray *locationsNames = [[NSMutableArray alloc] init];
    
    if (error != nil){
        // throw exception about json convertion problems
    }
    else{
        
        @try {
            // receive names of locations and put it into array
            NSMutableArray *locationsSet = [queryResult objectForKey:@"result"];
            for (NSMutableDictionary *item in locationsSet) {
                [locationsNames addObject:[WFJSONParser parseGeographyLocation:item]];
            }
        }
        @catch (NSException *exception) {
            // throw exception about parsing error
        }
    }
    
    return [NSArray arrayWithArray:locationsNames];
}

+ (GeographyLocation*) parseGeographyLocation: (NSMutableDictionary*) dataDictionary{
    GeographyLocation *location = [[GeographyLocation alloc] init];
    
    if (dataDictionary != nil){
        location.areaName = [[[dataDictionary objectForKey:@"areaName"] objectAtIndex:0] objectForKey:@"value"];
        location.country = [[[dataDictionary objectForKey:@"country"] objectAtIndex:0] objectForKey:@"value"];
        location.latitude = [dataDictionary objectForKey:@"latitude"];
        location.longitude = [dataDictionary objectForKey:@"longitude"];
    }
    else{
        location = nil;
    }
    
    return location;
}

// Parse json-dictionary and convert section of "current_conditions" to WFConditions object
+ (WFConditions*) parseCurrentConditions: (NSMutableDictionary*) dataDictionary{
    
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

// Parse json-dictionary and construct conditions object
+ (WFConditions*) parseHourlyConditions: (NSMutableDictionary*) dataDictionary{
    
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

// Parse json-dictionary and construct hourly weather forecast
+ (NSMutableArray*) parseHourlyForecast: (NSMutableDictionary*) dataDictionary{
    
    NSMutableArray *weatherForcastByHours = [[NSMutableArray alloc] init];
    
    for (NSMutableDictionary *weatherAtHour in dataDictionary) {
        [weatherForcastByHours addObject:[WFJSONParser parseHourlyConditions:weatherAtHour]];
    }
    
    return weatherForcastByHours;
}

@end
