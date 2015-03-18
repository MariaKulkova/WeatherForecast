//
//  Helper.m
//  WeatherForecast
//
//  Created by Maria on 18.03.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import "Helper.h"

@implementation Helper


// Determines screen frame
+ (CGRect) receiveFrameForOrientation: (UIInterfaceOrientation) interfaceOrientation{
    CGRect mainFrame = [[UIScreen mainScreen] applicationFrame];
    //    mainFrame.size.height += [UIApplication sharedApplication].statusBarFrame.size.height;
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
