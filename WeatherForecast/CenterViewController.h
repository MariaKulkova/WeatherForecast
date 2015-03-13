//
//  CenterViewController.h
//  WeatherForecast
//
//  Created by Maria on 13.03.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CenterViewControllerDelegate <NSObject>

@optional
- (void)movePanelRight;

@required
- (void)movePanelToOriginalPosition;

@end


@interface CenterViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, assign) id<CenterViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIScrollView *pagingScrollView;

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

- (CGRect) receiveFrameForOrientation: (UIInterfaceOrientation) interfaceOrientation;

@end
