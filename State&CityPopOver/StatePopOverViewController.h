//
//  StatePopOverViewController.h
//  LavanApp
//
//  Created by IPHONE-10 on 6/25/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceOrderViewController.h"

@protocol StatePopOverViewControllerProtocol <NSObject>

-(void)setState:(NSString *)stateName withSelectedID:(NSString *)stateID;

@end

@interface StatePopOverViewController : UIViewController
{
    __weak IBOutlet UITableView * stateListTableView;
}

@property (assign) id <StatePopOverViewControllerProtocol> delegate;
@property (strong, nonatomic) NSDictionary * statesDict;
@end
