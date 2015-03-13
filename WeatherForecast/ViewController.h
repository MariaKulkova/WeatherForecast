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

#define CENTER_TAG 1
#define MENU_PANEL_TAG 2
#define CORNER_RADIUS 4

@interface ViewController : UIViewController <CenterViewControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) CenterViewController *centerViewController;

@property (nonatomic, strong) SideMenuViewController *sideMenuViewController;

@end

