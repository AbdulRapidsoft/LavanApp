//
//  ClothsDetailCell.h
//  LavanApp
//
//  Created by IPHONE-11 on 29/05/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClothsDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView * cellImage;
@property (weak, nonatomic) IBOutlet UILabel * clothName;
@property (weak, nonatomic) IBOutlet UILabel * clothPrice;
@property (weak, nonatomic) IBOutlet UIView * selectedView;
@property (weak, nonatomic) IBOutlet UIButton * leftButton;
@property (weak, nonatomic) IBOutlet UIButton * rightButton;
@property (weak, nonatomic) IBOutlet UILabel * batgeNumber;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView * activityIndicator;

+(ClothsDetailCell *)CreateCustomCell:(id)owner;

@end
