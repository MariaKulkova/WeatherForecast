//
//  WFJSONParser.m
//  WeatherForecast
//
//  Created by Maria on 19.02.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import "WFJSONParser.h"
#import "GeographyLocation.h"
#import "JSONParseException.h"

NSString* const JSONSerializationException = @"JSONSerializationException";
NSString* const LocationParsingException = @"LocationParsingException";
NSString* const CurrentConditionsParsingException = @"CurrentConditionsParsingException";
NSString* const HourlyConditionsParsingException = @"HourlyConditionsParsingException";

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

/**
 Parse json-dictionary received with a help of search API and construct geography location
 @param dataDictionary represents an element of "result" section
 @return GeographyLocation object which represents location
 */
+ (GeographyLocation*) parseGeographyLocation: (NSMutableDictionary*) dataDictionary;

@end

@implementation WFJSONParser

// Parses json object and convert results to weather forecast for today
+ (WFDaily*) parseDailyForecast:(NSData *)dayConditionsData{

    NSError *error;
    NSMutableDictionary *todayWeatherDictionary = [[NSJSONSerialization JSONObjectWithData:dayConditionsData options:kNilOptions error:&error] objectForKey:@"data"];
    WFDaily *dailyForecast = [[WFDaily alloc] init];
    
    if (error != nil){
        // throw exception about json convertion
        @throw [JSONParseException exceptionWithName:JSONSerializationException
                                              reason:@"JSON parsing to dictionary was failed"
                                            userInfo:nil];
    }
    else{
        
        @try{
            NSMutableDictionary *weatherForDay = [[todayWeatherDictionary objectForKey:@"weather"] objectAtIndex:0];
            dailyForecast.dayDate = [weatherForDay objectForKey:@"date"];
            
            // receives current weather conditions
            dailyForecast.currentConditions = [WFJSONParser parseCurrentConditions:todayWeatherDictionary];
            // receives weather forecast by hours
            dailyForecast.hourlyConditions = [WFJSONParser parseHourlyForecast:todayWeatherDictionary];
        }
        @catch(JSONParseException *exception){
            // throw exception about parsing errors
            @throw exception;
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
        @throw [JSONParseException exceptionWithName:JSONSerializationException
                                              reason:@"JSON parsing to dictionary was failed"
                                            userInfo:nil];
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
                    dayWeather.currentConditions = [[WFJSONParser parseHourlyForecast: currentDayAverage] objectAtIndex:0];
                }
                
                dayWeather.hourlyConditions = [WFJSONParser parseHourlyForecast:currentDayHourly];
                
                [forecastForLocation addObject:dayWeather];
            }
        }
        @catch(JSONParseException *exception){
            
            // throw exception about parsing error
            @throw exception;
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
        @throw [JSONParseException exceptionWithName:JSONSerializationException
                                              reason:@"JSON convertion to dictionary failed"
                                            userInfo:nil];
    }
    else{
        
        @try {
            // receive names of locations and put it into array
            NSMutableArray *locationsSet = [queryResult objectForKey:@"result"];
            for (NSMutableDictionary *item in locationsSet) {
                [locationsNames addObject:[WFJSONParser parseGeographyLocation:item]];
            }
        }
        @catch (JSONParseException *exception) {
            
            // throw exception about parsing error
            @throw exception;
        }
    }
    
    return [NSArray arrayWithArray:locationsNames];
}

// Parse json-dictionary received with a help of search API and convert element of "result" section to geography location
+ (GeographyLocation*) parseGeographyLocation: (NSMutableDictionary*) dataDictionary{
    
    GeographyLocation *location = [[GeographyLocation alloc] init];
    
    if (dataDictionary != nil){
        
        @try {
            location.areaName = [[[dataDictionary objectForKey:@"areaName"] objectAtIndex:0] objectForKey:@"value"];
            location.country = [[[dataDictionary objectForKey:@"country"] objectAtIndex:0] objectForKey:@"value"];
            location.latitude = [dataDictionary objectForKey:@"latitude"];
            location.longitude = [dataDictionary objectForKey:@"longitude"];
        }
        @catch (NSException *exception) {
            
            // throw exception about location parameters parsing error
            @throw [NSException exceptionWithName:LocationParsingException
                                           reason:@"Required location parameters weren't found"
                                         userInfo:nil];
        }
    }
    else{
        location = nil;
    }
    
    return location;
}

// Parse json-dictionary and convert section of "current_conditions" to WFConditions object
+ (WFConditions*) parseCurrentConditions: (NSMutableDictionary*) dataDictionary{
    
    WFConditions* weatherConditions = [[WFConditions alloc] init];
    @try {
        
        NSMutableDictionary *currentConditions = [[dataDictionary objectForKey:@"current_condition"] objectAtIndex:0];
        
        if (currentConditions != nil){
            weatherConditions.forcastDateTime = [currentConditions objectForKey:@"observation_time"];
            weatherConditions.weatherType = (WFWeatherType)[[currentConditions objectForKey:@"weatherCode"] integerValue];
            weatherConditions.temperature = [[currentConditions objectForKey:@"temp_C"] doubleValue];
        }
        else{
            weatherConditions = nil;
        }
    }
    @catch (NSException *exception) {
       
        // throw exception about current conditions parameters parsing error
        @throw [JSONParseException exceptionWithName:CurrentConditionsParsingException
                                              reason:@"Required current conditions parameters weren't found"
                                            userInfo:nil];

    }
    
    return weatherConditions;
}

// Parse json-dictionary and construct conditions object
+ (WFConditions*) parseHourlyConditions: (NSMutableDictionary*) dataDictionary{
    
    WFConditions *weatherConditions = [[WFConditions alloc] init];
    
    if (dataDictionary != nil){
        @try {
            weatherConditions.forcastDateTime = [WFJSONParser parseTime:[dataDictionary objectForKey:@"time"]];
            weatherConditions.weatherType = (WFWeatherType)[[dataDictionary objectForKey:@"weatherCode"] integerValue];
            weatherConditions.temperature = [[dataDictionary objectForKey:@"tempC"] doubleValue];
        }
        @catch (NSException *exception) {
            
            // throw exception about hourly conditions parameters parsing error
            @throw [JSONParseException exceptionWithName:HourlyConditionsParsingException
                                                  reason:@"Required current conditions parameters weren't found"
                                                userInfo:nil];
        }
    }
    else{
        weatherConditions = nil;
    }
    
    return weatherConditions;

}

// Parse json-dictionary and construct hourly weather forecast
+ (NSMutableArray*) parseHourlyForecast: (NSMutableDictionary*) dataDictionary{
    
    NSMutableArray *weatherForcastByHours = [[NSMutableArray alloc] init];
    @try {
        NSMutableArray* hourlyWeather = [dataDictionary objectForKey:@"hourly"];
        for (NSMutableDictionary *weatherAtHour in hourlyWeather) {
            [weatherForcastByHours addObject:[WFJSONParser parseHourlyConditions:weatherAtHour]];
        }
    }
    @catch (JSONParseException *exception) {
        
        @throw exception;
    }
    
    return weatherForcastByHours;
}

+ (NSDate*) parseTime: (NSString*) timeString{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    NSDate* date;
    
    int timeValue = [timeString integerValue];
    int hours = timeValue / 100;
    int minutes = timeValue % 100;
    
    if (hours > 23 || hours < 0 || minutes > 59 || minutes < 0){
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:@"String representing time is incorrect"
                                     userInfo:nil];
    }
    else{
        dateComponents.second = 0;
        dateComponents.hour = hours;
        dateComponents.minute = minutes;
        date = [calendar dateFromComponents:dateComponents];
    }
    return date;
}

@end
