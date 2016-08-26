//
//  DatePopoverController.h
//  LavanApp
//
//  Created by IPHONE-11 on 26/08/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//
#import <UIKit/UIKit.h>

@protocol DatePopOverControllerProtocol <NSObject>

- (void)selectedDate:(NSMutableDictionary *)dateDictionary withSelectedTag:(NSInteger)tag andIndex:(NSInteger)indexSelected;

@end

@interface DatePopoverController : UIViewController
{
    __weak IBOutlet UITableView * dateTableView;
    NSMutableArray * date_array;
}

@property (assign) id <DatePopOverControllerProtocol> delegate;
@property (nonatomic) NSInteger selected_tag;
@property (nonatomic) NSInteger selected_index;

@end
