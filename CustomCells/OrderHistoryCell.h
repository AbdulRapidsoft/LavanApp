//
//  OrderHistoryCell.h
//  LavanApp
//
//  Created by IPHONE-11 on 09/06/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderHistoryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel * orderDateLbl;
@property (weak, nonatomic) IBOutlet UILabel * orderStatusLbl;
@property (weak, nonatomic) IBOutlet UILabel * noofItemsLbl;
@property (weak, nonatomic) IBOutlet UILabel * totalCostLbl;
@property (weak, nonatomic) IBOutlet UILabel * itemLbl;

+(OrderHistoryCell *)CreateCustomCell:(id)owner;

@end
