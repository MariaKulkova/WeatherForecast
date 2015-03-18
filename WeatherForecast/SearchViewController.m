//
//  SearchViewController.m
//  WeatherForecast
//
//  Created by Maria on 14.03.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    CGRect navFrame = self.navigationController.navigationBar.frame;
    
    CGRect searchFrame = self.searchArea.frame;
    searchFrame.origin.x = self.view.frame.origin.x;
    searchFrame.origin.y = navFrame.origin.y + navFrame.size.height;
    searchFrame.size.height = self.view.frame.size.height - navFrame.size.height - navFrame.origin.y;
    searchFrame.size.width = self.view.frame.size.width;
    [self.searchArea setFrame:searchFrame];
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
