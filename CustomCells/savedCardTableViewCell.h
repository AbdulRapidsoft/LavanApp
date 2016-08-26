//
//  savedCardTableViewCell.h
//  LavanApp
//
//  Created by IPHONE-10 on 10/13/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface savedCardTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *cardHolderNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *cardNumberLabel;

@property (weak, nonatomic) IBOutlet UIButton *removeCardBtn;

@property (weak, nonatomic) IBOutlet UIImageView *cardImageView;

@end
