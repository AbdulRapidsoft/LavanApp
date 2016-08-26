//
//  LocationPopoverController.h
//  LavanApp
//
//  Created by IPHONE-11 on 19/08/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceOrderViewController.h"

@protocol LocationPopOverControllerProtocol <NSObject>

-(void)selectedLocation:(NSString *)locationName;

@end

@interface LocationPopoverController : UIViewController
{
    
}

@property (assign) id <LocationPopOverControllerProtocol> delegate;
@property (strong, nonatomic) NSMutableArray * locationsArray;
@property (strong, nonatomic) IBOutlet UITableView * locationListTableView;

@end
