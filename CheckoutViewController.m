//
//  CheckoutViewController.m
//  LavanApp
//
//  Created by IPHONE-10 on 10/12/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

#import "CheckoutViewController.h"

@interface CheckoutViewController ()<BTPaymentMethodCreationDelegate>

@end

@implementation CheckoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    self.totalAmountLabel.text = [NSString stringWithFormat:@"Total : € %@", [Utility objectForKey:kTotalAmount]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - IBAction Methods

- (IBAction)backBtnTapped:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)creditCardBtnTapped:(UIButton *)sender {
     CreditCardPaymentViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"CreditCardPaymentViewController"];
     [self.navigationController pushViewController:controller animated:YES];
}

@end
