//
//  IntroPageViewController.h
//  GotOil
//
//  Created by IPHONE-10 on 4/27/15.
//  Copyright (c) 2015 IPHONE-10. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChildPageViewController.h"
#import "AppDelegate.h"
#import "SecondSideMenuController.h"
#import "CenterViewController.h"
#import "Utility.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"

@interface IntroPageViewController : UIViewController <UIPageViewControllerDataSource,UIPageViewControllerDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) UIPageViewController * pageController;
@property int index;

- (IBAction)leftButtonTapped:(UIButton *)sender;
- (IBAction)rightButtonTapped:(UIButton *)sender;

@end
