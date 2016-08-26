//
//  SelectedOrderCell.h
//  LavanApp
//
//  Created by IPHONE-11 on 02/06/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectedOrderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel * clothName;
@property (weak, nonatomic) IBOutlet UILabel * batgeNumber;
@property (weak, nonatomic) IBOutlet UILabel * clothPrice;
@property (weak, nonatomic) IBOutlet UIButton * removeButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;




+(SelectedOrderCell *)CreateCustomCell:(id)owner;

@end
