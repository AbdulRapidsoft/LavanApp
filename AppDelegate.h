//
//  AppDelegate.h
//  LavanApp
//
//  Created by IPHONE-11 on 26/05/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstSideMenuController.h"
#import "SecondSideMenuController.h"
#import "IntroPageViewController.h"
#import "MFSideMenuContainerViewController.h"
#import "CenterViewController.h"
#import "Definition.h"

@interface AppDelegate : UIResponder < UIApplicationDelegate >
{
    
}
@property (strong, nonatomic) UIWindow * window;
@property (strong, nonatomic) UINavigationController * navController;
@property (strong, nonatomic) MFSideMenuContainerViewController * container;
@property (strong, nonatomic) NSMutableArray * cartItemsArray;
@property (strong, nonatomic) NSString * selectedStateId, * selectedCityId;
@property (nonatomic) NSInteger last_selected_row;

+ (AppDelegate *)sharedInstance;
- (void)loadingStart;
- (void)loadingEnd;
- (void)loadingStartWithoutIndicator;
- (void)loadingEndWithoutIndicator;


@end

