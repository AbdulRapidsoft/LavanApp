//
//  EditProfileViewController.h
//  LavanApp
//
//  Created by IPHONE-10 on 6/9/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"
#import "AppDelegate.h"
#import "MFSideMenu.h"
#import "Utility.h"
#import "Definition.h"
#import "RSTAlertView.h"
#import "WebCommunication.h"
#import "PlaceOrderViewController.h"

@interface EditProfileViewController : UIViewController <UITextFieldDelegate>
{
    __weak IBOutlet UITextField * nameTextField;
    __weak IBOutlet UITextField * emailTextField;
    __weak IBOutlet UITextField * passwordTextField;
    __weak IBOutlet UITextField * mobileNoTextField;
    __weak IBOutlet UIView * containerView;
    __weak IBOutlet UIButton * saveButton;
    __weak IBOutlet UIButton * checkboxButton;
    __weak IBOutlet UIButton * cancelButton;
    __weak IBOutlet UIButton * showButton;
    
    __weak IBOutlet TPKeyboardAvoidingScrollView * scrollView;
}

@end
