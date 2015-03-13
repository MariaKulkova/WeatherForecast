//
//  ViewController.m
//  WeatherForecast
//
//  Created by Maria on 17.02.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import "ViewController.h"
#import "ForecastViewController.h"
#import "AppDelegate.h"
#import "WFRequestAPIStrings.h"
#import "WFManager.h"

@interface ViewController ()
{
    BOOL showingLeftPanel;
}

/// Gesture recognizer for swipe from left edge which shows side menu
@property(strong, nonatomic) UIScreenEdgePanGestureRecognizer *leftEdgeSwipeRecognizer;

/// Gesture recognizer for left direction swipe which hides side menu
@property(strong, nonatomic) UISwipeGestureRecognizer *leftSwipeRecognizer;

@end

@implementation ViewController

- (id) initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]){
        self.centerViewController = [[CenterViewController alloc] init];
        self.sideMenuViewController = [[SideMenuViewController alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupView];
    [self setupGestures];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Setups view for controllers
- (void)setupView
{
    [self.view addSubview:self.sideMenuViewController.view];
    self.sideMenuViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    self.centerViewController.delegate = self;
    [self.view addSubview:self.centerViewController.view];
    [self addChildViewController:_centerViewController];
    
    [_centerViewController didMoveToParentViewController:self];
}

// Setup gesture recognizers
- (void) setupGestures{
    
    //Swipe from left edge
    self.leftEdgeSwipeRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(showMenuForSwipe:)];
    self.leftEdgeSwipeRecognizer.edges = UIRectEdgeLeft;
    self.leftEdgeSwipeRecognizer.delegate = self;
    [self.view addGestureRecognizer:self.leftEdgeSwipeRecognizer];
    
    //Swipe to the left
    self.leftSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideMenuForSwipe:)];
    self.leftSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:self.leftSwipeRecognizer];
    self.leftSwipeRecognizer.enabled = YES;
}

// Hides side menu when swipe from right to the left is recognized
- (void)hideMenuForSwipe:(UISwipeGestureRecognizer *)gesture {
    
    if (showingLeftPanel == YES){
        [self.view sendSubviewToBack:self.sideMenuViewController.view];
        [[gesture view] bringSubviewToFront:[(UIScreenEdgePanGestureRecognizer*)gesture view]];
        [self movePanelToOriginalPosition];
    }
    
    if (([gesture state] == UIGestureRecognizerStateEnded) || ([gesture state] == UIGestureRecognizerStateCancelled)) {
        self.leftSwipeRecognizer.enabled = NO;
        self.leftEdgeSwipeRecognizer.enabled = YES;
    }
}

// Shows side menu when swipe from left edge is recognized
- (void)showMenuForSwipe:(UIScreenEdgePanGestureRecognizer *)gesture {

    if(UIGestureRecognizerStateRecognized == gesture.state && showingLeftPanel == NO) {
        
        [self.view sendSubviewToBack:self.sideMenuViewController.view];
        [[gesture view] bringSubviewToFront:[(UIScreenEdgePanGestureRecognizer*)gesture view]];
        [self movePanelRight];
        self.leftSwipeRecognizer.enabled = YES;
        self.leftEdgeSwipeRecognizer.enabled = NO;
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    // If gesture is an EdgePan gesture other gesture can be recognized if EdgePanGesture recognation failes
    // It is necessary
    if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]){
        [otherGestureRecognizer requireGestureRecognizerToFail:gestureRecognizer];
        return YES;
    }
    else{
        return NO;
    }
}

// Adds or removes shadow under central view
- (void)showCenterViewWithShadow:(BOOL)value withOffset:(double)offset
{
    if (value)
    {
        [self.centerViewController.view.layer setShadowColor:[UIColor blackColor].CGColor];
        [self.centerViewController.view.layer setShadowOpacity:0.4];
        [self.centerViewController.view.layer setShadowOffset:CGSizeMake(offset, offset)];
        
    }
    else
    {
        [self.centerViewController.view.layer setShadowOffset:CGSizeMake(offset, offset)];
    }
}

// Moves central view to the right to open side menu
-(void) movePanelRight{

    [self showCenterViewWithShadow:YES withOffset:-2];
    [self.view sendSubviewToBack:self.sideMenuViewController.view];
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _centerViewController.view.frame = CGRectMake(self.view.frame.size.width - 60, 0, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             
                             showingLeftPanel = YES;
                         }
                     }];
}

// Move central view to original position to hide side menu
- (void) movePanelToOriginalPosition{
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _centerViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             
                             showingLeftPanel = NO;
                             [self showCenterViewWithShadow:NO withOffset:0];
                         }
                     }];
}

@end
