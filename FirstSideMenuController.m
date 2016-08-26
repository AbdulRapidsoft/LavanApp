//
//  FirstSideMenuController.m
//  LavanApp
//
//  Created by IPHONE-11 on 26/05/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

#import "FirstSideMenuController.h"

@interface FirstSideMenuController ()

@end

@implementation FirstSideMenuController

- (void)viewDidLoad
{
    [super viewDidLoad];
    usernameTextField.text = [NSString stringWithFormat:@"%@, %@", NSLocalizedString(@"Hello", nil),[Utility objectForKey:kUserName ]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(upDateUsername) name:@"setUsername" object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        NSArray *viewControllers = kAppDelegate.navController.viewControllers;
        for (UIViewController *controller in viewControllers) {
            if ([controller isKindOfClass:[CenterViewController class]]) {
                [kAppDelegate.navController popToViewController:controller animated:YES];
            }
        }
    }
    
    else if (indexPath.row == 3)
    {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"CartItemsRemoved" object:nil];
//        
//        [Utility setObject:nil forKey:@"pickOrderDateLblText"];
//        [Utility setObject:nil forKey:@"pickOrderTimeLblText"];
//        [Utility setObject:nil forKey:@"dropOrderDateLblText"];
//        [Utility setObject:nil forKey:@"dropOrderTimeLblText"];
//        [Utility setObject:nil forKey:@"totalDiscount"];
//        [Utility setObject:nil forKey:@"DiscountCoupenName"];
//        [Utility setObject:nil forKey:@"PercentageOff"];
//        [Utility setBool:NO forKey:@"couponApplied"];

        for (UIViewController *controller in kAppDelegate.navController.viewControllers) {
            if ([controller isKindOfClass:[CenterViewController class]]) {
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshCenterView" object:nil];
                [kAppDelegate.navController popToViewController:controller animated:YES];
            }
        }
    }
    else if (indexPath.row == 4)
    {
        EditProfileViewController * editProfileController = [self.storyboard instantiateViewControllerWithIdentifier:@"EditProfileViewController"];
        [kAppDelegate.navController pushViewController:editProfileController animated:NO];

    }
    else if (indexPath.row == 5)
    {
        WebViewController * webController = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
        webController.pushType = @"5";
        [kAppDelegate.navController pushViewController:webController animated:NO];
    }
    else if (indexPath.row == 6)
    {
        PricingViewController * pricingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PricingViewController"];
        [kAppDelegate.navController pushViewController:pricingViewController animated:NO];
    }
    else if (indexPath.row == 7)
    {
        if (kAppDelegate.last_selected_row != 4)
        {
            OrderStatusViewController * orderStatusController = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderStatusViewController"];
            [kAppDelegate.navController pushViewController:orderStatusController animated:NO];
        }

    }
    else if (indexPath.row == 8)
    {
        WebViewController * webController = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
        webController.pushType = @"1";
        
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        [kAppDelegate.navController pushViewController:webController animated:NO];
    }
    else if (indexPath.row == 10)
    {
        WebViewController * webController = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
        webController.pushType = @"3";
        [kAppDelegate.navController pushViewController:webController animated:NO];
    }
    else if (indexPath.row == 11)
    {
        WebViewController * webController = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
        webController.pushType = @"4";
        [kAppDelegate.navController pushViewController:webController animated:NO];

    }
    else if (indexPath.row == 13)
    {
                [RSTAlertView showAlertMessage:NSLocalizedString(kLogoutAlert, nil) withButtons:eYesNo completionHandler:^(NSInteger buttonIndex) {
                    if (buttonIndex == 1)
                    {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"CartItemsRemoved" object:nil];
                        [Utility setObject:nil forKey:kUserName];
                        [Utility setObject:nil forKey:kUserEmail];
                        [Utility setObject:nil forKey:kUserPassword];
                        [Utility setObject:nil forKey:kUserMobileNo];
                        [Utility setObject:nil forKey:kUserId];
                        [Utility setObject:nil forKey:@"Want_News"];
                        [Utility setBool:NO forKey:kIsLogin];
                        
                        [Utility setObject:nil forKey:@"directionFieldText"];
                        [Utility setObject:nil forKey:@"postalTextFieldText"];
                        [Utility setObject:nil forKey:@"notesFieldText"];
                        [Utility setObject:nil forKey:@"detailedAddressText"];
                        [Utility setObject:nil forKey:@"pickOrderDateLblText"];
                        [Utility setObject:nil forKey:@"pickOrderTimeLblText"];
                        [Utility setObject:nil forKey:@"dropOrderDateLblText"];
                        [Utility setObject:nil forKey:@"dropOrderTimeLblText"];
                        [Utility setObject:nil forKey:@"totalDiscount"];
                        [Utility setObject:nil forKey:@"cityTextFieldText"];
                        [Utility setObject:nil forKey:@"stateTextFieldText"];
                        [Utility setObject:nil forKey:@"cityTextFieldID"];
                        [Utility setObject:nil forKey:@"stateTextFieldID"];
                        [Utility setBool:NO forKey:@"couponApplied"];
                        
                        
                        SecondSideMenuController * sideMenuController = [self.storyboard instantiateViewControllerWithIdentifier:@"SecondSideMenuController"];
                        
                        IntroPageViewController * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"IntroPageViewController"];
                        [controller setIndex:3];
                        kAppDelegate.navController = (UINavigationController *)[self.storyboard instantiateViewControllerWithIdentifier:@"NavigationController"];
                        (void)[kAppDelegate.navController initWithRootViewController:controller];
                        
                        kAppDelegate.container = [MFSideMenuContainerViewController
                                                  containerWithCenterViewController:kAppDelegate.navController
                                                  leftMenuViewController:sideMenuController
                                                  rightMenuViewController:nil];
                        kAppDelegate.container.panMode = MFSideMenuPanModeNone;
                        kAppDelegate.container.shadow.enabled = NO;
                        
                        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                        {
                            UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 20)];
                            view.backgroundColor = [UIColor colorWithRed:43.0/255.0 green:184.0/255.0 blue:247.0/255.0 alpha:1];
                            [kAppDelegate.container.view addSubview:view];
                        }
                        
                        NSArray *subViewArray = [kAppDelegate.window subviews];
                        for (id obj in subViewArray)
                        {
                            [obj removeFromSuperview];
                        }

                        kAppDelegate.window.rootViewController = kAppDelegate.container;
                            [kAppDelegate.window makeKeyAndVisible];

        
                    }
                }];

    }
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    kAppDelegate.last_selected_row = indexPath.row;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor clearColor];
}

-(void)upDateUsername
{
    usernameTextField.text = [NSString stringWithFormat:@"%@, %@", NSLocalizedString(@"Hello", nil),[Utility objectForKey:kUserName ]];
}

@end
