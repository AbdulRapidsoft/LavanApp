//
//  AddMoreOrderCell.m
//  LavanApp
//
//  Created by IPHONE-11 on 02/06/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

#import "AddMoreOrderCell.h"

@implementation AddMoreOrderCell

@synthesize addMoreButton;
@synthesize textLabel;

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (AddMoreOrderCell *)createNewCell:(id)owner
{
    NSArray * allViews = [[NSBundle mainBundle] loadNibNamed:@"AddMoreOrderCell" owner:owner options:nil];
    for (UIView * currentObject in allViews)
    {
        if ([currentObject isKindOfClass:[AddMoreOrderCell class]])
        {
            AddMoreOrderCell * createdObject = (AddMoreOrderCell *)currentObject;
            return createdObject;
        }
    }
    return nil;
}

@end
