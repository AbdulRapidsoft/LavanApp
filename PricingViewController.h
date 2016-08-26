//
//  PricingViewController.h
//  LavanApp
//
//  Created by IPHONE-10 on 10/8/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFSideMenu.h"
#import "PlaceOrderViewController.h"
#import "RSTAlertView.h"
#import "Definition.h"
#import "Utility.h"
#import "WebCommunication.h"
#import "PricingHeaderTableViewCell.h"
#import "PricingDetailsTableViewCell.h"

@interface PricingViewController : UIViewController
{
    __weak IBOutlet UITableView *pricingListTableView;
    __weak IBOutlet UIButton *pricingLabel;
}
@end
