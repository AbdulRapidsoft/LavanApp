//
//  ClothsDetailCell.m
//  LavanApp
//
//  Created by IPHONE-11 on 29/05/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

#import "ClothsDetailCell.h"

@implementation ClothsDetailCell

@synthesize cellImage;
@synthesize clothName;
@synthesize clothPrice;
@synthesize selectedView;
@synthesize leftButton;
@synthesize rightButton;
@synthesize batgeNumber;

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(ClothsDetailCell *)CreateCustomCell:(id)owner
{
    NSArray * arr = [[NSBundle mainBundle] loadNibNamed:@"ClothsDetailCell" owner:owner options:nil];
    for (UIView * currentObject in arr)
    {
        if ([currentObject isKindOfClass:[ClothsDetailCell class]])
        {
            ClothsDetailCell * createdCell = (ClothsDetailCell *)currentObject;
            createdCell.batgeNumber.layer.cornerRadius = 12;
            createdCell.batgeNumber.layer.masksToBounds = YES;
//            createdCell.clothName.shadowColor = [UIColor lightGrayColor];
//            createdCell.clothName.shadowOffset = CGSizeMake(1, 1);
//            createdCell.clothPrice.shadowColor = [UIColor lightGrayColor];
//            createdCell.clothPrice.shadowOffset = CGSizeMake(1, 1);

            return createdCell;
        }
    }
    return nil;
}

@end
