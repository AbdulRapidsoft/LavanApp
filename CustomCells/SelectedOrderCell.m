//
//  SelectedOrderCell.m
//  LavanApp
//
//  Created by IPHONE-11 on 02/06/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

#import "SelectedOrderCell.h"

@implementation SelectedOrderCell

@synthesize clothName;
@synthesize clothPrice;
@synthesize batgeNumber;
@synthesize removeButton;

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(SelectedOrderCell *)CreateCustomCell:(id)owner
{
    NSArray * allViews = [[NSBundle mainBundle] loadNibNamed:@"SelectedOrderCell" owner:owner options:nil];
    for (UIView * currentObject in allViews)
    {
        if ([currentObject isKindOfClass:[SelectedOrderCell class]])
        {
            SelectedOrderCell * createdCell = (SelectedOrderCell *)currentObject;
            createdCell.batgeNumber.layer.cornerRadius = 10;
            createdCell.batgeNumber.layer.masksToBounds = YES;
            return createdCell;
        }
    }
    return nil;
}

@end
