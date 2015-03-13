//
//  SideMenuViewController.h
//  WeatherForecast
//
//  Created by Maria on 13.03.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SideMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
