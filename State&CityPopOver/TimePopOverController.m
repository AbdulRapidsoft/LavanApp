//
//  TimePopOverController.m
//  LavanApp
//
//  Created by IPHONE-11 on 24/08/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

#import "TimePopOverController.h"
#import "Definition.h"

@interface TimePopOverController ()
{
    NSDateFormatter * timeFormatter;
}
@property (nonatomic, assign) int num;

@end

@implementation TimePopOverController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"Choose Hour", nil);
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [timeFormatter setDateFormat:@"HH"];
    NSString * time_str = [timeFormatter stringFromDate:[NSDate date]];
    
    time_array = [[NSMutableArray alloc] init];
//    BOOL isSat = [[NSUserDefaults standardUserDefaults] boolForKey:@"isSat"];
//    BOOL isSun = [[NSUserDefaults standardUserDefaults] boolForKey:@"isSun"];

    if (self.selected_tag == 1093)
    {
        int available_hour = [time_str intValue] + 1;
        if ([self.selected_date_string isEqualToString:@"hoy"])
        {
            if ([Utility sharedInstance].isSatPick)
            {
                if (available_hour <= 4)
                {
                    // All cells available for selection
                    for (int i = 9; i < 22; i++)
                    {
                        [time_array addObject:[NSString stringWithFormat:@"%.2d:00-%.2d:00", i, i + 1]];
                    }
                }
                else
                {
                    BOOL haveSlots = NO;
                    // upto three options are not available
                    for (int i = available_hour + 3; i < 15; i++)
                    {
                        haveSlots = YES;
                        [time_array addObject:[NSString stringWithFormat:@"%.2d:00-%.2d:00", i, i + 1]];
                    }
                    if (!haveSlots) {
                        [RSTAlertView showAlertMessage:kNoSlotsAlert withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
                            if (buttonIndex == 0) {
                                [self.navigationController popViewControllerAnimated:YES];
                            }
                        }];
                    }
                }
            }
            if ([Utility sharedInstance].isSunPick)
            {
                if (available_hour <= 4)
                {
                    // All cells available for selection
                    for (int i = 9; i < 22; i++)
                    {
                        [time_array addObject:[NSString stringWithFormat:@"%.2d:00-%.2d:00", i, i + 1]];
                    }
                }
                else
                {
                    BOOL haveSlots = NO;
                    // upto three options are not available

                        for (int i = available_hour + 3; i < 21; i++)
                        {
                        if (i >= 15)
                        {
                            haveSlots = YES;
                            [time_array addObject:[NSString stringWithFormat:@"%.2d:00-%.2d:00", i, i + 1]];
                        }
                        }
                        if (!haveSlots) {
                            [RSTAlertView showAlertMessage:kNoSlotsAlert withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
                                if (buttonIndex == 0) {
                                    [self.navigationController popViewControllerAnimated:YES];
                                }
                            }];
                        }
               
                }
            }
            else
            {
            if (available_hour <= 4)
            {
                // All cells available for selection
                for (int i = 7; i < 22; i++)
                {
                    [time_array addObject:[NSString stringWithFormat:@"%.2d:00-%.2d:00", i, i + 1]];
                }
            }
            else
            {
                BOOL haveSlots = NO;
                if (![Utility sharedInstance].isSatPick && ![Utility sharedInstance].isSunPick)
                {
                    // upto three options are not available
                    for (int i = available_hour + 4; i < 22; i++)
                    {
                        haveSlots = YES;
                        [time_array addObject:[NSString stringWithFormat:@"%.2d:00-%.2d:00", i, i + 1]];
                    }
                
                if (!haveSlots) {
                    [RSTAlertView showAlertMessage:kNoSlotsAlert withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
                        if (buttonIndex == 0) {
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    }];
                }
                }
            }
            }
        }
        else if ([Utility sharedInstance].isSatPick)
        {
            for (int i = 9; i < 15; i++)
            {
                [time_array addObject:[NSString stringWithFormat:@"%.2d:00-%.2d:00", i, i + 1]];
            }
        }
        else if ([Utility sharedInstance].isSunPick)
        {
            for (int i = 15; i < 21; i++)
            {
                [time_array addObject:[NSString stringWithFormat:@"%.2d:00-%.2d:00", i, i + 1]];
            }
        }
        else
        {
            // All cells available for selection
            if ([Utility sharedInstance].todayAfterFive)
            {
                for (int i = 7; i < 22; i++)
                {
                    [time_array addObject:[NSString stringWithFormat:@"%.2d:00-%.2d:00", i, i + 1]];
                }
            }
            else if ([Utility sharedInstance].todayAfterSix)
            {
                for (int i = 8; i < 22; i++)
                {
                    [time_array addObject:[NSString stringWithFormat:@"%.2d:00-%.2d:00", i, i + 1]];
                }
            }
            else if ([Utility sharedInstance].todayAfterSeven)
            {
                for (int i = 9; i < 22; i++)
                {
                    [time_array addObject:[NSString stringWithFormat:@"%.2d:00-%.2d:00", i, i + 1]];
                }
            }
            else if ([Utility sharedInstance].todayAfterEight)
            {
                for (int i = 10; i < 22; i++)
                {
                    [time_array addObject:[NSString stringWithFormat:@"%.2d:00-%.2d:00", i, i + 1]];
                }
            }
            else if ([Utility sharedInstance].todayAfterNine)
            {
                for (int i = 11; i < 22; i++)
                {
                    [time_array addObject:[NSString stringWithFormat:@"%.2d:00-%.2d:00", i, i + 1]];
                }
            }
            else
            {
                for (int i = 7; i < 22; i++)
                {
                    [time_array addObject:[NSString stringWithFormat:@"%.2d:00-%.2d:00", i, i + 1]];
                }
            }
           
        }
    }
    else //1094
    {
        NSMutableArray * temp_array = [[NSMutableArray alloc] initWithObjects:@"07:00-08:00", @"08:00-09:00",@"09:00-10:00",@"10:00-11:00",@"11:00-12:00",@"12:00-13:00",@"13:00-14:00",@"14:00-15:00",@"15:00-16:00",@"16:00-17:00",@"17:00-18:00",@"18:00-19:00",@"19:00-20:00",@"20:00-21:00",@"21:00-22:00", nil];
        NSMutableArray * satTemp_array = [[NSMutableArray alloc] initWithObjects:@"07:00-08:00", @"08:00-09:00",@"09:00-10:00",@"10:00-11:00",@"11:00-12:00",@"12:00-13:00",@"13:00-14:00",@"14:00-15:00", nil];
        NSMutableArray * sunTemp_array = [[NSMutableArray alloc] initWithObjects:@"15:00-16:00",@"16:00-17:00",@"17:00-18:00",@"18:00-19:00",@"19:00-20:00",@"20:00-21:00",@"21:00-22:00", nil];
        NSMutableArray * sunDelTemp_array = [[NSMutableArray alloc] initWithObjects:@"15:00-16:00",@"16:00-17:00",@"17:00-18:00",@"18:00-19:00",@"19:00-20:00",@"20:00-21:00", nil];
        
        BOOL isFound = NO;
        if ((int)self.selected_index == 0)
        {

            if ([Utility sharedInstance].isSatDel)
            {
                if ([Utility sharedInstance].nextWeek)
                {
                    for (NSString * time_slot in satTemp_array)
                    {
                        if ([self.selected_time_string isEqualToString:time_slot])
                        {
                            isFound = YES;
                        }

                        if (isFound)
                        {
                            if (![time_slot isEqualToString:@"07:00-08:00"] && ![time_slot isEqualToString:@"08:00-09:00"]) {
                                [time_array addObject:time_slot];

                            }
                        }
                    }
                }
                else
                {
                    for (NSString * time_slot in satTemp_array)
                    {
                        //                        if ([self.selected_time_string isEqualToString:time_slot])
                        //                        {
                        isFound = YES;
                        //                        }
                        
                        if (isFound)
                        {
                            [time_array addObject:time_slot];
                        }
                    }
                }
           
            }
            else if ([Utility sharedInstance].isSunPick || [Utility sharedInstance].friAfterThreePick)
            {
                for (NSString * time_slot in sunTemp_array)
                {
//                    if ([self.selected_time_string isEqualToString:time_slot])
//                    {
                        isFound = YES;
//                    }
                    
                    if (isFound)
                    {
                        [time_array addObject:time_slot];
                    }
                }
            }
            else
            {
                for (NSString * time_slot in temp_array)
                {
                    if ([self.selected_time_string isEqualToString:time_slot])
                    {
                        isFound = YES;
                    }
                    
                    if (isFound)
                    {
                        [time_array addObject:time_slot];
                    }
                }
            }
  
        }
        else
        {
            // All cells available for selection
            if ([Utility sharedInstance].isSatDel)
            {
//                for (NSString * time_slot in satTemp_array)
//                {
//                    if ([self.selected_time_string isEqualToString:time_slot])
//                    {
//                        isFound = YES;
//                    }
//                    
//                    if (isFound)
//                    {
//                        [time_array addObject:time_slot];
//                    }
//                }
                if ([Utility sharedInstance].nextWeek)
                {

                    for (NSString * time_slot in satTemp_array)
                    {
                        //                        if ([self.selected_time_string isEqualToString:time_slot])
                        //                        {
                        isFound = YES;
                        //                        }
                        
                        if (isFound)
                        {
                            if (![time_slot isEqualToString:@"07:00-08:00"] && ![time_slot isEqualToString:@"08:00-09:00"]) {
                                [time_array addObject:time_slot];
                                
                            }                        }
                    }
                }
                else
                {
                    for (NSString * time_slot in satTemp_array)
                    {
                        if ([self.selected_time_string isEqualToString:time_slot])
                        {
                            isFound = YES;
                        }

                        if (isFound)
                        {
                            [time_array addObject:time_slot];
                        }
                    }
                }

            }
            if ([Utility sharedInstance].isSunDel)
            {
                //                for (NSString * time_slot in satTemp_array)
                //                {
                //                    if ([self.selected_time_string isEqualToString:time_slot])
                //                    {
                //                        isFound = YES;
                //                    }
                //
                //                    if (isFound)
                //                    {
                //                        [time_array addObject:time_slot];
                //                    }
                //                }
                if ([Utility sharedInstance].nextWeek)
                {
                    
                    for (NSString * time_slot in sunDelTemp_array)
                    {
                        //                        if ([self.selected_time_string isEqualToString:time_slot])
                        //                        {
                        isFound = YES;
                        //                        }
                        
                        if (isFound)
                        {
//                            if (![time_slot isEqualToString:@"07:00-08:00"] && ![time_slot isEqualToString:@"08:00-09:00"]) {
                                [time_array addObject:time_slot];
                                
//                            }
                    }
                    }
                }
                else
                {
                    for (NSString * time_slot in sunDelTemp_array)
                    {
                        if ([self.selected_time_string isEqualToString:time_slot])
                        {
                            isFound = YES;
                        }
                        
                        if (isFound)
                        {
                            [time_array addObject:time_slot];
                        }
                    }
                }
                
            }
            else
            {
            for (int i = 7; i < 22; i++)
            {
                [time_array addObject:[NSString stringWithFormat:@"%.2d:00-%.2d:00", i, i + 1]];
            }
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return time_array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * MyIdentifier = @"MyIdentifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:MyIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.textLabel.text = [time_array objectAtIndex:indexPath.row];
    [cell.textLabel setFont:[UIFont fontWithName:kRobotoFontRegular size:14.0]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * timeSlotSelected;
    timeSlotSelected = [time_array objectAtIndex:indexPath.row];
    _num = [[timeSlotSelected substringToIndex:2] intValue];
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    BOOL isFri = [defaults boolForKey:@"isFri"];
    
    
    if ([Utility sharedInstance].isFriPick)
    {
        if (_num >= 15)
        {
            [Utility sharedInstance].friAfterThreePick = YES;
        }
        else
        {
            [Utility sharedInstance].friAfterThreePick = NO;

        }
    }
    else
    {
        [Utility sharedInstance].friAfterThreePick = NO;

    }

    [self.delegate selectedTimeSlot:timeSlotSelected withSelectedTag:self.selected_tag andIndex:indexPath.row];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
