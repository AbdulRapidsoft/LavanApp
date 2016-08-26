//
//  StatePopOverViewController.m
//  LavanApp
//
//  Created by IPHONE-10 on 6/25/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

#import "StatePopOverViewController.h"
#import "Definition.h"
#import "AppDelegate.h"

@interface StatePopOverViewController ()
{
    NSMutableArray * statesArray;
}

@end

@implementation StatePopOverViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    statesArray = [NSMutableArray array];

    for (int i = 0; i < self.statesDict.allKeys.count; i++)
    {
        NSDictionary * dict = [self.statesDict objectForKey:[NSString stringWithFormat:@"%d", i + 1]];
        if (dict)
        {
            NSMutableDictionary * stateInformationDict = [NSMutableDictionary dictionary];
            [stateInformationDict setObject:[dict objectForKey:@"name"] forKey:@"name"];
            [stateInformationDict setObject:[dict objectForKey:@"id"] forKey:@"id"];
            
            [statesArray addObject:stateInformationDict];
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
    return statesArray.count;
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
    cell.textLabel.text = [[statesArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    [cell.textLabel setFont:[UIFont fontWithName:kRobotoFontRegular size:10.0]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * stateName = [[statesArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    NSString * stateID = [[statesArray objectAtIndex:indexPath.row] objectForKey:@"id"];

    [self.delegate setState:stateName withSelectedID:stateID];
}

@end
