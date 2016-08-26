//
//  ChildPageViewController.h
//  GotOil
//
//  Created by IPHONE-10 on 4/27/15.
//  Copyright (c) 2015 IPHONE-10. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "WebCommunication.h"
#import "Definition.h"
#import "Utility.h"
#import "SubViewViewController.h"
#import "RSTAlertView.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"

@protocol PostalCodeSuccessDelegate <NSObject>

- (void)postalCodeSuccessfullySendToServer;

@end

@interface ChildPageViewController : UIViewController < UITextFieldDelegate >
{
    __weak IBOutlet UITextField * zipcodeField;
    __weak IBOutlet UIButton * zipcodeButton;
    __weak IBOutlet UIImageView * imageView;
    __weak IBOutlet UIButton *registerButton;
    __weak IBOutlet UIButton *loginBtn;
    __weak IBOutlet UILabel *walkthroughTextview;
}

@property (nonatomic, weak) id <PostalCodeSuccessDelegate> delegate;
@property (assign, nonatomic) NSInteger index;

- (IBAction)zipcodeButtonClicked:(UIButton *)sender;

@end
