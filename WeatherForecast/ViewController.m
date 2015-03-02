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

@synthesize managedObjectContext;

- (id) init{
    if (self = [super init]){
        weatherForecastManager = [[WFManager alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)searchButtonClick:(id)sender {
    if (![self.townTextField.text isEqualToString:@""]) {
        self.townName = self.townTextField.text;
        [self getCountryInfo];
    }
}

- (void) getCountryInfo{

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        weatherForecastManager = [[WFManager alloc] init];
        GeographyLocation* location = [[GeographyLocation alloc] init];
        location.areaName = @"Taganrog";
        location.country = @"Russia";
        location.latitude = @"47.221";
        location.longitude = @"38.909";
        
        [weatherForecastManager getForecastForLocation:location withCompletionHandler:^(WFLocation *locationForecast) {
            
            // Check if any data returned.
            if (locationForecast != nil) {
                WFDaily *today = [locationForecast.locationForecast objectAtIndex:0];
                NSLog(@"Temperature in %@ is %f C", locationForecast.location.areaName, today.currentConditions.temperature);
            }
        }];
//
//        [weatherForecastManager getLocationsForSearchingWord:self.townName withCompletionHandler:^(NSArray *locationsList) {
//            if (locationsList != nil){
//                NSLog(@"%@", locationsList);
//            }
//        }];
    });
}

@end
