//
//  CityPopOverViewController.h
//  LavanApp
//
//  Created by IPHONE-10 on 6/25/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CityPopOverViewControllerProtocol <NSObject>

-(void)setCity:(NSString *)cityName withSelectedID:(NSString *)cityID;

@end

@interface CityPopOverViewController : UIViewController
{
    __weak IBOutlet UITableView * cityListTableView;
}

@property (assign) id <CityPopOverViewControllerProtocol> delegate;
@property (strong, nonatomic) NSDictionary * statesDict;

@end
