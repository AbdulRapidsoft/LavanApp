//
//  PricingViewController.m
//  LavanApp
//
//  Created by IPHONE-10 on 10/8/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

#import "PricingViewController.h"

@interface PricingViewController ()
{
    NSDictionary *priceListDict;
    NSArray *keysValuesArray;
    
}
@property (weak, nonatomic) IBOutlet UILabel * cartCountLabel;

@end

@implementation PricingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *image = [UIImage imageNamed:@"LogoImage"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:image];
  //  self.navigationItem.title = @"Lavanapp";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:23]};
    // Do any additional setup after loading the view.
    self.cartCountLabel.layer.cornerRadius = 10;
    self.cartCountLabel.layer.masksToBounds = YES;
    [pricingLabel setTitle:NSLocalizedString(@"PRICING", nil) forState:UIControlStateNormal];
    AppDelegate * appDel = [AppDelegate sharedInstance];
    if (appDel.cartItemsArray.count)
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
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self getPriceList];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return priceListDict.allKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[priceListDict objectForKey:[keysValuesArray objectAtIndex:section]] objectForKey:@"products"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PricingDetailsTableViewCell * cell = (PricingDetailsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PricingDetailsTableViewCell"];
    if (cell == nil)
    {
        cell = [[PricingDetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PricingDetailsTableViewCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.itemName.text = [[[[priceListDict objectForKey:[keysValuesArray objectAtIndex:indexPath.section]] objectForKey:@"products"] objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.itemPrice.text = [NSString stringWithFormat:@"%@€", [[[[priceListDict objectForKey:[keysValuesArray objectAtIndex:indexPath.section]] objectForKey:@"products"] objectAtIndex:indexPath.row] objectForKey:@"price"]];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 34;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    PricingHeaderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PricingHeaderTableViewCell"];
    if (cell == nil)
    {
        cell = [[PricingHeaderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PricingHeaderTableViewCell"];
    }
    
    cell.headerLabel.text = [[priceListDict objectForKey:[keysValuesArray objectAtIndex:section]] objectForKey:@"name"];
    cell.contentView.backgroundColor = [UIColor whiteColor];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
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

#pragma mark - Class Methods

- (void)getPriceList
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
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", kBaseURL]];
    
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:@"GET_PRICE_LIST_SERVICE" forKey:@"request_type_sent"];
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
         
         NSLog(@"response : %@",response);
         NSLog(@"status_code : %ld",(long)status_code);
            keysValuesArray = [[response allKeys] sortedArrayUsingSelector: @selector(compare:)];

         priceListDict = response;
         [pricingListTableView reloadData];
         
         [[AppDelegate sharedInstance] loadingEnd];
     }];
}

@end
