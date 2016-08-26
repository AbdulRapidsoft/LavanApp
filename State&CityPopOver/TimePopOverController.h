//
//  TimePopOverController.h
//  LavanApp
//
//  Created by IPHONE-11 on 24/08/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TimePopOverControllerProtocol <NSObject>

- (void)selectedTimeSlot:(NSString *)timeSlot withSelectedTag:(NSInteger)tag andIndex:(NSInteger)indexSelected;

@end

@interface TimePopOverController : UIViewController
{
    __weak IBOutlet UITableView * timeslotTableView;
    NSMutableArray * time_array;
}

@property (assign) id <TimePopOverControllerProtocol> delegate;
@property (strong, nonatomic) NSString * selected_date_string;
@property (strong, nonatomic) NSString * selected_time_string;
@property (nonatomic) NSInteger selected_tag;
@property (nonatomic) NSInteger selected_index;

@end
