//
//  SavedCardsViewController.m
//  LavanApp
//
//  Created by IPHONE-10 on 10/13/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

#import "SavedCardsViewController.h"

@interface SavedCardsViewController ()
{
}
@property (strong, nonatomic) NSMutableArray *savedCardsArray;
@end

@implementation SavedCardsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _savedCardsArray = [NSMutableArray new];
    _savedCardsArray = _savedCards;
    [backBtn setTitle:NSLocalizedString(@"SAVED DETAILS", nil) forState:UIControlStateNormal];
    [newPaymentMethodBtn setTitle:NSLocalizedString(@"New Payment Method", NSLocalizedString) forState:UIControlStateNormal];
    savedDetails.text = NSLocalizedString(@"Saved Details", nil);
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    if (!_savedCardsArray.count) {
        savedCardsViewHeightConstraint.constant = 0;
        tableViewHeightConstraint.constant = 0;
    }
    else {
        savedCardsViewHeightConstraint.constant = 62;
         CGFloat estimatedHeight_tableview = _savedCardsArray.count * 63;
         if (estimatedHeight_tableview > 280) {
             tableViewHeightConstraint.constant = 280;
         }
         else
             tableViewHeightConstraint.constant = estimatedHeight_tableview;
             [savedCardsTableView reloadData];
    }
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

- (IBAction)addCreditCardBtnTapped:(UIButton *)sender {
    CreditCardPaymentViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"CreditCardPaymentViewController"];
    [self.navigationController pushViewController:controller animated:YES];
    
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
    return _savedCardsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    savedCardTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"savedCardTableViewCell"];
    if (cell == nil)
    {
        cell = [[savedCardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"savedCardTableViewCell"];
        }
    cell.removeCardBtn.tag = indexPath.row;
    [cell.removeCardBtn addTarget:self action:@selector(removeCardBtnTapped : ) forControlEvents:UIControlEventTouchUpInside];

    cell.cardNumberLabel.text = [[_savedCardsArray objectAtIndex:indexPath.row] objectForKey:@"card"];
    
    NSURL *imageURL = [NSURL URLWithString:[[_savedCardsArray objectAtIndex:indexPath.row] objectForKey:@"imageUrl"]];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *image = [UIImage imageWithData:imageData];
    
    cell.cardImageView.image = image;
    cell.cardImageView.contentMode = UIViewContentModeScaleAspectFit;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self doPaymentWithSavedCard : indexPath];
    NSLog(@"indexPath %d", (int)indexPath.row);
}


-(void)removeCardBtnTapped : (UIButton *) sender {
    [RSTAlertView showAlertMessage:NSLocalizedString(kDeleteCardAlert, nil) withButtons:eYesNo completionHandler:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            NSString * deviceToken = [Utility objectForKey:@"DeviceToken"];
            if (deviceToken == nil)
            {
                deviceToken = @"0123456789";
            }
            
            NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", kBaseURL]];
            
            NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
            [dictionary setObject:@"DELETE_SAVED_CARD_SERVICE" forKey:@"request_type_sent"];
            [dictionary setObject:[[_savedCardsArray objectAtIndex:sender.tag] objectForKey:@"token"] forKey:@"token"];
            dictionary = (NSMutableDictionary *)[Utility convertIntoBase64:[dictionary allValues] dictionary:dictionary];
            
            [dictionary setObject:@"1" forKey:@"decode"];
            
            [[AppDelegate sharedInstance] loadingStart];
            
            WebCommunication * webComm = [WebCommunication new];
            [webComm callToServerRequestDictionary:dictionary onURL:url WithBlock:^(NSDictionary *response, NSInteger status_code, NSError *error, WebCommunication *webComm)
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
                 
                 if([[response objectForKey:@"error_code"] isEqualToString:@"400"])
                 {
                     [RSTAlertView showAlertMessage:[response objectForKey:@"error_desc"] withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
                         if (buttonIndex == 0) {}
                     }];
                 }
                 else
                 {
                     if ([[response objectForKey:@"card_deleted"] isEqualToString:@"0"]) {
                         [RSTAlertView showAlertMessage:[response objectForKey:@"Card is not deleted please try again."] withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
                             if (buttonIndex == 0) {}
                         }];
                     }
                     else {
                         [_savedCardsArray removeObjectAtIndex:sender.tag];
                         if (!_savedCardsArray.count) {
                             savedCardsViewHeightConstraint.constant = 0;
                             tableViewHeightConstraint.constant = 0;
                         }
                         else {
                             savedCardsViewHeightConstraint.constant = 62;
                             CGFloat estimatedHeight_tableview = _savedCardsArray.count * 63;
                             if (estimatedHeight_tableview > 280) {
                                 tableViewHeightConstraint.constant = 280;
                             }
                             else
                                 tableViewHeightConstraint.constant = estimatedHeight_tableview;
                             [savedCardsTableView reloadData];
                         }
                         
                         
                         [savedCardsTableView reloadData];
                     }
                     
                 }
                 [[AppDelegate sharedInstance] loadingEnd];
                 
             }];
        }
    }];
}

-(NSString *)getFormattedCardNumber : (NSString *)cardNumber {
    NSString *visibleLastPart = [cardNumber substringFromIndex:11];
    return [NSString stringWithFormat:@"**** **** **** %@", visibleLastPart];
}

-(void)doPaymentWithSavedCard : (NSIndexPath *) indexPath {
    NSString * deviceToken = [Utility objectForKey:@"DeviceToken"];
    if (deviceToken == nil)
    {
        deviceToken = @"0123456789";
    }
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", kBaseURL]];
    
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:@"PAYMENT_TOKEN_SERVICE" forKey:@"request_type_sent"];
    [dictionary setObject:[[_savedCardsArray objectAtIndex:indexPath.row] objectForKey:@"token"] forKey:@"token"];
    [dictionary setObject:[Utility objectForKey:kOrderId] forKey:@"order_id"];
    [dictionary setObject:[Utility objectForKey:kTotalAmount] forKey:@"amount"];
    [dictionary setObject:[Utility objectForKey:kUserId] forKey:kUserId];

    dictionary = (NSMutableDictionary *)[Utility convertIntoBase64:[dictionary allValues] dictionary:dictionary];
    
    [dictionary setObject:@"1" forKey:@"decode"];
    
    [[AppDelegate sharedInstance] loadingStart];
    
    WebCommunication * webComm = [WebCommunication new];
    [webComm callToServerRequestDictionary:dictionary onURL:url WithBlock:^(NSDictionary *response, NSInteger status_code, NSError *error, WebCommunication *webComm)
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
//             SubViewViewController * subviewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SubViewViewController"];
//             subviewController.pushType = @"3";
//             subviewController.orderNumber = [Utility objectForKey:kOrderId];
//             [kAppDelegate.navController pushViewController:subviewController animated:NO];
//             
//             [self dismissViewControllerAnimated:YES completion:nil];
//             [Utility setObject:nil forKey:kOrderId];
//         }
//         else
//         {
//             [RSTAlertView showAlertMessage:[response objectForKey:@"error_desc"] withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
//                 if (buttonIndex == 0) {}
//             }];
//             
//             [self dismissViewControllerAnimated:YES completion:nil];
//         }
         [[AppDelegate sharedInstance] loadingEnd];
                  
     }];

}
@end
