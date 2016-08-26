//
//  AddMoreOrderCell.h
//  LavanApp
//
//  Created by IPHONE-11 on 02/06/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddMoreOrderCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIButton * addMoreButton;
@property (nonatomic, weak) IBOutlet UILabel * textLabel;

+ (AddMoreOrderCell *)createNewCell:(id)owner;

@end
