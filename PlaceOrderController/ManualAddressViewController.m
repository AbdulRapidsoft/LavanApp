//
//  ManualAddressViewController.m
//  LavanApp
//
//  Created by IPHONE-10 on 10/15/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

#import "ManualAddressViewController.h"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define GoogleAPIKey    @"AIzaSyApojur33ruhuKZrXGYryRdwdWlBcxjXHM"

@interface ManualAddressViewController ()<CLLocationManagerDelegate>
{
    SPGooglePlacesAutocompleteQuery * searchQuery;
    NSMutableArray *locationsArray;
    NSArray * searchResultPlaces;
    CLLocationManager * locationManager;
    CLLocation *currentLocation;
}
@end

@implementation ManualAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [yourCartBtn setTitle:NSLocalizedString(@"YOUR CART", nil) forState:UIControlStateNormal];
    [addressTxtField becomeFirstResponder];
    if ([self.locationText isEqualToString:@""])
    {
        addressTxtField.placeholder = NSLocalizedString(@"Put address with number", nil);
    }
    else
    {
        addressTxtField.text = self.locationText;
    }
    addressTxtField.leftViewMode = UITextFieldViewModeAlways;
    UIImageView * leftView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 21)];
    leftView1.contentMode = UIViewContentModeScaleAspectFit;
    leftView1.backgroundColor = [UIColor clearColor];
    leftView1.image = [UIImage imageNamed:@"PostalFieldImg.png"];
    addressTxtField.leftView = leftView1;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBarHidden = YES;
    
    addressTxtField.layer.cornerRadius = 6.0f;
    addressTxtField.layer.masksToBounds = YES;
    addressTxtField.layer.borderColor = kGreyBorderColor;
    addressTxtField.layer.borderWidth = 2.5f;
    
    searchQuery = [[SPGooglePlacesAutocompleteQuery alloc] initWithApiKey:GoogleAPIKey];
    searchQuery.radius = 100.0;

    resultsTableView.multipleTouchEnabled = NO;

    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
#ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER)
    {
        // Use one or the other, not both. Depending on what you put in info.plist
        [locationManager requestAlwaysAuthorization];
    }
#endif
    [locationManager startUpdatingLocation];

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

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    currentLocation = [locations objectAtIndex:0];
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
    return locationsArray.count;
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
    cell.textLabel.text = [locationsArray objectAtIndex:indexPath.row];
    [cell.textLabel setFont:[UIFont fontWithName:kRobotoFontRegular size:12.0]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [addressTxtField resignFirstResponder];
    NSString * stateName = [locationsArray objectAtIndex:indexPath.row];
    [Utility setObject:stateName forKey:@"selectedState"];
    [Utility setBool:YES forKey:kIsManualAddress];
//    NSArray *controllers = self.navigationController.viewControllers;
//    for (UIViewController *controller in controllers) {
//        if ([controller isKindOfClass:[PlaceOrderViewController class]]) {
//        }
        [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleForSearchString:(NSString *)searchString
{
    searchString = [NSString stringWithFormat:@"%@ spain", searchString];
    
    if (![self hasLeadingNumberInString:searchString]) {
        searchString = [NSString stringWithFormat:@"1, %@", searchString];

    }
    searchQuery.location = currentLocation.coordinate;
    searchQuery.input = searchString;
    [kAppDelegate loadingEnd];
    [kAppDelegate loadingStart];
    [searchQuery fetchPlaces:^(NSArray *places, NSError *error) {
        [kAppDelegate loadingEnd];
        if (error)
        {
            NSLog(@"Could not fetch Places %@", error);
        }
        else
        {
            searchResultPlaces = places;
            if ([searchResultPlaces count] > 0)
            {
                [self reloadTableWithArray:searchResultPlaces];
            }
        }
    }];
}

-(void)reloadTableWithArray : (NSArray *)locations {
    locationsArray =[NSMutableArray new];

    for (SPGooglePlacesAutocompletePlace * place in locations)
    {
        NSString * name = place.name;
        [locationsArray addObject:name];
    }
    [resultsTableView reloadData];

}

#pragma mark - UITextField Delegates

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == addressTxtField)
    {
        NSString * finalString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        [self handleForSearchString:finalString];
    }
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.layer.cornerRadius = 6.0f;
    textField.layer.masksToBounds = YES;
    textField.layer.borderColor = kBlueBorderColor;
    textField.layer.borderWidth = 2.5f;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.layer.cornerRadius = 6.0f;
    textField.layer.masksToBounds = YES;
    textField.layer.borderColor = kGreyBorderColor;
    textField.layer.borderWidth = 2.5f;
    [textField layoutIfNeeded];


}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - IBAction Methods

- (IBAction)backButtonClicked:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)hasLeadingNumberInString : (NSString *)  string {
    if (string)
    {
        if (([string length] && isnumber([string characterAtIndex:0])) || ([string length] > 7 && isnumber([string characterAtIndex:string.length - 7])) ) {
            return YES;
        }
    }
    else
        return NO;
    return NO;
}

@end
