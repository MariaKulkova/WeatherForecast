//
//  ViewController.m
//  WeatherForecast
//
//  Created by Maria on 17.02.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "WFRequestAPIStrings.h"
#import "WFManager.h"

@interface ViewController ()

-(void) getCountryInfo;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)searchButtonClick:(id)sender {
    [self getCountryInfo];
//    if (![self.townTextField.text isEqualToString:@""]){
//        self.townName = self.townTextField.text;
//        [self getCountryInfo];
//    }
}

- (void) getCountryInfo{
    
    // Prepare the URL that we'll get the country info data from.
    self.townName = @"Taganrog";
    WFManager *weatherManager = [[WFManager alloc] init];
    [weatherManager getDailyForecastForLocation:self.townName];
}

@end
