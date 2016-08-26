//
//  ForgotPasswordViewController.h
//  LavanApp
//
//  Created by IPHONE-10 on 6/19/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Definition.h"
#import "RSTAlertView.h"
#import "Utility.h"
#import "WebCommunication.h"
#import "AppDelegate.h"
#import "PlaceOrderViewController.h"
#import "RSTAlertView.h"
#import "MFSideMenu.h"

@interface ForgotPasswordViewController : UIViewController
{
    __weak IBOutlet UITextField * emailTextField;
    __weak IBOutlet UIButton * sendButton;
}

- (IBAction)cartButtonClicked:(UIButton *)sender;
- (IBAction)menuButtonClicked:(UIButton *)sender;

@end
