//
//  WFRequestAPIStrings.h
//  WeatherForecast
//
//  Created by Maria on 17.02.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#ifndef WeatherForecast_WFRequestAPIStrings_h
#define WeatherForecast_WFRequestAPIStrings_h

#define WEATHER_API_LOCALWEATHER_URL @"http://api.worldweatheronline.com/free/v2/weather.ashx?"
#define WEATHER_API_SEARCH_URL @"http://api.worldweatheronline.com/free/v2/search.ashx?"

#define WEATHER_API_FREE_KEY @"eb8da90483065967740c77aeae547"

#define WEATHER_API_PARAMS_REQUIRED @"key=%@&q=%@&format=json"
#define WEATHER_API_PARAMS_CURRENT_CONDITIONS @"fx=no"
#define WEATHER_API_PARAMS_DATE @"date=%@"
#define WEATHER_API_PARAMS_AVERRAGE @"tp=24&cc=no"
#define WEATHER_API_PARAMS_HOURLY @"tp=3&cc=no"

#endif
