//
//  ForecastViewController.m
//  WeatherForecast
//
//  Created by Maria on 11.03.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import "ForecastViewController.h"
#import "WFDaily.h"
#import "WFConditions.h"

@interface ForecastViewController ()
{
    int representedDayIndex;
    
    WFDaily *dayWeatherForecast;
}

@end

@implementation ForecastViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // For testig
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // For testig
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // For testig
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseCell"];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [NSString stringWithFormat:@"My number is %ld", (long)indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
