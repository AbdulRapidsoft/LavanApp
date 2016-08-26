//
//  SecondSideMenuController.m
//  LavanApp
//
//  Created by IPHONE-11 on 26/05/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

#import "SecondSideMenuController.h"

#import "RegisterViewController.h"

@interface SecondSideMenuController ()

@end

@implementation SecondSideMenuController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [registerBtn setText:NSLocalizedString(@"REGISTER", nil)];
    [newOrderBtn setText:NSLocalizedString(@"NEW ORDER", nil)];
    [myAccountBtn setText:NSLocalizedString(@"MY ACCOUNT", nil)];
    [howItWorksBtn setText:NSLocalizedString(@"HOW IT WORKS", nil)];
    [priceBtn setText:NSLocalizedString(@"PRICE", nil)];
    [myOrdersBtn setText:NSLocalizedString(@"MY ORDERS", nil)];
    [contactBtn setText:NSLocalizedString(@"CONTACT", nil)];
    [termsBtn setText:NSLocalizedString(@"TERMS OF USE", nil)];
    [policyBtn setText:NSLocalizedString(@"PRIVACY POLICY", nil)];
    [loginBtn setText:NSLocalizedString(@"LOGIN", nil)];

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
    
    if (indexPath.row == 2)
    {
        RegisterViewController * registerController = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterViewController"];
        [kAppDelegate.navController pushViewController:registerController animated:NO];
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

    else if (indexPath.row == 8)
    {
        WebViewController * webController = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
        webController.pushType = @"1";
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
        LoginViewController * loginController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [kAppDelegate.navController pushViewController:loginController animated:NO];
        
    }
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    kAppDelegate.last_selected_row = indexPath.row;

}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor clearColor];
}

@end
