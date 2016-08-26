//
//  DatePopoverController.m
//  LavanApp
//
//  Created by IPHONE-11 on 26/08/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

#import "DatePopoverController.h"
#import "Definition.h"
#import "Utility.h"

@interface DatePopoverController ()
{
    NSString * time_str;
}
@end

@implementation DatePopoverController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"Choose Date", nil);
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};

    NSDate * now = [NSDate date];
    date_array = [[NSMutableArray alloc] init];
    
    NSDateFormatter * timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [timeFormatter setDateFormat:@"HH"];
    NSInteger fri = [[timeFormatter stringFromDate:[NSDate date]] integerValue] + 40;
    time_str = [timeFormatter stringFromDate:[NSDate date]];
    int available_hour = [time_str intValue] + 5;
    int start_value = 0;
    if (available_hour < 22)
    {
        start_value = 0;
    }
    else
    {
        start_value = 1;
    }
//    BOOL friAfterThree = [[NSUserDefaults standardUserDefaults] boolForKey:@"friAfterThree"];
//    BOOL isSat = [[NSUserDefaults standardUserDefaults] boolForKey:@"isSat"];
//    BOOL isSun = [[NSUserDefaults standardUserDefaults] boolForKey:@"isSun"];

    if (self.selected_tag == 1091)
    {
        for (int i = start_value; i < (start_value + 9); i++)
        {
            NSDate * next_day = [now dateByAddingTimeInterval:60*60*24*i];
            
            NSDateFormatter * myFormatter1 = [[NSDateFormatter alloc] init];
            [myFormatter1 setDateFormat:@"dd MMMM"];// date, like 25 August
            NSString * dayOfDay = [myFormatter1 stringFromDate:next_day];
            
            NSDateFormatter * myFormatter2 = [[NSDateFormatter alloc] init];
            [myFormatter2 setDateFormat:@"EEEE"]; // day, like "Saturday"
            NSString * dayOfWeek = [myFormatter2 stringFromDate:next_day];
//            if ([dayOfWeek isEqualToString:@"Friday"])
//            {
//                if (fri >= 15)
//                {    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//                    [defaults setBool:YES forKey:@"isFri"];
//                }
//            }
            NSString * final_string = [NSString stringWithFormat:@"%@ %@", dayOfWeek, dayOfDay];
            //NSLog(@"%@", final_string);
            
            NSDateFormatter * myFormatter3 = [[NSDateFormatter alloc] init];
            [myFormatter3 setDateFormat:@"yyyy-MM-dd"];// date, like 2015-08-25
            NSString * serverDate = [myFormatter3 stringFromDate:next_day];
            
            NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
            [dict setObject:serverDate forKey:@"ServerDate"];
            if (i == 0)
            {
                [dict setObject:@"hoy" forKey:@"DeviceDate"];
            }
            else if (i == 1)
            {
                [dict setObject:@"mañana" forKey:@"DeviceDate"];
            }
            else
            {
                [dict setObject:final_string forKey:@"DeviceDate"];
            }
            
            [date_array addObject:dict];
        }
    }
    else //1092
    {
        int start_loop = (int)self.selected_index + 1 + start_value;
//        int  j = start_loop;
        for (int i = start_loop; i < (start_loop+9); i++)
        {
            NSDate * next_day;
            if ([Utility sharedInstance].friAfterThreePick)
            {
                next_day = [now dateByAddingTimeInterval:60*60*24*(i+2)];
            }
            else if ([Utility sharedInstance].isSatPick || [Utility sharedInstance].isSunPick )
            {
               next_day = [now dateByAddingTimeInterval:60*60*24*(i+1)];
            }
            else
            {
                next_day = [now dateByAddingTimeInterval:60*60*24*i];
            }
                NSDateFormatter * myFormatter1 = [[NSDateFormatter alloc] init];
                [myFormatter1 setDateFormat:@"dd MMMM"];// date, like 25 August
                NSString * dayOfDay = [myFormatter1 stringFromDate:next_day];
                
                NSDateFormatter * myFormatter2 = [[NSDateFormatter alloc] init];
                [myFormatter2 setDateFormat:@"EEEE"]; // day, like "Saturday"
                NSString * dayOfWeek = [myFormatter2 stringFromDate:next_day];
                NSString * final_string = [NSString stringWithFormat:@"%@ %@", dayOfWeek, dayOfDay];
                //NSLog(@"%@", final_string);
                
                NSDateFormatter * myFormatter3 = [[NSDateFormatter alloc] init];
                [myFormatter3 setDateFormat:@"yyyy-MM-dd"];// date, like 2015-08-25
                NSString * serverDate = [myFormatter3 stringFromDate:next_day];
                
                NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
                [dict setObject:final_string forKey:@"DeviceDate"];
                [dict setObject:serverDate forKey:@"ServerDate"];
                [date_array addObject:dict];
//            if (![dayOfWeek isEqualToString:@"Sunday"])
//            {
//                [date_array addObject:dict];
//            }
//            else
//            {
//                i--;
//            }
//            j++;
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
    return date_array.count;
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
    NSMutableDictionary * dict = (NSMutableDictionary *)[date_array objectAtIndex:indexPath.row];
    cell.textLabel.text = [dict objectForKey:@"DeviceDate"];
    
    [cell.textLabel setFont:[UIFont fontWithName:kRobotoFontRegular size:14.0]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSDate *pickDateFromStr;
//    NSDate *delDateFromStr;
    if (self.selected_tag == 1091)
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if ([cell.textLabel.text isEqualToString:@"mañana"])
        {

            if ([time_str isEqualToString:@"17"])
            {
                [Utility sharedInstance].todayAfterFive = YES;
            }
            else
            {
                [Utility sharedInstance].todayAfterFive = NO;
            }
            if ([time_str isEqualToString:@"18"])
            {
                [Utility sharedInstance].todayAfterSix = YES;
            }
            else
            {
                [Utility sharedInstance].todayAfterSix = NO;
            }
            if ([time_str isEqualToString:@"19"])
            {
                [Utility sharedInstance].todayAfterSeven = YES;
            }
            else
            {
                [Utility sharedInstance].todayAfterSeven = NO;
            }
            if ([time_str isEqualToString:@"20"])
            {
                [Utility sharedInstance].todayAfterEight = YES;
            }
            else
            {
                [Utility sharedInstance].todayAfterEight = NO;
            }
            if ([time_str isEqualToString:@"21"])
            {
                [Utility sharedInstance].todayAfterNine = YES;
            }
            else
            {
                [Utility sharedInstance].todayAfterNine = NO;
            }
        }
    NSMutableDictionary * dict = (NSMutableDictionary *)[date_array objectAtIndex:indexPath.row];
    NSString *dateStr = [dict valueForKey:@"ServerDate"];
    NSDateFormatter *df=[[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd"];
    [df setTimeZone:[NSTimeZone localTimeZone]];
    [Utility sharedInstance].pickDateFromString = [df dateFromString:dateStr];
    [df setDateFormat:@"EEEE"];
    NSString *dayStr=[df stringFromDate:[Utility sharedInstance].pickDateFromString];
    
        if ([dayStr isEqualToString:@"Friday"])
        {
            [Utility sharedInstance].isFriPick = YES;
            [Utility sharedInstance].isSatPick = NO;
            [Utility sharedInstance].isSunPick = NO;



        }
        else if ([dayStr isEqualToString:@"Saturday"])
        {
            [Utility sharedInstance].isFriPick = NO;
            [Utility sharedInstance].isSatPick = YES;
            [Utility sharedInstance].isSunPick = NO;

        }
        else if ([dayStr isEqualToString:@"Sunday"])
        {
            [Utility sharedInstance].isFriPick = NO;
            [Utility sharedInstance].isSatPick = NO;
            [Utility sharedInstance].isSunPick = YES;
        }
        else
        {
            [Utility sharedInstance].isFriPick = NO;
            [Utility sharedInstance].isSatPick = NO;
            [Utility sharedInstance].isSunPick = NO;
        }
       [self.delegate selectedDate:dict withSelectedTag:self.selected_tag andIndex:indexPath.row];
    }
    else
    {
        NSMutableDictionary * dict = (NSMutableDictionary *)[date_array objectAtIndex:indexPath.row];
        NSString *dateStr = [dict valueForKey:@"ServerDate"];
        NSDateFormatter *df=[[NSDateFormatter alloc]init];
        [df setDateFormat:@"yyyy-MM-dd"];
        [df setTimeZone:[NSTimeZone localTimeZone]];
        [Utility sharedInstance].delDateFromString = [df dateFromString:dateStr];
        [df setDateFormat:@"EEEE"];
        NSString *dayStr=[df stringFromDate:[Utility sharedInstance].delDateFromString];
        
        if ([dayStr isEqualToString:@"Friday"])
        {
            [Utility sharedInstance].isFriDel = YES;
            [Utility sharedInstance].isSatDel = NO;
            [Utility sharedInstance].isSunDel = NO;
            
            
            
        }
        else if ([dayStr isEqualToString:@"Saturday"])
        {
            [Utility sharedInstance].isFriDel = NO;
            [Utility sharedInstance].isSatDel = YES;
            [Utility sharedInstance].isSunDel = NO;
            
        }
        else if ([dayStr isEqualToString:@"Sunday"])
        {
            [Utility sharedInstance].isFriDel = NO;
            [Utility sharedInstance].isSatDel = NO;
            [Utility sharedInstance].isSunDel = YES;
        }
        else
        {
            [Utility sharedInstance].isFriDel = NO;
            [Utility sharedInstance].isSatDel = NO;
            [Utility sharedInstance].isSunDel = NO;
        }
        [self.delegate selectedDate:dict withSelectedTag:self.selected_tag andIndex:indexPath.row];
        NSInteger diff = [self daysBetweenDate:[Utility sharedInstance].pickDateFromString andDate:[Utility sharedInstance].delDateFromString];
        if (diff >= 1)
        {
            [Utility sharedInstance].nextWeek = YES;
        }
        else
        {
            [Utility sharedInstance].nextWeek = NO;

        }
        NSLog(@"%ld",diff);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}
@end
