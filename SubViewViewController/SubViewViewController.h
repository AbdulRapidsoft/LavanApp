//
//  SubViewViewController.h
//  LavanApp
//
//  Created by IPHONE-10 on 6/10/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubViewViewController : UIViewController
{    
    __weak IBOutlet UIImageView * logoImageView;
    __weak IBOutlet UILabel * congratsLbl;
    __weak IBOutlet UIView * shareView;
    __weak IBOutlet UIView * shareButtonsContainerView;
    __weak IBOutlet UIView * attentionView;
    __weak IBOutlet UIView * zipcodeView;
    __weak IBOutlet UIView * congratulationView;
    __weak IBOutlet UIButton * attentionViewCancleBtn;
    __weak IBOutlet UIButton * attentionViewBackBtn;
    __weak IBOutlet UIButton * congratsViewYourOrderBtn;
    __weak IBOutlet UIButton * congratsViewBackBtn
    ;
    __weak IBOutlet UIButton *closeBtn;
}

@property (nonatomic, strong) NSString * pushType;
@property (nonatomic, strong) NSString * orderNumber;
@property (nonatomic, weak) IBOutlet UIView * backgroundView;

- (IBAction)closeButtonTapped:(UIButton *)sender;
- (IBAction)shareAppButtonClicked:(UIButton *)sender;
- (IBAction)attentionViewButtonClicked:(UIButton *)sender;
- (IBAction)congratulationViewButtonClicked:(UIButton *)sender;

@end
