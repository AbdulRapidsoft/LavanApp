//
//  OrderHistoryViewController.m
//  LavanApp
//
//  Created by IPHONE-10 on 6/5/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

#import "OrderHistoryViewController.h"

@interface OrderHistoryViewController ()
{
    
}
@property (weak, nonatomic) IBOutlet UILabel * cartCountLabel;

@end

@implementation OrderHistoryViewController

#pragma mark - view life cycle methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.cartCountLabel.layer.cornerRadius = 10;
    self.cartCountLabel.layer.masksToBounds = YES;
    AppDelegate * appDel = [AppDelegate sharedInstance];
    if (appDel.cartItemsArray.count)
    {
        [self.cartCountLabel setHidden:NO];
        self.cartCountLabel.text = [NSString stringWithFormat:@"%d", (int)appDel.cartItemsArray.count];
        self.cartCountLabel.numberOfLines = 1;
        self.cartCountLabel.minimumScaleFactor = 8./self.cartCountLabel.font.pointSize;
        self.cartCountLabel.adjustsFontSizeToFitWidth = YES;
        CGFloat actualFontSize;
        CGSize adjustedSize = [self.cartCountLabel.text sizeWithFont:self.cartCountLabel.font
                                                         minFontSize:self.cartCountLabel.minimumFontSize
                                                      actualFontSize:&actualFontSize
                                                            forWidth:self.cartCountLabel.bounds.size.width
                                                       lineBreakMode:self.cartCountLabel.lineBreakMode];
        CGFloat differenceInFontSize = self.cartCountLabel.font.pointSize - actualFontSize;
        self.cartCountLabel.font = [UIFont fontWithName:self.cartCountLabel.font.fontName size:self.cartCountLabel.font.pointSize - differenceInFontSize];

    }
    else
    {
        [self.cartCountLabel setHidden:YES];
    }
    
    newOrderBtn.layer.cornerRadius = 5;
    newOrderBtn.layer.masksToBounds = YES;
    
    historyofOrderArr = [[NSMutableArray alloc] init];
    [self getMyOrdersHistoryFromServer];
}

- (void)getMyOrdersHistoryFromServer
{
    if (![Utility isNetworkAvailable])
    {
        [RSTAlertView showAlertMessage:NSLocalizedString(kNetworkError, nil) withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
            if (buttonIndex == 0) {}
        }];
        return;
    }
    
    NSString * deviceToken = [Utility objectForKey:@"DeviceToken"];
    if (deviceToken == nil)
    {
        deviceToken = @"0123456789";
    }
    NSString * consumerID = [Utility objectForKey:kUserId];
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", kBaseURL]];
    
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:@"CONSUMER_ORDER_HISTORY_SERVICE" forKey:@"request_type_sent"];
    [dictionary setObject:consumerID forKey:@"consumer_id"];
    [dictionary setObject:@"2" forKey:@"device_type"];
    [dictionary setObject:deviceToken forKey:@"device_id"];
    dictionary = (NSMutableDictionary *)[Utility convertIntoBase64:[dictionary allValues] dictionary:dictionary];

    [dictionary setObject:@"1" forKey:@"decode"];
    
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

         NSLog(@"response : %@",response);
         NSLog(@"status_code : %ld",(long)status_code);
         
         if ([historyofOrderArr count] > 0)
         {
             // load data into historyofOrderArr
             // Reload table view
         }
         else
         {
             NSLog(@"Failed To Get History from server.");

             NSLog(@"%@", [response objectForKey:@"error_code"]);
             NSLog(@"%@", [response objectForKey:@"error_desc"]);
         }
     }];
}

#pragma mark - memory management methods

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
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
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderHistoryCell * cell = (OrderHistoryCell *)[tableView dequeueReusableCellWithIdentifier:@"OrderHistoryCell"];
    if (cell == nil)
    {
        cell = [OrderHistoryCell CreateCustomCell:self];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSLog(@"indexPath %d", (int)indexPath.row);
}

#pragma mark - IBAction methods

- (IBAction)menuButtonClicked:(UIButton *)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
    }];
}

- (IBAction)cartButtonClicked:(UIButton *)sender
{
    NSLog(@"cart Button Clicked");
    if ([kAppDelegate.cartItemsArray count] > 0)
    {
        PlaceOrderViewController * placeOrderViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PlaceOrderViewController"];
        [self.navigationController pushViewController:placeOrderViewController animated:YES];
    }
    else
    {
        [RSTAlertView showAlertMessage:NSLocalizedString(kNoItemError, nil) withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
            if (buttonIndex == 0) {}
        }];
    }
}

- (IBAction)newOrderBtnClicked:(UIButton *)sender
{
    NSLog(@"newOrder Btn Clicked");
}

@end
