//
//  OrderStatusViewController.m
//  LavanApp
//
//  Created by IPHONE-11 on 09/06/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

#import "OrderStatusViewController.h"

@interface OrderStatusViewController () 

@property (weak, nonatomic) IBOutlet UILabel * cartCountLabel;

@end

@implementation OrderStatusViewController

#pragma mark - view life cycle methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationItem.title = @"Lavanapp";
    UIImage *image = [UIImage imageNamed:@"LogoImage"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:image];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:23]};
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.cartCountLabel.layer.cornerRadius = 10;
    self.cartCountLabel.layer.masksToBounds = YES;

    newOrderButton.layer.cornerRadius = 5;
    newOrderButton.layer.masksToBounds = YES;

    historyofOrderArr = [[NSMutableArray alloc] init];
    [self getMyOrdersHistoryFromServer];
    
    detailViewHeightConstraint.constant = 0.0f;
    tableHeightConstraint.constant = 0.0f;
    
    float viewHeight = historyTable.frame.origin.y + 100;
    mainViewHeightConstraint.constant = viewHeight;
    scrollviewHeightConstraint.constant = viewHeight;
    
    isDetailViewLoad = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AppDelegate * appDel = [AppDelegate sharedInstance];
    if ([appDel.cartItemsArray count] > 0)
    {
        [self.cartCountLabel setHidden:NO];
        
        int totalCloths = 0;
        for (ClothDetails * clothObj in appDel.cartItemsArray)
        {
            totalCloths += [clothObj.numberofItems intValue];
        }
        self.cartCountLabel.text = [NSString stringWithFormat:@"%d", totalCloths];
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
    kAppDelegate.last_selected_row = 4;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    kAppDelegate.last_selected_row = 0;
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
    if ([historyofOrderArr count] > 0)
    {
        return [historyofOrderArr count];
    }
    else
    {
        return 0;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary * orderDetails = [historyofOrderArr objectAtIndex:indexPath.row];
    if ([[orderDetails objectForKey:@"order_status"] isEqualToString:@"5"])
    {
        OrderHistoryCell * cell = (OrderHistoryCell *)[tableView dequeueReusableCellWithIdentifier:@"OrderHistoryCell"];
        if (cell == nil)
        {
            cell = [OrderHistoryCell CreateCustomCell:self];
        }
        cell.orderDateLbl.text = [orderDetails objectForKey:@"expected_delivery_date"];
        
        cell.noofItemsLbl.text = [orderDetails objectForKey:@"product_count"];
        cell.noofItemsLbl.numberOfLines = 1;
        cell.noofItemsLbl.minimumScaleFactor = 8./cell.totalCostLbl.font.pointSize;
        cell.noofItemsLbl.adjustsFontSizeToFitWidth = YES;
        
        CGFloat actualFontSize;
        CGSize adjustedSize = [cell.noofItemsLbl.text sizeWithFont:cell.noofItemsLbl.font
                     minFontSize:cell.noofItemsLbl.minimumFontSize
                  actualFontSize:&actualFontSize
                        forWidth:cell.noofItemsLbl.bounds.size.width
                   lineBreakMode:cell.noofItemsLbl.lineBreakMode];
        cell.noofItemsLbl.font = [UIFont fontWithName:cell.noofItemsLbl.font.fontName size:actualFontSize - 2];
        
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;

        cell.totalCostLbl.text = [NSString stringWithFormat:@"%@€",[orderDetails objectForKey:@"total_price"]];
        cell.totalCostLbl.numberOfLines = 1;
        cell.totalCostLbl.minimumScaleFactor = 8./cell.totalCostLbl.font.pointSize;
        cell.totalCostLbl.adjustsFontSizeToFitWidth = YES;
        
        cell.orderStatusLbl.text = NSLocalizedString(@"Delivered", nil);
        
        cell.itemLbl.text = NSLocalizedString(@"Items", nil);
        cell.itemLbl.numberOfLines = 1;
        cell.itemLbl.minimumScaleFactor = 8./cell.totalCostLbl.font.pointSize;
        cell.itemLbl.adjustsFontSizeToFitWidth = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        return cell;
    }
    else
    {
        OrderStatusCell * cell = (OrderStatusCell *)[tableView dequeueReusableCellWithIdentifier:@"OrderStatusCell"];
        if (cell == nil)
        {
            cell = [OrderStatusCell CreateCustomCell:self];
            [cell.cancelRequestBtn addTarget:self action:@selector(cancelOrderButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
        cell.cancelRequestBtn.tag = indexPath.row;
        
        NSRange range = [[orderDetails objectForKey:@"created_on"] rangeOfString:@" "];
        NSString * newString = [[orderDetails objectForKey:@"created_on"] substringWithRange:NSMakeRange(0, range.location)];
        cell.orderDateLbl.text = newString;
        cell.noofItemsLbl.text = [orderDetails objectForKey:@"product_count"];
        cell.noofItemsLbl.numberOfLines = 1;
        cell.noofItemsLbl.minimumScaleFactor = 8./cell.totalCostLbl.font.pointSize;
        cell.noofItemsLbl.adjustsFontSizeToFitWidth = YES;
        CGFloat actualFontSize;
        CGSize adjustedSize = [cell.noofItemsLbl.text sizeWithFont:cell.noofItemsLbl.font
                                                       minFontSize:cell.noofItemsLbl.minimumFontSize
                                                    actualFontSize:&actualFontSize
                                                          forWidth:cell.noofItemsLbl.bounds.size.width
                                                     lineBreakMode:cell.noofItemsLbl.lineBreakMode];
        cell.noofItemsLbl.font = [UIFont fontWithName:cell.noofItemsLbl.font.fontName size:actualFontSize - 2];

        cell.totalCostLbl.text = [NSString stringWithFormat:@"%@€",[orderDetails objectForKey:@"total_price"]];
        
        cell.totalCostLbl.numberOfLines = 1;
        cell.totalCostLbl.minimumScaleFactor = 8./cell.totalCostLbl.font.pointSize;
        cell.totalCostLbl.adjustsFontSizeToFitWidth = YES;
        
        cell.orderStatusLbl.text = NSLocalizedString(@"In Progress", nil);
        cell.itemLbl.text = NSLocalizedString(@"Items", nil);
        cell.itemLbl.numberOfLines = 1;
        cell.itemLbl.minimumScaleFactor = 8./cell.totalCostLbl.font.pointSize;
        cell.itemLbl.adjustsFontSizeToFitWidth = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([historyofOrderArr count] > 0)
    {
        [self loadStatusOfLastOrderWith:[historyofOrderArr objectAtIndex:indexPath.row]];
        scroll_view.contentOffset = CGPointMake(0, 0);
        detailViewHeightConstraint.constant = 292.0f;
        
        float viewHeight = historyTable.frame.origin.y + tableHeightConstraint.constant + 100;
        if (!isDetailViewLoad)
        {
            viewHeight += 292;
            isDetailViewLoad = YES;
        }
        mainViewHeightConstraint.constant = viewHeight;
        scrollviewHeightConstraint.constant = viewHeight;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary * orderDetails = [historyofOrderArr objectAtIndex:indexPath.row];
    if ([[orderDetails objectForKey:@"order_status"] isEqualToString:@"5"])
    {
        return 60;
    }
    else
    {
        return 90;
    }
}

#pragma mark - IBAction methods

- (IBAction)menuButtonClicked:(UIButton *)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
    }];
}

- (IBAction)cartButtonClicked:(UIButton *)sender
{
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
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)backToPreviousBtnClicked:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    kAppDelegate.last_selected_row = 0;
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
    [[AppDelegate sharedInstance] loadingStart];

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
    [webComm callToServerRequestDictionary:dictionary onURL:url WithBlock:^(NSDictionary * response, NSInteger status_code, NSError * error, WebCommunication * webComm)
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
             historyofOrderArr = (NSMutableArray *)[response valueForKey:@"order_history_list"];
             if ([historyofOrderArr count] > 0)
             {
                 float tableHeight = 0;
                 for (NSMutableDictionary * orderDetails in historyofOrderArr)
                 {
                     if ([[orderDetails objectForKey:@"order_status"] isEqualToString:@"5"])
                     {
                         tableHeight += 60;
                     }
                     else
                     {
                         tableHeight += 90;
                     }
                 }
                 tableHeightConstraint.constant = tableHeight;
                 
                 float viewHeight = historyTable.frame.origin.y + tableHeightConstraint.constant + 100;
                 mainViewHeightConstraint.constant = viewHeight;
                 scrollviewHeightConstraint.constant = viewHeight;

                 [historyTable reloadData];
                 historyTable.bounces = NO;
             }
         }
         [[AppDelegate sharedInstance] loadingEnd];
     }];
}

- (void)cancelOrderButtonClicked:(UIButton *)leftBtn
{
}

- (void)loadStatusOfLastOrderWith:(NSMutableDictionary *)orderStatus
{
    orderNumberLbl.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Order No", nil),[orderStatus valueForKey:@"product_id"]];
    int status_no = [[orderStatus valueForKey:@"order_status"] intValue];
    switch (status_no)
    {
        case 0:
        {
            firstOrderStatusImg.image = [UIImage imageNamed:@"Ordered.png"];
            secondOrderStatusImg.image = [UIImage imageNamed:@"Collecting.png"];
            thirdOrderStatusImg.image = [UIImage imageNamed:@"Cleaning.png"];
            fourthOrderStatusImg.image = [UIImage imageNamed:@"Delevering.png"];
            fifthOrderStatusImg.image = [UIImage imageNamed:@"Ordered.png"];
        }
            break;
        case 1:
        {
            firstOrderStatusImg.image = [UIImage imageNamed:@"OrderedSelected.png"];
            secondOrderStatusImg.image = [UIImage imageNamed:@"Collecting.png"];
            thirdOrderStatusImg.image = [UIImage imageNamed:@"Cleaning.png"];
            fourthOrderStatusImg.image = [UIImage imageNamed:@"Delevering.png"];
            fifthOrderStatusImg.image = [UIImage imageNamed:@"Ordered.png"];
        }
            break;
        case 2:
        {
            firstOrderStatusImg.image = [UIImage imageNamed:@"OrderedSelected.png"];
            secondOrderStatusImg.image = [UIImage imageNamed:@"CollectingSelected.png"];
            thirdOrderStatusImg.image = [UIImage imageNamed:@"Cleaning.png"];
            fourthOrderStatusImg.image = [UIImage imageNamed:@"Delevering.png"];
            fifthOrderStatusImg.image = [UIImage imageNamed:@"Ordered.png"];
        }
            break;
        case 3:
        {
            firstOrderStatusImg.image = [UIImage imageNamed:@"OrderedSelected.png"];
            secondOrderStatusImg.image = [UIImage imageNamed:@"CollectingSelected.png"];
            thirdOrderStatusImg.image = [UIImage imageNamed:@"CleaningSelected.png"];
            fourthOrderStatusImg.image = [UIImage imageNamed:@"Delevering.png"];
            fifthOrderStatusImg.image = [UIImage imageNamed:@"Ordered.png"];
        }
            break;
        case 4:
        {
            firstOrderStatusImg.image = [UIImage imageNamed:@"OrderedSelected.png"];
            secondOrderStatusImg.image = [UIImage imageNamed:@"CollectingSelected.png"];
            thirdOrderStatusImg.image = [UIImage imageNamed:@"CleaningSelected.png"];
            fourthOrderStatusImg.image = [UIImage imageNamed:@"DeleveringSelected.png"];
            fifthOrderStatusImg.image = [UIImage imageNamed:@"Ordered.png"];
        }
            break;
        case 5:
        {
            firstOrderStatusImg.image = [UIImage imageNamed:@"OrderedSelected.png"];
            secondOrderStatusImg.image = [UIImage imageNamed:@"CollectingSelected.png"];
            thirdOrderStatusImg.image = [UIImage imageNamed:@"CleaningSelected.png"];
            fourthOrderStatusImg.image = [UIImage imageNamed:@"DeleveringSelected.png"];
            fifthOrderStatusImg.image = [UIImage imageNamed:@"OrderedSelected.png"];
        }
            break;
        default:
            break;
    }
}

@end
