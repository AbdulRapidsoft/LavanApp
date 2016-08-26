//
//  SavedCardsViewController.h
//  LavanApp
//
//  Created by IPHONE-10 on 10/13/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "savedCardTableViewCell.h"
#import "Utility.h"
#import "WebCommunication.h"
#import "RSTAlertView.h"
#import "Definition.h"
#import "CreditCardPaymentViewController.h"
#import "SubViewViewController.h"
#import "CheckoutViewController.h"

@interface SavedCardsViewController : UIViewController
{
    __weak IBOutlet NSLayoutConstraint *savedCardsViewHeightConstraint;
    __weak IBOutlet UITableView *savedCardsTableView;
    __weak IBOutlet NSLayoutConstraint *tableViewHeightConstraint;
    __weak IBOutlet UIButton *backBtn;
    __weak IBOutlet UILabel *savedDetails;
    __weak IBOutlet UIButton *newPaymentMethodBtn;
}

@property (strong, nonatomic) NSArray *savedCards;
@end
