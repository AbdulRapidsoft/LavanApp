//
//  LoginViewController.h
//  LavanApp
//
//  Created by IPHONE-10 on 5/26/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Definition.h"
#import "Utility.h"
#import "WebCommunication.h"
#import "RSTAlertView.h"
#import "MFSideMenu.h"
#import "FirstSideMenuController.h"
#import "CenterViewController.h"
#import "PlaceOrderViewController.h"
#import "RSTAlertView.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface LoginViewController : UIViewController < UITextFieldDelegate >
{
    __weak IBOutlet UITextField * usernameField;
    __weak IBOutlet UITextField * passwordField;
    __weak IBOutlet UIView *containerView;
    __weak IBOutlet UIButton *loginButton;
    __weak IBOutlet UIButton *facebookButton;

    FBSDKLoginManager * login;
    NSString * accessToken;
    NSString * appID;
    NSString * userID;
}

- (IBAction)forgotPasswordClicked:(UIButton *)sender;
- (IBAction)loginButtonClicked:(UIButton *)sender;
- (IBAction)loginViaFBClicked:(UIButton *)sender;

@end
