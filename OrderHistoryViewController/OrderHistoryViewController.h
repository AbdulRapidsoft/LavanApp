//
//  OrderHistoryViewController.h
//  LavanApp
//
//  Created by IPHONE-10 on 6/5/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFSideMenu.h"
#import "OrderHistoryCell.h"
#import "AppDelegate.h"
#import "WebCommunication.h"
#import "Utility.h"
#import "PlaceOrderViewController.h"
#import "RSTAlertView.h"

@interface OrderHistoryViewController : UIViewController
{
    __weak IBOutlet UITableView * orderHistoryTable;
    __weak IBOutlet UIButton * newOrderBtn;
    NSMutableArray * historyofOrderArr;
}

- (IBAction)newOrderBtnClicked:(UIButton *)sender;

@end
