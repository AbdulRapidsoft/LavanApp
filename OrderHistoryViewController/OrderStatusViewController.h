//
//  OrderStatusViewController.h
//  LavanApp
//
//  Created by IPHONE-11 on 09/06/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"
#import "MFSideMenu.h"
#import "OrderStatusCell.h"
#import "OrderHistoryCell.h"
#import "AppDelegate.h"
#import "WebCommunication.h"
#import "Utility.h"
#import "PlaceOrderViewController.h"
#import "RSTAlertView.h"

@interface OrderStatusViewController : UIViewController < UITableViewDelegate, UITableViewDataSource >
{
    __weak IBOutlet UIButton * newOrderButton;
    __weak IBOutlet UITableView * historyTable;
    __weak IBOutlet UILabel * orderNumberLbl;
    __weak IBOutlet UIImageView * firstOrderStatusImg;
    __weak IBOutlet UIImageView * secondOrderStatusImg;
    __weak IBOutlet UIImageView * thirdOrderStatusImg;
    __weak IBOutlet UIImageView * fourthOrderStatusImg;
    __weak IBOutlet UIImageView * fifthOrderStatusImg;
    __weak IBOutlet TPKeyboardAvoidingScrollView * scroll_view;
        __weak IBOutlet NSLayoutConstraint * tableHeightConstraint;
    __weak IBOutlet NSLayoutConstraint * detailViewHeightConstraint;
    __weak IBOutlet NSLayoutConstraint * mainViewHeightConstraint;
    __weak IBOutlet NSLayoutConstraint * scrollviewHeightConstraint;
    
    BOOL isDetailViewLoad;
    NSMutableArray * historyofOrderArr;
}

- (IBAction)newOrderBtnClicked:(UIButton *)sender;
- (IBAction)backToPreviousBtnClicked:(UIButton *)sender;

@end
