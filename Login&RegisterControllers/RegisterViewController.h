//
//  RegisterViewController.h
//  LavanApp
//
//  Created by IPHONE-10 on 5/26/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"
#import "RSTAlertView.h"
#import "Definition.h"
#import "Utility.h"
#import "WebCommunication.h"
#import "MFSideMenu.h"
#import "FirstSideMenuController.h"
#import "CenterViewController.h"
#import "PlaceOrderViewController.h"
#import "RSTAlertView.h"
#import "SubViewViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "WebViewController.h"

@interface RegisterViewController : UIViewController < UITextFieldDelegate >
{
    __weak IBOutlet UITextField * nameField;
    __weak IBOutlet UITextField * mailField;
    __weak IBOutlet UITextField * confirmMailField;
    __weak IBOutlet UITextField * passwordField;
    __weak IBOutlet UITextField * confirmPassword;
    __weak IBOutlet UITextField * mobileNumberField;
    __weak IBOutlet UITextField *postalCodeTextField;
    __weak IBOutlet UIButton *TermsCheckBoxBtn;
    __weak IBOutlet UILabel *termsLabel;
    __weak IBOutlet NSLayoutConstraint * errorHeightConstraint;
    __weak IBOutlet UIView * errorView;
    __weak IBOutlet UIView * containerView;
    __weak IBOutlet UIButton * registerButton;
    __weak IBOutlet UIButton * checkboxButton;
    __weak IBOutlet UILabel * errorMessageLbl;
    __weak IBOutlet UILabel *pleaseConfirmLabel;
    __weak IBOutlet UIButton *okButton;
    __weak IBOutlet UIButton *resendButton;
    __weak IBOutlet UIButton *fbSignUpBtn;
    __weak IBOutlet UIButton *otpEmailBtn;
    __weak IBOutlet UIView *OTPView;
    __weak IBOutlet UITextField *OTPTextField;
    __weak IBOutlet TPKeyboardAvoidingScrollView * scrollView;
    __weak IBOutlet NSLayoutConstraint * mainScrollViewHeightConstraint;
    __weak IBOutlet NSLayoutConstraint * mainViewHeightConstraint;
    __weak IBOutlet NSLayoutConstraint *passwordTxtFieldHeightConstraint;
    __weak IBOutlet NSLayoutConstraint *repeatPasswordTxtFieldHeightConstraint;
    __weak IBOutlet NSLayoutConstraint *email_passwordVerticalConstraint;
    __weak IBOutlet NSLayoutConstraint *password_confirmPasswordVerticalConstraint;
}

- (IBAction)registrationButtonClicked:(UIButton *)sender;
- (IBAction)checkBoxButtonClicked:(UIButton *)sender;

@end
