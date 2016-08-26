//
//  CreditCardPaymentViewController.h
//  LavanApp
//
//  Created by IPHONE-10 on 10/12/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Braintree/Braintree.h>
#import "BTPaymentMethod.h"
#import "Definition.h"
#import "RSTAlertView.h"
#import "Utility.h"
#import "WebCommunication.h"
#import "SubViewViewController.h"
#import <BTDropInErrorAlert.h>
#import "BTDropInLocalizedString.h"
@interface CreditCardPaymentViewController : UIViewController {
    __weak IBOutlet UITextField *cardHolderNameTxtField;
    __weak IBOutlet UITextField *cardNumberTxtField;
    __weak IBOutlet UITextField *expiryDateTxtField;
    __weak IBOutlet UITextField *cvcTxtField;
    __weak IBOutlet UIButton *checkBoxBtn;
    __weak IBOutlet UILabel *saveCardLabel;
    __weak IBOutlet UIButton *checkOutBtn;
    __weak IBOutlet UIButton *payPalBtn;
    __weak IBOutlet UIButton *backBtn;
    __weak IBOutlet UIButton *cardNoButton;
    
}

@property (nonatomic, strong) Braintree * brainTree;
@property (nonatomic, strong) NSDictionary *cardDetailsDict;

@end
