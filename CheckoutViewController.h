//
//  CheckoutViewController.h
//  LavanApp
//
//  Created by IPHONE-10 on 10/12/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Braintree/Braintree.h>
#import "BTPaymentMethod.h"
#import "Definition.h"
#import <BTDropInErrorAlert.h>
#import "BTDropInLocalizedString.h"
#import "Utility.h"
#import "WebCommunication.h"
#import "RSTAlertView.h"
#import "SubViewViewController.h"
#import "CreditCardPaymentViewController.h"
#import "SavedCardsViewController.h"
@interface CheckoutViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (weak, nonatomic) IBOutlet UIButton *payPalBtn;
@property (nonatomic, strong) Braintree * brainTree;

@end
