//
//  FirstSideMenuController.h
//  LavanApp
//
//  Created by IPHONE-11 on 26/05/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFSideMenu.h"
#import "AppDelegate.h"
#import "Definition.h"
#import "EditProfileViewController.h"
#import "OrderStatusViewController.h"
#import "SubViewViewController.h"
#import "Utility.h"
#import "RSTAlertView.h"
#import "WebViewController.h"
#import "LoginViewController.h"
#import "PricingViewController.h"
#import "ChildPageViewController.h"

@interface FirstSideMenuController : UITableViewController
{
    __weak IBOutlet UILabel * usernameTextField;
    __weak IBOutlet UIImageView * flagImage;
    __weak IBOutlet UILabel * languageName;
}
@end
