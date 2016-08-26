//
//  SecondSideMenuController.h
//  LavanApp
//
//  Created by IPHONE-11 on 26/05/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "Definition.h"
#import "MFSideMenu.h"
#import "WebViewController.h"
#import "RSTAlertView.h"
#import "Utility.h"
#import "PricingViewController.h"

@interface SecondSideMenuController : UITableViewController
{
    __weak IBOutlet UIImageView * flagImage;
    __weak IBOutlet UILabel * languageName;
    __weak IBOutlet UILabel *registerBtn;
    __weak IBOutlet UILabel *newOrderBtn;
    __weak IBOutlet UILabel *myAccountBtn;
    __weak IBOutlet UILabel *howItWorksBtn;
    __weak IBOutlet UILabel *priceBtn;
    __weak IBOutlet UILabel *myOrdersBtn;
    __weak IBOutlet UILabel *contactBtn;
    __weak IBOutlet UILabel *termsBtn;
    __weak IBOutlet UILabel *policyBtn;
    __weak IBOutlet UILabel *loginBtn;
}

@end
