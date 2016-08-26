 //
//  CreditCardPaymentViewController.m
//  LavanApp
//
//  Created by IPHONE-10 on 10/12/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

#import "CreditCardPaymentViewController.h"

@interface CreditCardPaymentViewController ()<BTPaymentMethodCreationDelegate>
{
    NSString *expiryMonth, *expiryYear;
}
@property (nonatomic, strong) BTDropInErrorAlert *saveAccountErrorAlert;

@end

@implementation CreditCardPaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getClientTokenFromServerForBrainTree];
    
    cardHolderNameTxtField.leftViewMode = UITextFieldViewModeAlways;
    cardNumberTxtField.leftViewMode = UITextFieldViewModeAlways;
    expiryDateTxtField.leftViewMode = UITextFieldViewModeAlways;
    cvcTxtField.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView * leftView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 21)];
    leftView1.contentMode = UIViewContentModeScaleAspectFit;
    leftView1.backgroundColor = [UIColor clearColor];
    leftView1.image = [UIImage imageNamed:@"man"];
    cardHolderNameTxtField.leftView = leftView1;
    UIImageView * leftView2 = [[UIImageView alloc] initWithFrame:leftView1.frame];
    leftView2.contentMode = UIViewContentModeScaleAspectFit;
    leftView2.backgroundColor = [UIColor clearColor];
    leftView2.image = [UIImage imageNamed:@"card"];
    cardNumberTxtField.leftView = leftView2;
    UIImageView * leftView3 = [[UIImageView alloc] initWithFrame:leftView1.frame];
    leftView3.contentMode = UIViewContentModeScaleAspectFit;
    leftView3.backgroundColor = [UIColor clearColor];
    leftView3.image = [UIImage imageNamed:@"calender"];
    expiryDateTxtField.leftView = leftView3;
    UIImageView * leftView4 = [[UIImageView alloc] initWithFrame:leftView1.frame];
    leftView4.contentMode = UIViewContentModeScaleAspectFit;
    leftView4.backgroundColor = [UIColor clearColor];
    leftView4.image = [UIImage imageNamed:@"lock"];
    cvcTxtField.leftView = leftView4;
    
    checkBoxBtn.layer.masksToBounds = YES;
    checkBoxBtn.layer.cornerRadius = 5.0;
    
    checkOutBtn.layer.masksToBounds = YES;
    checkOutBtn.layer.cornerRadius = 5.0;
    
    payPalBtn.layer.masksToBounds = YES;
    payPalBtn.layer.cornerRadius = 5.0;
    
    [backBtn setTitle:NSLocalizedString(@"CHECKOUT", nil) forState:UIControlStateNormal];
    [checkOutBtn setTitle:@"PAGAR" forState:UIControlStateNormal];
    saveCardLabel.text = NSLocalizedString(@"Save Your Detail", nil);
    cardHolderNameTxtField.placeholder = NSLocalizedString(@"Name On Card", nil);
    cardNumberTxtField.placeholder = NSLocalizedString(@"Card Number", nil);
    expiryDateTxtField.placeholder = NSLocalizedString(@"Expiration Date(MM/YY)", nil);

    [self markAllTextFieldGrayCorner];
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;

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

- (void)getClientTokenFromServerForBrainTree
{
    NSURL * clientTokenURL = [NSURL URLWithString:kTokenURL];
    NSMutableURLRequest * clientTokenRequest = [NSMutableURLRequest requestWithURL:clientTokenURL];
    [clientTokenRequest setValue:@"text/plain" forHTTPHeaderField:@"Accept"];
    
    [NSURLConnection
     sendAsynchronousRequest:clientTokenRequest
     queue:[NSOperationQueue mainQueue]
     completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
         // TODO: Handle errors in [(NSHTTPURLResponse *)response statusCode] and connectionError
         NSString * clientToken = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         
         // Initialize `Braintree` once per checkout session
         self.brainTree = [Braintree braintreeWithClientToken:clientToken];
     }];
}
#pragma mark - IBAction Methods

- (IBAction)backBtnTapped:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)checkBoxBtnTapped:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (sender.selected)
    {
        [sender setImage:[UIImage imageNamed:@"CheckboxImage.png"] forState:UIControlStateNormal];
    }
    else
    {
        [sender setImage:[UIImage imageNamed:@"UncheckboxImage.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)checkOutBtnTapped:(UIButton *)sender {
    
    [sender setEnabled:NO];
    sender.alpha = 0.6;

    BTClientCardRequest *request = [BTClientCardRequest new];
    request.number = cardNumberTxtField.text;
    request.expirationMonth = expiryMonth;
    request.expirationYear = expiryYear;
    request.cvv = cvcTxtField.text;
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:[NSDate date]];
    
    NSCharacterSet * charSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    
        if ([[cardHolderNameTxtField.text stringByTrimmingCharactersInSet:charSet] length] == 0) {        [RSTAlertView showAlertMessage:NSLocalizedString(kEmptyNameAlert, nil) withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
                if (buttonIndex == 0) {}
            }];
            [self markTextFieldRedCorner:cardHolderNameTxtField];
            [sender setEnabled:YES];
            sender.alpha = 1;
        }
        else if ([[cardNumberTxtField.text stringByTrimmingCharactersInSet:charSet] length] < 19)
        {
            [RSTAlertView showAlertMessage:NSLocalizedString(@"Please enter valid card no, It should be of 16 digits.", nil) withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
                if (buttonIndex == 0) {}
            }];
            
            [self markTextFieldRedCorner:cardNumberTxtField];
            [sender setEnabled:YES];
            sender.alpha = 1;
            
        }
        else if (([[expiryDateTxtField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] < 5))
        {
            [RSTAlertView showAlertMessage:NSLocalizedString(@"Please enter valid expiry date", nil) withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
                if (buttonIndex == 0) {}
            }];
            
            [self markTextFieldRedCorner:expiryDateTxtField];
            [sender setEnabled:YES];
            sender.alpha = 1;
            
        }
        else if ([[NSString stringWithFormat:@"20%@", expiryYear] intValue] < components.year) {
            [RSTAlertView showAlertMessage:NSLocalizedString(@"Please enter valid expiry date", nil) withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
                if (buttonIndex == 0) {}
            }];
            
            [self markTextFieldRedCorner:expiryDateTxtField];
            [sender setEnabled:YES];
            sender.alpha = 1;
        }
        else if (([[NSString stringWithFormat:@"20%@", expiryYear] intValue] == components.year) && expiryMonth.intValue < components.month) {
                [RSTAlertView showAlertMessage:NSLocalizedString(@"Please enter valid expiry date", nil) withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
                    if (buttonIndex == 0) {}
                }];
                
                [self markTextFieldRedCorner:expiryDateTxtField];
                [sender setEnabled:YES];
                sender.alpha = 1;
        }
        else if (([[cvcTxtField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] < 3))
        {
            [RSTAlertView showAlertMessage:NSLocalizedString(@"Please enter valid CVC", nil) withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
                if (buttonIndex == 0) {}
            }];
            
            [self markTextFieldRedCorner:cvcTxtField];
            [sender setEnabled:YES];
            sender.alpha = 1;
        }
        else {
            if (![Utility isNetworkAvailable])
            {
                [RSTAlertView showAlertMessage:NSLocalizedString(kNetworkError, nil) withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
                    if (buttonIndex == 0) {}
                }];
                [sender setEnabled:YES];
                sender.alpha = 1;
                
                return;
            }
            [[AppDelegate sharedInstance] loadingStart];

            
            [self.brainTree tokenizeCard:request
                 completion:^(NSString *nonce, NSError *error) {
                     // Communicate the nonce to your server, or handle error
                         {
                             [[AppDelegate sharedInstance] loadingEnd];

                             if (error) {
                                 [RSTAlertView showAlertMessage:kGeneralServerErrorAlert withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
                                     if (buttonIndex == 0) {}
                                 }];
                                 [sender setEnabled:YES];
                                 sender.alpha = 1;
                                 
                                 return;
                             }
                             
                     [[AppDelegate sharedInstance] loadingStart];

                     NSString * deviceToken = [Utility objectForKey:@"DeviceToken"];
                     if (deviceToken == nil)
                     {
                         deviceToken = @"0123456789";
                     }

                     NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", kBaseURL]];
                     NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
                     [dictionary setObject:@"PAYMENT_NONCE_SERVICE" forKey:@"request_type_sent"];
                     [dictionary setValue:nonce forKey:@"payment_method_nonce"];
                     [dictionary setObject:[Utility objectForKey:kOrderId] forKey:@"order_id"];
                     [dictionary setObject:[Utility objectForKey:kTotalAmount] forKey:@"amount"];
                     [dictionary setObject:@"2" forKey:@"device_type"];
                     [dictionary setObject:deviceToken forKey:@"device_id"];
                     [dictionary setObject:[Utility objectForKey:kUserId] forKey:kUserId];
                     if (checkBoxBtn.selected) {
                         [dictionary setObject:@"1" forKey:@"is_save_card"];
                     }
                     else
                         [dictionary setObject:@"0" forKey:@"is_save_card"];

                     dictionary = (NSMutableDictionary *)[Utility convertIntoBase64:[dictionary allValues] dictionary:dictionary];
                     
                     [dictionary setObject:@"1" forKey:@"decode"];
                     
                     WebCommunication * webComm = [WebCommunication new];
                     [webComm callToServerRequestDictionary:dictionary onURL:url WithBlock:^(NSDictionary * response, NSInteger status_code, NSError *error, WebCommunication * webComm)
                      {
                          
                          [sender setEnabled:YES];
                          sender.alpha = 1;

                          if (error) {
                              [RSTAlertView showAlertMessage:[error localizedDescription] withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
                                  if (buttonIndex == 0) {}
                              }];
                              
                              [self dismissViewControllerAnimated:YES completion:nil];
                              
                          }
                          else {
                              
                              [[NSNotificationCenter defaultCenter] postNotificationName:@"CartItemsRemoved" object:nil];
                              
                              [Utility setObject:nil forKey:@"pickOrderDateLblText"];
                              [Utility setObject:nil forKey:@"pickOrderTimeLblText"];
                              [Utility setObject:nil forKey:@"dropOrderDateLblText"];
                              [Utility setObject:nil forKey:@"dropOrderTimeLblText"];
                              [Utility setObject:nil forKey:@"totalDiscount"];
                              [Utility setObject:nil forKey:@"DiscountCoupenName"];
                              [Utility setObject:nil forKey:@"PercentageOff"];
                              [Utility setBool:NO forKey:@"couponApplied"];
                              
                              SubViewViewController * subviewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SubViewViewController"];
                              subviewController.pushType = @"3";
                              subviewController.orderNumber = [Utility objectForKey:kOrderId];
                              [kAppDelegate.navController pushViewController:subviewController animated:NO];
                              
                              [self dismissViewControllerAnimated:YES completion:nil];
                          }
                          

//                          if (response.allValues.count)
//                          {
//                              response = [Utility convertIntoUTF8:[response allValues] dictionary:response];
//                          }
//                          else
//                          {
//                              [[AppDelegate sharedInstance] loadingEnd];
//                              [RSTAlertView showAlertMessage:kGeneralServerErrorAlert withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
//                                  if (buttonIndex == 0) {}
//                              }];
//                              return ;
//                          }
//                          
//                          //NSLog(@"response : %@",response);
//                          
//                          if([[response objectForKey:@"payment_status"] isEqualToString:@"1"])
//                          {
//                              [[NSNotificationCenter defaultCenter] postNotificationName:@"CartItemsRemoved" object:nil];
//                              
//                              [Utility setObject:nil forKey:@"pickOrderDateLblText"];
//                              [Utility setObject:nil forKey:@"pickOrderTimeLblText"];
//                              [Utility setObject:nil forKey:@"dropOrderDateLblText"];
//                              [Utility setObject:nil forKey:@"dropOrderTimeLblText"];
//                              [Utility setObject:nil forKey:@"totalDiscount"];
//                              [Utility setObject:nil forKey:@"DiscountCoupenName"];
//                              [Utility setObject:nil forKey:@"PercentageOff"];
//                              [Utility setBool:NO forKey:@"couponApplied"];
//                              
//                              SubViewViewController * subviewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SubViewViewController"];
//                              subviewController.pushType = @"3";
//                              subviewController.orderNumber = [Utility objectForKey:kOrderId];
//                              [kAppDelegate.navController pushViewController:subviewController animated:NO];
//                              
//                              [self dismissViewControllerAnimated:YES completion:nil];
//                              [Utility setObject:nil forKey:kOrderId];
//
//                          }
//                          else
//                          {
//                              [RSTAlertView showAlertMessage:[response objectForKey:@"error_desc"] withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
//                                  if (buttonIndex == 0) {}
//                              }];
//                              
//                              [self dismissViewControllerAnimated:YES completion:nil];
//                          }
                          [[AppDelegate sharedInstance] loadingEnd];
                      }];
                 }

            }];
    }
}

- (IBAction)paypalAccountBtnTapped:(UIButton *)sender {
    BTPaymentProvider *provider = [self.brainTree paymentProviderWithDelegate:self];
    // Start PayPal Flow
    [provider createPaymentMethod:BTPaymentProviderTypePayPal];
}

- (void)paymentMethodCreator:(id)sender requestsPresentationOfViewController:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
    
}

- (void)paymentMethodCreator:(id)sender requestsDismissalOfViewController:(UIViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)paymentMethodCreatorWillPerformAppSwitch:(id)sender {
    // If there is a presented view controller, dismiss it before app switch
    // so that the result of the app switch can be shown in this view controller.
    if ([self presentedViewController]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)paymentMethodCreatorWillProcess:(id)sender{
    
}

- (void)paymentMethodCreatorDidCancel:(id)sender {
    
}

- (void)paymentMethodCreator:(id)sender didCreatePaymentMethod:(BTPaymentMethod *)paymentMethod{
    
    NSString * deviceToken = [Utility objectForKey:@"DeviceToken"];
    if (deviceToken == nil)
    {
        deviceToken = @"0123456789";
    }
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", kBaseURL]];
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:@"PAYMENT_NONCE_SERVICE" forKey:@"request_type_sent"];
    [dictionary setValue:paymentMethod.nonce forKey:@"payment_method_nonce"];
    [dictionary setObject:[Utility objectForKey:kOrderId] forKey:@"order_id"];
    [dictionary setObject:[Utility objectForKey:kTotalAmount] forKey:@"amount"];
    [dictionary setObject:@"2" forKey:@"device_type"];
    [dictionary setObject:deviceToken forKey:@"device_id"];
    [dictionary setObject:@"1" forKey:@"is_save_card"];
    [dictionary setObject:[Utility objectForKey:kUserId] forKey:kUserId];
    dictionary = (NSMutableDictionary *)[Utility convertIntoBase64:[dictionary allValues] dictionary:dictionary];
    
    [dictionary setObject:@"1" forKey:@"decode"];
    
    [[AppDelegate sharedInstance] loadingStart];
    
    WebCommunication * webComm = [WebCommunication new];
    [webComm callToServerRequestDictionary:dictionary onURL:url WithBlock:^(NSDictionary * response, NSInteger status_code, NSError *error, WebCommunication * webComm)
     {
         
         if (error) {
             [RSTAlertView showAlertMessage:[error localizedDescription] withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
                    if (buttonIndex == 0) {}
                    }];
 
                    [self dismissViewControllerAnimated:YES completion:nil];

         }
         else {     
                  [[NSNotificationCenter defaultCenter] postNotificationName:@"CartItemsRemoved" object:nil];
     
                  [Utility setObject:nil forKey:@"pickOrderDateLblText"];
                  [Utility setObject:nil forKey:@"pickOrderTimeLblText"];
                  [Utility setObject:nil forKey:@"dropOrderDateLblText"];
                  [Utility setObject:nil forKey:@"dropOrderTimeLblText"];
                  [Utility setObject:nil forKey:@"totalDiscount"];
                  [Utility setObject:nil forKey:@"DiscountCoupenName"];
                  [Utility setObject:nil forKey:@"PercentageOff"];
                  [Utility setBool:NO forKey:@"couponApplied"];
     
                  SubViewViewController * subviewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SubViewViewController"];
                  subviewController.pushType = @"3";
                  subviewController.orderNumber = [Utility objectForKey:kOrderId];
                  [kAppDelegate.navController pushViewController:subviewController animated:NO];
                  
                  [self dismissViewControllerAnimated:YES completion:nil];
            }
         
         
//         if (response.allValues.count)
//         {
//             response = [Utility convertIntoUTF8:[response allValues] dictionary:response];
//         }
//         else
//         {
//             [[AppDelegate sharedInstance] loadingEnd];
//             [RSTAlertView showAlertMessage:kGeneralServerErrorAlert withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
//                 if (buttonIndex == 0) {}
//             }];
//             return ;
//         }
//         
//         //NSLog(@"response : %@",response);
//         
//         if([[response objectForKey:@"payment_status"] isEqualToString:@"1"])
//         {
//             //NSLog(@"PAYMENT NONCE has send to server successfully.");
//             
//             [[NSNotificationCenter defaultCenter] postNotificationName:@"CartItemsRemoved" object:nil];
//             
//             [Utility setObject:nil forKey:@"pickOrderDateLblText"];
//             [Utility setObject:nil forKey:@"pickOrderTimeLblText"];
//             [Utility setObject:nil forKey:@"dropOrderDateLblText"];
//             [Utility setObject:nil forKey:@"dropOrderTimeLblText"];
//             [Utility setObject:nil forKey:@"totalDiscount"];
//             [Utility setObject:nil forKey:@"DiscountCoupenName"];
//             [Utility setObject:nil forKey:@"PercentageOff"];
//             [Utility setBool:NO forKey:@"couponApplied"];
//             
//             //             totalOrderCost = 0.0f;
//             //             totalDiscountCost = 0.0f;
//             //             couponID = nil;
//             //             totalAmount = nil;
//             
//             //             tableHeightConstraint.constant = 50;
//             //             mainViewHeightConstraint.constant -= [selectedOrders count]*44;
//             //             [selectedOrders removeAllObjects];
//             //             [selectedItemsTable reloadData];
//             
//             //             totalCartLbl.text = @"0.00€";
//             //             [self noCoupenCodeClicked:nil];
//             //             [self updateCartLabelValue];
//             
//             SubViewViewController * subviewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SubViewViewController"];
//             //             subviewController.backgroundView.backgroundColor = [UIColor colorWithRed:254.0/255.0 green:91.0/255.0 blue:109.0/255.0 alpha:1.0];
//             subviewController.pushType = @"3";
//             subviewController.orderNumber = [Utility objectForKey:kOrderId];
//             [kAppDelegate.navController pushViewController:subviewController animated:NO];
//             
//             [self dismissViewControllerAnimated:YES completion:nil];
//             //             orderId = nil;
//         }
//         else
//         {
//             //             NSLog(@"PAYMENT NONCE has not been send to server due to some problem.");
//             
//             //             NSLog(@"%@", [response objectForKey:@"error_code"]);
//             //             NSLog(@"%@", [response objectForKey:@"error_desc"]);
//             
//             [RSTAlertView showAlertMessage:[response objectForKey:@"error_desc"] withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
//                 if (buttonIndex == 0) {}
//             }];
//             
//             [self dismissViewControllerAnimated:YES completion:nil];
//         }
         [[AppDelegate sharedInstance] loadingEnd];
     }];
    
}

- (void)paymentMethodCreator:(id)sender didFailWithError:(NSError *)error {
    NSString *savePaymentMethodErrorAlertTitle;
    if ([error localizedDescription]) {
        savePaymentMethodErrorAlertTitle = [error localizedDescription];
    } else {
        savePaymentMethodErrorAlertTitle = BTDropInLocalizedString(ERROR_ALERT_CONNECTION_ERROR);
    }
    
    self.saveAccountErrorAlert = [[BTDropInErrorAlert alloc] initWithCancel:^{
        // Use the paymentMethods setter to update state
        self.saveAccountErrorAlert = nil;
    } retry:nil];
    self.saveAccountErrorAlert.title = savePaymentMethodErrorAlertTitle;
    [self.saveAccountErrorAlert show];
    
}

- (IBAction)cardNoButtonTapped:(UIButton *)sender {
    [cardNumberTxtField becomeFirstResponder];
}

- (IBAction)expiryButtonTapped:(UIButton *)sender {
    [expiryDateTxtField becomeFirstResponder];
}

#pragma mark - Class Methods

-(void)prePopulateCardDetails {
    cardHolderNameTxtField.text = [self.cardDetailsDict objectForKey:@"name_on_card"];
    cardNumberTxtField.text = [self.cardDetailsDict objectForKey:@"card_no"];
    expiryDateTxtField.text = [NSString stringWithFormat:@"%@/%@", [self.cardDetailsDict objectForKey:@"expiry_month"], [self.cardDetailsDict objectForKey:@"expiry_year"]];
    cardNumberTxtField.enabled = NO;
    cardHolderNameTxtField.enabled = NO;
    expiryDateTxtField.enabled = NO;
    checkBoxBtn.hidden = YES;
    saveCardLabel.hidden = YES;

}

- (void)markAllTextFieldGrayCorner
{
    for (UIView * subView in [[self.view viewWithTag:122] subviews])
    {
        if ([subView isKindOfClass:[UITextField class]])
        {
            subView.layer.cornerRadius = 6.0f;
            subView.layer.masksToBounds = YES;
            subView.layer.borderColor = kGreyBorderColor;
            subView.layer.borderWidth = 2.5f;
        }
    }
}

- (void)markTextFieldRedCorner:(UITextField *)textField
{
    textField.layer.cornerRadius = 6.0f;
    textField.layer.masksToBounds = YES;
    textField.layer.borderColor = kRedBorderColor;
    textField.layer.borderWidth = 2.5f;
}

-(void)saveCardDetails {
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", kBaseURL]];
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:@"SAVE_CARD_SERVICE" forKey:@"request_type_sent"];
    [dictionary setObject:[Utility objectForKey:kUserId] forKey:kUserId];
    [dictionary setObject:cardHolderNameTxtField.text forKey:@"name_on_card"];
    [dictionary setObject:[cardNumberTxtField.text stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:@"card_no"];
    [dictionary setObject:expiryMonth forKey:@"expiry_month"];
    [dictionary setObject:expiryYear forKey:@"expiry_year"];
    dictionary = (NSMutableDictionary *)[Utility convertIntoBase64:[dictionary allValues] dictionary:dictionary];
    
    [dictionary setObject:@"1" forKey:@"decode"];
    WebCommunication * webComm = [WebCommunication new];
    [webComm callToServerRequestDictionary:dictionary onURL:url WithBlock:^(NSDictionary * response, NSInteger status_code, NSError *error, WebCommunication * webComm)
     {
         if (response.allValues.count)
         {
             response = [Utility convertIntoUTF8:[response allValues] dictionary:response];
         }
         else
         {
             [[AppDelegate sharedInstance] loadingEnd];
             [RSTAlertView showAlertMessage:kGeneralServerErrorAlert withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
                 if (buttonIndex == 0) {}
             }];
             return ;
         }
         
         if([[response objectForKey:@"card_saved"] isEqualToString:@"1"])
         {
             SubViewViewController * subviewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SubViewViewController"];
             subviewController.pushType = @"3";
             subviewController.orderNumber = [Utility objectForKey:kOrderId];
             [kAppDelegate.navController pushViewController:subviewController animated:NO];
             
             [self dismissViewControllerAnimated:YES completion:nil];
             [Utility setObject:nil forKey:kOrderId];

         }
         else
         {

            [RSTAlertView showAlertMessage:@"There was some error in saving card" withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
                 if (buttonIndex == 0) {
                     SubViewViewController * subviewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SubViewViewController"];
                     subviewController.pushType = @"3";
                     subviewController.orderNumber = [Utility objectForKey:kOrderId];
                     [kAppDelegate.navController pushViewController:subviewController animated:NO];
                     
                     [self dismissViewControllerAnimated:YES completion:nil];
                     [Utility setObject:nil forKey:kOrderId];
}
             }];
             
             [self dismissViewControllerAnimated:YES completion:nil];
         }
     }];

}

#pragma mark - UITextField Delegates

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * finalString = [textField.text stringByReplacingCharactersInRange:range withString:string];

    if (textField == cardNumberTxtField)
    {
        // All digits entered
        if (range.location == 19) {
            return NO;
        }
        // Reject appending non-digit characters
        if (range.length == 0 &&
            ![[NSCharacterSet decimalDigitCharacterSet] characterIsMember:[string characterAtIndex:0]]) {
            return NO;
        }
        
        // Auto-add hyphen before appending 4th or 7th digit
        if (range.length == 0 &&
            (range.location == 3|| range.location == 8 || range.location == 13)) {
            textField.text = [NSString stringWithFormat:@"%@%@ ", textField.text, string];
            return NO;
        }
        
        if (range.length == 0 &&
            (range.location == 4|| range.location == 9 || range.location == 14)) {
            textField.text = [NSString stringWithFormat:@"%@ %@", textField.text, string];
            return NO;
        }

        
        // Delete hyphen when deleting its trailing digit
        if (range.length == 1 &&
            (range.location == 5|| range.location == 10 || range.location == 15)) {
            range.location--;
            range.length = 2;
            textField.text = [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
        
        
        return YES;

    }
    else if (textField == cvcTxtField) {
        if ([finalString length] > 3)
            return NO;
        else
            return YES;
    }
    
    else if (textField == expiryDateTxtField) {
        // All digits entered
        if (range.location == 5) {
            return NO;
        }
        if (range.location == 4) {
            NSRange range = {3,1};
            expiryYear = [NSString stringWithFormat:@"%@%@", [textField.text substringWithRange:range], string];
            return YES;
        }
        
        // Reject appending non-digit characters
        if (range.length == 0 &&
            ![[NSCharacterSet decimalDigitCharacterSet] characterIsMember:[string characterAtIndex:0]]) {
            return NO;
        }
        
        // Auto-add hyphen before appending 4th or 7th digit
        if (range.length == 0 &&
            (range.location == 1)) {
            expiryMonth = [NSString stringWithFormat:@"%@%@", textField.text, string];
            textField.text = [NSString stringWithFormat:@"%@%@/", textField.text, string];
            return NO;
        }
        
        if (range.length == 0 &&
            (range.location == 2)) {
            textField.text = [NSString stringWithFormat:@"%@/%@", textField.text, string];
            return NO;
        }
        
        // Delete hyphen when deleting its trailing digit
        if (range.length == 1 &&
            (range.location == 3))  {
            range.location--;
            range.length = 2;
            textField.text = [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
        
        return YES;
    }
       else
    {
        if ([finalString length] > 50)
            return NO;
        else
            return YES;
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.layer.cornerRadius = 6.0f;
    textField.layer.masksToBounds = YES;
    textField.layer.borderColor = kBlueBorderColor;
    textField.layer.borderWidth = 2.5f;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.layer.cornerRadius = 6.0f;
    textField.layer.masksToBounds = YES;
    textField.layer.borderColor = kGreyBorderColor;
    textField.layer.borderWidth = 2.5f;
    [textField layoutIfNeeded];

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
