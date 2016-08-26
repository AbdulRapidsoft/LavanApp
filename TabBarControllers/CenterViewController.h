//
//  CenterViewController.h
//  LavanApp
//
//  Created by IPHONE-10 on 5/28/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShirtsViewController.h"
#import "ClothDetails.h"
#import "AppDelegate.h"

@interface CenterViewController : UIViewController < UIPageViewControllerDelegate,UIPageViewControllerDataSource,UIScrollViewDelegate >
{
    NSMutableArray * buttonText, *categoryImagesArray;
    __weak IBOutlet UIButton * placeOrderBtn;
}

@property (nonatomic, strong) NSMutableArray * viewControllerArray;
@property (nonatomic, strong) UIView * selectionBar;
@property (nonatomic, strong) UIPanGestureRecognizer * panGestureRecognizer;
@property (nonatomic, strong) UIPageViewController * pageController;
@property (nonatomic, strong) UIView * navigationView;

- (IBAction)placeOrderButtonClicked:(UIButton *)sender;

@end
