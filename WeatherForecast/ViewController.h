//
//  ViewController.h
//  WeatherForecast
//
//  Created by Maria on 17.02.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "WFManager.h"
#import "CenterViewController.h"
#import "SideMenuViewController.h"
#import "SearchViewController.h"

@interface ViewController : UIViewController <CenterViewControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) CenterViewController *centerViewController;

@property (nonatomic, strong) SideMenuViewController *sideMenuViewController;

@property (nonatomic, strong) SearchViewController *searchViewController;

@end

