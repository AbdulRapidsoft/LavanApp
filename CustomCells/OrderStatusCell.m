//
//  OrderStatusCell.m
//  LavanApp
//
//  Created by IPHONE-11 on 09/06/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

#import "OrderStatusCell.h"

@implementation OrderStatusCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(OrderStatusCell *)CreateCustomCell:(id)owner
{
    NSArray * arr = [[NSBundle mainBundle] loadNibNamed:@"OrderStatusCell" owner:owner options:nil];
    for (UIView * currentObject in arr)
    {
        if ([currentObject isKindOfClass:[OrderStatusCell class]])
        {
            OrderStatusCell * createdCell = (OrderStatusCell *)currentObject;
            createdCell.noofItemsLbl.layer.cornerRadius = 12;
            createdCell.noofItemsLbl.layer.masksToBounds = YES;
            createdCell.noofItemsLbl.layer.borderColor = [UIColor redColor].CGColor;
            createdCell.noofItemsLbl.layer.borderWidth = 1.0;
            return createdCell;
        }
    }
    return nil;
}


@end
