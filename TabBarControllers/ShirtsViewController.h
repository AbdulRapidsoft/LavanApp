//
//  ShirtsViewController.h
//  LavanApp
//
//  Created by IPHONE-11 on 28/05/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClothDetails.h"
#import "PendingOperations.h"

@protocol PlaceOrderProtocolDelegate <NSObject>

- (void)itemSelectedForPlaceingOrder:(ClothDetails *)selectedItem;
- (void)itemDeselectedForPlaceingOrder:(ClothDetails *)selectedItem;

@end

@interface ShirtsViewController : UITableViewController
{
    __weak IBOutlet UITableView * listTableView;
    NSMutableArray * productList;
    NSMutableArray * cellsSelected;
}

@property (nonatomic, weak) id <PlaceOrderProtocolDelegate> delegate;
@property (nonatomic, strong) PendingOperations * pendingOperations;

@property(nonatomic, strong) NSString * catagoryType;

@end
