//
//  ForecastViewController.h
//  WeatherForecast
//
//  Created by Maria on 11.03.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForecastViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *currentTemperature;

@property (weak, nonatomic) IBOutlet UILabel *currentWeather;

@property (weak, nonatomic) IBOutlet UITableView *hourlyForecastTable;

@property (weak, nonatomic) IBOutlet UIScrollView *refreshScrollView;

@end
