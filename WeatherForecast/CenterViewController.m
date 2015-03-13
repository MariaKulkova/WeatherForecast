//
//  CenterViewController.m
//  WeatherForecast
//
//  Created by Maria on 13.03.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import "CenterViewController.h"
#import "ForecastViewController.h"

@interface CenterViewController ()
{
    // array with background colors for testing background color changing
    NSArray *colors;
    
    // Array with controllers which represents weather forecast for day
    NSMutableArray *forecastControllersArray;
    
    // Indicates what page (view) is being now showed
    int currentPageIndex;
}
@end

@implementation CenterViewController

- (id) init{
    if (self = [super init]){
        forecastControllersArray = [[NSMutableArray alloc] init];
        
        // Adds controllers for forecast representation
        for (int i = 0; i < 5; i++) {
            ForecastViewController *controller = [[ForecastViewController alloc] init];
            [forecastControllersArray addObject:controller];
        }
        
        // array with test colors. Temporary!
        colors = [NSArray arrayWithObjects:
                  [UIColor colorWithRed:0.90 green:0.90 blue:1 alpha:1],
                  [UIColor colorWithRed:0.69 green:0.89 blue:0.90 alpha:1],
                  [UIColor colorWithRed:1 green:0.85 blue:0.72 alpha:1],
                  [UIColor colorWithRed:0.98 green:0.94 blue:0.90 alpha:1],
                  [UIColor colorWithRed:1 green:0.90 blue:0.70 alpha:1], nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self calculateViewsFrames:[self receiveFrameForOrientation:self.interfaceOrientation]];
    
    self.view.backgroundColor = [colors objectAtIndex:0];
    
    // Add controllers views
    for (ForecastViewController *controller in forecastControllersArray){
        [self.pagingScrollView addSubview:controller.view];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView{
    
    // receive current horizontal offset in scroll view
    CGFloat currentHorizontalOffset = scrollView.contentOffset.x;
    [self scrollView:scrollView didScrollToPercentageOffset:CGPointMake(currentHorizontalOffset, 0)];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    // When scrolling movement comes to a halt in scroll view with paging enabled it indicates next page transition
    // So it calculates current page number
    CGRect orientationFrame = [self receiveFrameForOrientation:self.interfaceOrientation];
    CGFloat maximumHorizontalOffset = orientationFrame.size.width;
    currentPageIndex = scrollView.contentOffset.x / maximumHorizontalOffset;
}

- (void)scrollView:(UIScrollView *)scrollView didScrollToPercentageOffset:(CGPoint)horizontalOffset{
    
    // set intermediate color for main view's background
    self.view.backgroundColor = [self RGBColorForOffsetPercentage:horizontalOffset.x];
}

// Calculates intermediate color between two views' background colors based on offset in scroll view
- (UIColor *)RGBColorForOffsetPercentage:(CGFloat)horizontalOffset {
    
    // Receive right screen frame
    CGRect orientationFrame = [self receiveFrameForOrientation:self.interfaceOrientation];
    
    CGFloat maximumHorizontalOffset = orientationFrame.size.width;
    int currentViewIndex = horizontalOffset / maximumHorizontalOffset;
    
    // Calculate horizontal offset between two neighbour views.
    // In the other words it represents position of views boundary relatively to left edge of screen
    CGFloat percentage = (horizontalOffset - maximumHorizontalOffset * currentViewIndex) / maximumHorizontalOffset;
    
    // get color components of background value of view which is to the left from the views boundary
    UIColor *startColor = [colors objectAtIndex:currentViewIndex];
    CGFloat minColorRed;
    CGFloat minColorGreen;
    CGFloat minColorBlue;
    CGFloat minColorAlpha;
    [startColor getRed:&minColorRed green:&minColorGreen blue:&minColorBlue alpha:&minColorAlpha];
    
    // get color components of background value of view which is to the right from the views boundary
    UIColor *finishColor;
    if (currentViewIndex == colors.count - 1){
        // if right view is the last set the same color
        finishColor = [colors objectAtIndex:currentViewIndex];
    }
    else{
        // get the next view's background value
        finishColor = [colors objectAtIndex:(currentViewIndex + 1)];
    }
    CGFloat maxColorRed;
    CGFloat maxColorGreen;
    CGFloat maxColorBlue;
    CGFloat maxColorAlpha;
    [finishColor getRed:&maxColorRed green:&maxColorGreen blue:&maxColorBlue alpha:&maxColorAlpha];
    
    // calculate offset color components. It also works if the min value is greater than the max value.
    CGFloat actualRed = (maxColorRed - minColorRed) * percentage + minColorRed;
    CGFloat actualGreen = (maxColorGreen - minColorGreen) * percentage + minColorGreen;
    CGFloat actualBlue = (maxColorBlue - minColorBlue) * percentage + minColorBlue;
    
    return [UIColor colorWithRed:actualRed green:actualGreen blue:actualBlue alpha:1.0];
}

// calculates views frames for current orientation
- (void) calculateViewsFrames: (CGRect) orientationFrame{
    
    self.pagingScrollView.frame = orientationFrame;
    self.pagingScrollView.contentOffset = CGPointMake(currentPageIndex * orientationFrame.size.width, 0);
    for (int i = 0; i < forecastControllersArray.count; i++){
        ForecastViewController *controller = [forecastControllersArray objectAtIndex:i];
        CGRect frame;
        frame.origin.x = orientationFrame.size.width * i;
        frame.origin.y = 0;
        frame.size = orientationFrame.size;
        [controller.view setFrame:frame];
        [controller.refreshScrollView setFrame:CGRectMake(0, 0, orientationFrame.size.width, orientationFrame.size.height)];
    }
    self.pagingScrollView.contentSize = CGSizeMake(orientationFrame.size.width * 5, orientationFrame.size.height);
}

- (void) viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self calculateViewsFrames:[self receiveFrameForOrientation:self.interfaceOrientation]];
}

// Determines screen frame
- (CGRect) receiveFrameForOrientation: (UIInterfaceOrientation) interfaceOrientation{
    CGRect mainFrame = [[UIScreen mainScreen] applicationFrame];
    //mainFrame.size.height += [UIApplication sharedApplication].statusBarFrame.size.height;
    if (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1){
        if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
            return (CGRectMake(mainFrame.origin.x, mainFrame.origin.y, mainFrame.size.width, mainFrame.size.height));
        }
        else{
            return (CGRectMake(mainFrame.origin.x, mainFrame.origin.y, mainFrame.size.height, mainFrame.size.width));
        }
    }
    return mainFrame;
}

@end
