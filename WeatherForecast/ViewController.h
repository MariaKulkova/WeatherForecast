//
//  ViewController.h
//  WeatherForecast
//
//  Created by Maria on 17.02.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) NSString *townName;

@property (strong, nonatomic) NSDictionary *townWeatherDictionary;

@property (weak, nonatomic) IBOutlet UITextField *townTextField;

@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@end

