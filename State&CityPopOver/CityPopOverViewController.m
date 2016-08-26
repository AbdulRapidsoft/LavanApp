//
//  CityPopOverViewController.m
//  LavanApp
//
//  Created by IPHONE-10 on 6/25/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

#import "CityPopOverViewController.h"
#import "Definition.h"
#import "AppDelegate.h"

@interface CityPopOverViewController ()
{
    NSMutableArray * citiesArray;
}

@end

@implementation CityPopOverViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    citiesArray = [NSMutableArray array];

    for (int i = 0; i < self.statesDict.allKeys.count; i++)
    {
        NSDictionary * dict = [self.statesDict objectForKey:[NSString stringWithFormat:@"%d", i + 1]];
        
        if ([[dict objectForKey:@"id"] isEqualToString:kAppDelegate.selectedStateId])
        {
            NSArray * cityArray = [dict objectForKey:@"cities"];
            for (NSDictionary * cityDict in cityArray)
            {
                NSMutableDictionary * cityDetail = [NSMutableDictionary dictionary];
                [cityDetail setObject:[cityDict objectForKey:@"name"] forKey:@"name"];
                [cityDetail setObject:[cityDict objectForKey:@"id"] forKey:@"id"];
                [citiesArray addObject:cityDetail];
            }
        }
    }
    [cityListTableView reloadData];
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
    return citiesArray.count;
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
    cell.textLabel.text = [[citiesArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    [cell.textLabel setFont:[UIFont fontWithName:kRobotoFontRegular size:10.0]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cityName = [[citiesArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    NSString * cityID = [[citiesArray objectAtIndex:indexPath.row] objectForKey:@"id"];
    [self.delegate setCity:cityName withSelectedID:cityID];
}

@end
