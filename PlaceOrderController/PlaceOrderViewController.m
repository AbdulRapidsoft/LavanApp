//
//  PlaceOrderViewController.m
//  LavanApp
//
//  Created by IPHONE-10 on 6/2/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define GoogleAPIKey    @"AIzaSyCw8hI0Clo0e1AvyD-nF7MQTJBDtdvZq_0"

#import "PlaceOrderViewController.h"

@interface PlaceOrderViewController () < UIGestureRecognizerDelegate, BTDropInViewControllerDelegate, StatePopOverViewControllerProtocol, CityPopOverViewControllerProtocol ,CLLocationManagerDelegate, LocationPopOverControllerProtocol, TimePopOverControllerProtocol, DatePopOverControllerProtocol >
{
    UIDatePicker * datePicker, * timePicker;
    AppDelegate * appDelegate;
    UIToolbar * doneButtonView;
    FPPopoverController * locationPopover, * popoverController;
    NSDictionary * stateServiceResponse;
    StatePopOverViewController * stateController;
    CityPopOverViewController * cityController;
    LocationPopoverController * locationController;
    TimePopOverController * timeslotController;
    DatePopoverController * dateController;
    BOOL isStateSelected, isLogin;
    NSString * orderId, * totalAmount;
    CLLocationManager * locationManager;
    UITextField * active_textfield;
    NSInteger selectedDateIndex;
    NSInteger selectedTimeIndex;
    BOOL gettingDateTime;
    BOOL isErrorViewShowing;
    BOOL couponApplied;
}

@property (weak, nonatomic) IBOutlet UILabel * cartCountLabel;

@end

@implementation PlaceOrderViewController

#pragma mark - view life cycle methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    selectedDateIndex = 0;
    selectedTimeIndex = 0;
    
    locationMapView.showsUserLocation = YES;
    
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
    
    appDelegate = [AppDelegate sharedInstance];
    selectedOrders = [[NSMutableArray alloc] initWithArray:appDelegate.cartItemsArray];
    
    self.navigationItem.hidesBackButton = YES;
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LogoImage.png"]];
    
    detailedAddressField.placeholder = NSLocalizedString(@"Bloque, piso, escalera", nil);
    
    directionField.leftViewMode = UITextFieldViewModeAlways;
    notesField.leftViewMode = UITextFieldViewModeAlways;
    coupenCodeField.leftViewMode = UITextFieldViewModeAlways;
    postalTextField.leftViewMode = UITextFieldViewModeAlways;
    cityTextField.leftViewMode = UITextFieldViewModeAlways;
    stateTextField.leftViewMode = UITextFieldViewModeAlways;
    detailedAddressField.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView * leftView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 21)];
    leftView1.contentMode = UIViewContentModeScaleAspectFit;
    leftView1.backgroundColor = [UIColor clearColor];
    leftView1.image = [UIImage imageNamed:@"PostalFieldImg.png"];
    directionField.leftView = leftView1;
    
    UIImageView * leftView2 = [[UIImageView alloc] initWithFrame:leftView1.frame];
    leftView2.contentMode = UIViewContentModeScaleAspectFit;
    leftView2.backgroundColor = [UIColor clearColor];
    leftView2.image = [UIImage imageNamed:@"NotesFieldImg.png"];
    notesField.leftView = leftView2;
    
    UIImageView * leftView3 = [[UIImageView alloc] initWithFrame:leftView1.frame];
    leftView3.contentMode = UIViewContentModeScaleAspectFit;
    leftView3.backgroundColor = [UIColor clearColor];
    leftView3.image = [UIImage imageNamed:@"CoupenCodeImg.png"];
    coupenCodeField.leftView = leftView3;
    
    UIImageView * leftView4 = [[UIImageView alloc] initWithFrame:leftView1.frame];
    leftView4.contentMode = UIViewContentModeScaleAspectFit;
    leftView4.backgroundColor = [UIColor clearColor];
    leftView4.image = [UIImage imageNamed:@"PostalFieldImg.png"];
    postalTextField.leftView = leftView4;
    
    UIImageView * leftView5 = [[UIImageView alloc] initWithFrame:leftView1.frame];
    leftView5.contentMode = UIViewContentModeScaleAspectFit;
    leftView5.backgroundColor = [UIColor clearColor];
    leftView5.image = [UIImage imageNamed:@"NotesFieldImg.png"];
    detailedAddressField.leftView = leftView5;
    
    UIView * leftView6 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 21)];
    leftView6.backgroundColor = [UIColor clearColor];
    cityTextField.leftView = leftView6;
    
    UIView * leftView7 = [[UIView alloc] initWithFrame:leftView6.frame];
    leftView7.backgroundColor = [UIColor clearColor];
    stateTextField.leftView = leftView7;
    
    stateTextField.enabled = NO;
    cityTextField.enabled = NO;
    sendRequestBtn.layer.masksToBounds = YES;
    sendRequestBtn.layer.cornerRadius = 5.0;
    
    tableHeightConstraint.constant = (([selectedOrders count] + 1) * 50);
    
    totalCartViewYConstraint.constant = 13.0;
    discountCartView.hidden = YES;
    enterCoupenCodeBtnYConstraint.constant = 73.0;
    errorInCoupenCodeView.hidden = YES;
    coupenCodeView.hidden = YES;
    sendRequestBtnYConstraint.constant = 113.0;
    
    [sendRequestBtn layoutIfNeeded];
    
    float viewHeight = sendRequestBtn.frame.origin.y + sendRequestBtn.frame.size.height + 24;
    mainViewHeightConstraint.constant = viewHeight;
    mainScrollViewHeightConstraint.constant = viewHeight;
    
    self.cartCountLabel.layer.cornerRadius = 10;
    self.cartCountLabel.layer.masksToBounds = YES;
    
    for (UIView * subView in containerView.subviews)
    {
        if ([subView isKindOfClass:[UITextField class]])
        {
            subView.layer.cornerRadius = 6.0f;
            subView.layer.masksToBounds = YES;
            subView.layer.borderColor = kGreyBorderColor;
            subView.layer.borderWidth = 2.5f;
        }
    }
    
    coupenCodeField.layer.cornerRadius = 6.0f;
    coupenCodeField.layer.masksToBounds = YES;
    coupenCodeField.layer.borderColor = kGreyBorderColor;
    coupenCodeField.layer.borderWidth = 2.5f;
    
    applyCoupenCodeBtn.layer.cornerRadius = 8.0f;
    applyCoupenCodeBtn.layer.masksToBounds = YES;
    
    collectionPickerContainerView.layer.cornerRadius = 6.0f;
    collectionPickerContainerView.layer.masksToBounds = YES;
    collectionPickerContainerView.layer.borderColor = kGreyBorderColor;
    collectionPickerContainerView.layer.borderWidth = 2.5f;
    
    deliveryPickerContainerView.layer.cornerRadius = 6.0f;
    deliveryPickerContainerView.layer.masksToBounds = YES;
    deliveryPickerContainerView.layer.borderColor = kGreyBorderColor;
    deliveryPickerContainerView.layer.borderWidth = 2.5f;
    
    searchQuery = [[SPGooglePlacesAutocompleteQuery alloc] initWithApiKey:GoogleAPIKey];
    searchQuery.radius = 100.0;
    
    opaqueView.hidden = YES;
    loginAlertView.hidden = YES;
    
    [self getCityAndStateNamesFromServer];
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;

    if (!gettingDateTime)
    {
        
        isLogin = [Utility boolForKey:kIsLogin];
        [self updateCartLabelValue];
        
        directionField.text =  [Utility objectForKey:@"directionFieldText"];
            postalTextField.text = [Utility objectForKey:@"postalTextFieldText"];
        notesField.text = [Utility objectForKey:@"notesFieldText"];
        detailedAddressField.text = [Utility objectForKey:@"detailedAddressText"];
        
        NSMutableDictionary * dict1 = (NSMutableDictionary *)[Utility objectForKey:@"pickOrderDateLblText"];
        pickOrderDateLbl.text = [dict1 objectForKey:@"DeviceDate"];
        pickOrderTimeLbl.text = [Utility objectForKey:@"pickOrderTimeLblText"];
        
        NSMutableDictionary * dict2 = (NSMutableDictionary *)[Utility objectForKey:@"dropOrderDateLblText"];
        dropOrderDateLbl.text = [dict2 objectForKey:@"DeviceDate"];
        dropOrderTimeLbl.text = [Utility objectForKey:@"dropOrderTimeLblText"];
        
        stateTextField.text = [Utility objectForKey:@"stateTextFieldText"];
        cityTextField.text = [Utility objectForKey:@"cityTextFieldText"];
        kAppDelegate.selectedStateId = [Utility objectForKey:@"stateTextFieldID"];
        kAppDelegate.selectedCityId = [Utility objectForKey:@"cityTextFieldID"];
        
        [self calculateTotalCostOfTheOrder];
        
        if ([Utility boolForKey:@"couponApplied"])
        {
            [self showSuccessViewForCouponCode];
        }
        if ([stateTextField.text length] > 0)
        {
            isStateSelected = YES;
        }
        
    }
    gettingDateTime = NO;
    if ([Utility boolForKey:kIsManualAddress]) {
        [directionField resignFirstResponder];
        directionField.text = [Utility objectForKey:@"selectedState"];
        postalTextField.text = @"";
        stateTextField.text = @"";
        cityTextField.text = @"";
        
        [self getLocationFromAddressString:directionField.text];
        if (!postalTextField.text.length) {
            [RSTAlertView showAlertMessage:NSLocalizedString(@"Por favor, para obtener mejores resultados rellene su dirección con número, en caso contrario rellene manualmente los campos", nil) withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
                if (buttonIndex == 0) {}
            }];
        }
        if ((postalTextField.text.length && stateTextField.text.length && cityTextField.text.length)) {
            postalTextField.enabled = NO;
            stateButton.enabled = NO;
            cityButton.enabled = NO;
        }
        else {
            postalTextField.enabled = YES;
            stateButton.enabled = YES;
            cityButton.enabled = YES;

        }
        if (isLogin)
        {
            [Utility setObject:directionField.text forKey:@"directionFieldText"];
        }
        
        [Utility setBool:NO forKey:kIsManualAddress];
    }

}

- (void)updateCartLabelValue
{
    if ([appDelegate.cartItemsArray count] > 0)
    {
        [self.cartCountLabel setHidden:NO];
        int totalCloths = 0;
        for (ClothDetails * clothObj in appDelegate.cartItemsArray)
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
        self.cartCountLabel.text = @"";
        [self.cartCountLabel setHidden:YES];
    }
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

#pragma mark - UIMapKit Delegate Methods

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    [mapView removeAnnotations:mapView.annotations];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [mapView setRegion:[mapView regionThatFits:region] animated:YES];
    CLLocation *myLocation = [[CLLocation alloc] initWithLatitude:userLocation.location.coordinate.latitude longitude:userLocation.location.coordinate.longitude];
    MKPointAnnotation * annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = myLocation.coordinate;
    [mapView addAnnotation:annotation];
    CLGeocoder * geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:myLocation
                   completionHandler:^(NSArray * placemarks, NSError * error) {
                       dispatch_async(dispatch_get_main_queue(),^ {
                           if (placemarks.count)
                           {
                               [self clearStateAndCityField];
                               
                               CLPlacemark * place = [placemarks objectAtIndex:0];
                               NSString * addressString;
                               for (NSString * string in [place.addressDictionary valueForKey:@"FormattedAddressLines"])
                               {
                                    if ([place.addressDictionary valueForKey:@"Thoroughfare"]) {
                                       if ([place.addressDictionary valueForKey:@"SubThoroughfare"]) {
                                            addressString = [NSString stringWithFormat:@"%@, %@", [place.addressDictionary valueForKey:@"Thoroughfare"], [place.addressDictionary valueForKey:@"SubThoroughfare"]];
                                       }
                                       else {
                                           addressString = [NSString stringWithFormat:@"%@", [place.addressDictionary valueForKey:@"Thoroughfare"]];
                                       }
                                   }
                                   
                                   else {
                                       addressString = [NSString stringWithFormat:@"%@", [place.addressDictionary valueForKey:@"SubAdministrativeArea"]];

                                   }
                               }
                               directionField.text = addressString;
                               if (![Utility boolForKey:kIsManualAddress]) {
                                   postalTextField.text = [place.addressDictionary valueForKey:@"ZIP"];
                               }
                               locationMapView.showsUserLocation = NO;
                               
                               for (int i = 0; i < stateServiceResponse.allKeys.count; i++)
                               {
                                   NSDictionary * dict = [stateServiceResponse objectForKey:[NSString stringWithFormat:@"%d", i + 1]];
                                   if (dict)
                                   {
                                       NSMutableString * stateName = [dict objectForKey:@"name"];
                                       
                                       if ([stateName caseInsensitiveCompare:[place.addressDictionary valueForKey:@"SubAdministrativeArea"]] == NSOrderedSame) {
                                           stateTextField.text = [dict objectForKey:@"name"];
                                           kAppDelegate.selectedStateId = [dict objectForKey:@"id"];
                                           cityTextField.text = @"";
                                           kAppDelegate.selectedCityId = @"";
                                           isStateSelected = YES;
                                           if (isLogin)
                                           {
                                               [Utility setObject:stateTextField.text forKey:@"stateTextFieldText"];
                                               [Utility setObject:[dict objectForKey:@"id"] forKey:@"stateTextFieldID"];
                                           }
                                       }
                                   }
                               }
                               for (int i = 0; i < stateServiceResponse.allKeys.count; i++)
                               {
                                   NSDictionary * dict = [stateServiceResponse objectForKey:[NSString stringWithFormat:@"%d", i + 1]];
                                   
                                   if ([[dict objectForKey:@"id"] isEqualToString:kAppDelegate.selectedStateId])
                                   {
                                       NSArray * cityArray = [dict objectForKey:@"cities"];
                                       for (NSDictionary * cityDict in cityArray)
                                       {
                                           if ([cityDict objectForKey:@"name"] && [[cityDict objectForKey:@"name"] caseInsensitiveCompare:[place.addressDictionary valueForKey:@"City"]] == NSOrderedSame) {
                                               
                                               cityTextField.text = [cityDict objectForKey:@"name"];
                                               kAppDelegate.selectedCityId = [cityDict objectForKey:@"id"];
                                               
                                               if (isLogin)
                                               {
                                                   [Utility setObject:cityTextField.text forKey:@"cityTextFieldText"];
                                                   [Utility setObject:[cityDict objectForKey:@"id"] forKey:@"cityTextFieldID"];
                                               }
                                               if ((postalTextField.text.length && stateTextField.text.length && cityTextField.text.length)) {
                                                   postalTextField.enabled = NO;
                                                   stateButton.enabled = NO;
                                                   cityButton.enabled = NO;
                                               }
                                               else {
                                                   postalTextField.enabled = YES;
                                                   stateButton.enabled = YES;
                                                   cityButton.enabled = YES;
                                                   
                                               }

                                           }
                                       }
                                   }
                               }
                           }
                       });
                   }];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString * identifier = @"RoutePinAnnotation";
    MKPinAnnotationView * currentLocationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
    currentLocationView.image = [UIImage imageNamed:@"GoogleMapPin.png"];
    return currentLocationView;
}

- (void)getLocationFromAddressString:(NSString *)addressStr
{
    double latitude = 0, longitude = 0;
    NSString * esc_addr =  [addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString * result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result)
    {
        NSScanner * scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil])
        {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil])
            {
                [scanner scanDouble:&longitude];
            }
        }
        NSError * jsonError;
        NSData * objectData = [result dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * allValues = [NSJSONSerialization JSONObjectWithData:objectData
                                                                   options:NSJSONReadingMutableContainers
                                                                     error:&jsonError];
        NSArray * result_array = [allValues objectForKey:@"results"];
        for(int i = 0; i < [result_array count]; i++)
        {
            NSDictionary * values = (NSDictionary *)[result_array objectAtIndex:i];
            
            NSArray * component = [(NSDictionary *)values objectForKey:@"address_components"];
            if([[[component objectAtIndex:0] objectForKey:@"types"] containsObject:@"street_number"]) {
                directionField.text = [NSString stringWithFormat:@"%@, %@",[[component objectAtIndex:1] objectForKey:@"long_name"], [[component objectAtIndex:0] objectForKey:@"long_name"]];
            }
            else {
                directionField.text = [Utility objectForKey:@"selectedState"];
                
            }

            for(int j = 0; j < [component count]; j++)
            {
                NSDictionary * parts = (NSDictionary *)[component objectAtIndex:j];
                if([[parts objectForKey:@"types"] containsObject:@"postal_code"])
                {
                    NSLog(@"Postal Code : %@ ",[parts objectForKey:@"long_name"]);
                    postalTextField.text = [parts objectForKey:@"long_name"];
                    [Utility setObject:postalTextField.text forKey:@"postalTextFieldText"];
                    break;
                }
            }
            for(int k = 0; k < [component count]; k++)
            {
                NSDictionary * parts = (NSDictionary *)[component objectAtIndex:k];
                if([[parts objectForKey:@"types"] containsObject:@"administrative_area_level_2"])
                {
                    NSLog(@"State Name : %@ ",[parts objectForKey:@"long_name"]);
                    for (int l = 0; l < stateServiceResponse.allKeys.count; l++)
                    {
                        NSDictionary * dict = [stateServiceResponse objectForKey:[NSString stringWithFormat:@"%d", l + 1]];
                        if (dict)
                        {
                            if ([[dict objectForKey:@"name"] caseInsensitiveCompare:[parts objectForKey:@"long_name"]] == NSOrderedSame) {
                                stateTextField.text = [dict objectForKey:@"name"];
                                
                                kAppDelegate.selectedStateId = [dict objectForKey:@"id"];
                                                             cityTextField.text = @"";
                                kAppDelegate.selectedCityId = @"";
                                isStateSelected = YES;
                                if (isLogin)
                                {
                                    [Utility setObject:stateTextField.text forKey:@"stateTextFieldText"];
                                    [Utility setObject:[dict objectForKey:@"id"] forKey:@"stateTextFieldID"];
                                }
                                for (int m = 0; m < stateServiceResponse.allKeys.count; m++)
                                {
                                    NSDictionary * dict = [stateServiceResponse objectForKey:[NSString stringWithFormat:@"%d", m + 1]];
                                    
                                    if ([[dict objectForKey:@"id"] isEqualToString:kAppDelegate.selectedStateId])
                                    {
                                        NSArray * cityArray = [dict objectForKey:@"cities"];
                                        
                                        for(int n = 0; n < [component count]; n++)
                                        {
                                            NSDictionary * part = (NSDictionary *)[component objectAtIndex:n];
                                            if([[part objectForKey:@"types"] containsObject:@"locality"])
                                            {
                                                for (NSDictionary * cityDict in cityArray)
                                                {
                                                    if ([[cityDict objectForKey:@"name"] caseInsensitiveCompare:[part objectForKey:@"long_name"]] == NSOrderedSame) {
                                                        NSLog(@"City Name : %@ ",[part objectForKey:@"long_name"]);
                                                        
                                                        cityTextField.text = [cityDict objectForKey:@"name"];
                                                        kAppDelegate.selectedCityId = [cityDict objectForKey:@"id"];
                                                        
                                                        if (isLogin)
                                                        {
                                                            [Utility setObject:cityTextField.text forKey:@"cityTextFieldText"];
                                                            [Utility setObject:[cityDict objectForKey:@"id"] forKey:@"cityTextFieldID"];
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    break;
                }
                else {
                    
                }
            }
        }

    }
    CLLocationCoordinate2D center;
    center.latitude = latitude;
    center.longitude = longitude;
    
    if (result)
    {
        NSArray * all_annotations = locationMapView.annotations;
        [locationMapView removeAnnotations:all_annotations];
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(center, 800, 800);
        [locationMapView setRegion:[locationMapView regionThatFits:region] animated:YES];
        
        MKPointAnnotation * annotation = [[MKPointAnnotation alloc] init];
        annotation.coordinate = center;
        [locationMapView addAnnotation:annotation];
    }
    
       locationMapView.showsUserLocation = NO;
}

- (void)handleForSearchString:(NSString *)searchString
{
    searchQuery.location = locationMapView.userLocation.coordinate;
    searchQuery.input = searchString;
    [searchQuery fetchPlaces:^(NSArray *places, NSError *error) {
        if (error)
        {
            NSLog(@"Could not fetch Places %@", error);
        }
        else
        {
            searchResultPlaces = places;
            if ([searchResultPlaces count] > 0)
            {
                [self showPopoverForPlaces:searchResultPlaces];
            }
        }
    }];
}

- (void)showPopoverForPlaces:(NSArray *)locations
{
    NSMutableArray * locationArray = [[NSMutableArray alloc] init];
    for (SPGooglePlacesAutocompletePlace * place in locations)
    {
        NSString * name = place.name;
        [locationArray addObject:name];
    }
    if (locationPopoverPresented)
    {
        [locationPopover presentPopoverFromView:directionField];
        
        locationController.locationsArray = locationArray;
        [locationController.locationListTableView reloadData];
    }
    else
    {
        //the view controller you want to present as popover
        locationController = [self.storyboard instantiateViewControllerWithIdentifier:@"LocationPopoverController"];
        locationController.locationsArray = locationArray;
        locationController.delegate = self;
        
        //location popover
        locationPopover = [[FPPopoverController alloc] initWithViewController:locationController];
        CGSize popoverSize = locationPopover.contentSize;
        popoverSize.width = self.view.frame.size.width;
        popoverSize.height = popoverSize.height;
        locationPopover.contentSize = popoverSize;
        locationPopover.arrowDirection = FPPopoverArrowDirectionDown;
        locationPopover.border = NO;
        locationPopover.tint = FPPopoverWhiteTint;
        [locationPopover presentPopoverFromView:directionField];
        
        locationPopoverPresented = YES;
    }
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
    return [selectedOrders count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [selectedOrders count])
    {
        AddMoreOrderCell * cell = [AddMoreOrderCell createNewCell:self];
        [cell.addMoreButton addTarget:self action:@selector(addMoreOrderClicked) forControlEvents:UIControlEventTouchUpInside];
        cell.textLabel.text = NSLocalizedString(@"ADD NEW ARTICLE", nil);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        SelectedOrderCell * cell = (SelectedOrderCell *)[tableView dequeueReusableCellWithIdentifier:@"OrdersCell"];
        if (cell == nil)
        {
            cell = [SelectedOrderCell CreateCustomCell:self];
            [cell.removeButton addTarget:self action:@selector(removeAnItem:) forControlEvents:UIControlEventTouchUpInside];
            [cell.addButton addTarget:self action:@selector(addAnItem:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        ClothDetails * clothObj = [selectedOrders objectAtIndex:indexPath.row];
        cell.clothName.text = clothObj.clothName;
        cell.batgeNumber.text = clothObj.numberofItems;
        cell.batgeNumber.numberOfLines = 1;
        cell.batgeNumber.minimumScaleFactor = 8./cell.batgeNumber.font.pointSize;
        cell.batgeNumber.adjustsFontSizeToFitWidth = YES;
        CGFloat actualFontSize;
        CGSize adjustedSize = [cell.batgeNumber.text sizeWithFont:cell.batgeNumber.font
                                                    minFontSize:cell.batgeNumber.minimumFontSize
                                                 actualFontSize:&actualFontSize
                                                       forWidth:cell.batgeNumber.bounds.size.width
                                                  lineBreakMode:cell.batgeNumber.lineBreakMode];
        CGFloat differenceInFontSize = cell.batgeNumber.font.pointSize - actualFontSize;
        cell.batgeNumber.font = [UIFont fontWithName:cell.batgeNumber.font.fontName size:cell.batgeNumber.font.pointSize - differenceInFontSize];

        float totalCloths = [clothObj.numberofItems floatValue];
        float pricePerCloth = [clothObj.clothPrice floatValue];
        float totalCost = totalCloths * pricePerCloth;
        cell.clothPrice.text = [NSString stringWithFormat:@"%.02f€",totalCost];
        cell.clothPrice.numberOfLines = 1;
        cell.clothPrice.minimumScaleFactor = 8./cell.clothPrice.font.pointSize;
        cell.clothPrice.adjustsFontSizeToFitWidth = YES;
        
        cell.removeButton.tag = indexPath.row;
        cell.addButton.tag = indexPath.row;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Class Methods

- (void)removeAnItem:(UIButton *)sender
{
    ClothDetails * clothObj = [appDelegate.cartItemsArray objectAtIndex:sender.tag];
    if ([clothObj.numberofItems intValue] > 0) {
        clothObj.numberofItems = [NSString stringWithFormat:@"%d",[clothObj.numberofItems intValue] - 1];

        if ([clothObj.numberofItems intValue] == 0) {
                [appDelegate.cartItemsArray removeObject:clothObj];
            tableHeightConstraint.constant -= 44;
            mainViewHeightConstraint.constant -= 44;

        }
        else {
            UILabel * itemCountLabel = (UILabel*)[sender.superview viewWithTag:896];
            [itemCountLabel setText:clothObj.numberofItems];
            itemCountLabel.numberOfLines = 1;
            itemCountLabel.minimumScaleFactor = 8./itemCountLabel.font.pointSize;
            itemCountLabel.adjustsFontSizeToFitWidth = YES;
            CGFloat actualFontSize;
            CGSize adjustedSize = [itemCountLabel.text sizeWithFont:itemCountLabel.font
                                                        minFontSize:itemCountLabel.minimumFontSize
                                                     actualFontSize:&actualFontSize
                                                           forWidth:itemCountLabel.bounds.size.width
                                                      lineBreakMode:itemCountLabel.lineBreakMode];
            CGFloat differenceInFontSize = itemCountLabel.font.pointSize - actualFontSize;
            itemCountLabel.font = [UIFont fontWithName:itemCountLabel.font.fontName size:itemCountLabel.font.pointSize - differenceInFontSize];
        }
        
    selectedOrders = [[NSMutableArray alloc] initWithArray:appDelegate.cartItemsArray];
    [selectedItemsTable reloadData];
    [self updateCartLabelValue];
    
    if (selectedOrders.count)
    {
        [self calculateTotalCostOfTheOrder];
    }
    else
    {
        totalOrderCost = 0;
        totalCartLbl.text = @"0.00€";
        [self noCoupenCodeClicked:nil];
        [Utility setBool:NO forKey:@"couponApplied"];
        [Utility setObject:nil forKey:@"PercentageOff"];
        [Utility setObject:nil forKey:@"MinimumOrder"];
    }
       
    }
}

-(void)addAnItem :(UIButton *)sender {
    ClothDetails * clothObj = [appDelegate.cartItemsArray objectAtIndex:sender.tag];
        clothObj.numberofItems = [NSString stringWithFormat:@"%d",[clothObj.numberofItems intValue] + 1];
    
        UILabel * itemCountLabel = (UILabel*)[sender.superview viewWithTag:896];
        [itemCountLabel setText:clothObj.numberofItems];
        itemCountLabel.numberOfLines = 1;
        itemCountLabel.minimumScaleFactor = 8./itemCountLabel.font.pointSize;
        itemCountLabel.adjustsFontSizeToFitWidth = YES;
        CGFloat actualFontSize;
        CGSize adjustedSize = [itemCountLabel.text sizeWithFont:itemCountLabel.font
                                                         minFontSize:itemCountLabel.minimumFontSize
                                                      actualFontSize:&actualFontSize
                                                            forWidth:itemCountLabel.bounds.size.width
                                                       lineBreakMode:itemCountLabel.lineBreakMode];
        CGFloat differenceInFontSize = itemCountLabel.font.pointSize - actualFontSize;
        itemCountLabel.font = [UIFont fontWithName:itemCountLabel.font.fontName size:itemCountLabel.font.pointSize - differenceInFontSize];

        selectedOrders = [[NSMutableArray alloc] initWithArray:appDelegate.cartItemsArray];
        [selectedItemsTable reloadData];
        [self updateCartLabelValue];
        
        if (selectedOrders.count)
        {
            [self calculateTotalCostOfTheOrder];
        }
        else
        {
            totalOrderCost = 0;
            totalCartLbl.text = @"0.00€";
            [self noCoupenCodeClicked:nil];
            [Utility setBool:NO forKey:@"couponApplied"];
            [Utility setObject:nil forKey:@"PercentageOff"];
            [Utility setObject:nil forKey:@"MinimumOrder"];
        }
}

- (void)addMoreOrderClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getCityAndStateNamesFromServer
{
    NSString * deviceToken = [Utility objectForKey:@"DeviceToken"];
    if (deviceToken == nil)
    {
        deviceToken = @"0123456789";
    }
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", kBaseURL]];
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:@"STATE_CITY_SERVICE" forKey:@"request_type_sent"];
    [dictionary setObject:@"2" forKey:@"device_type"];
    [dictionary setObject:deviceToken forKey:@"device_id"];
    dictionary = (NSMutableDictionary *)[Utility convertIntoBase64:[dictionary allValues] dictionary:dictionary];
    
    [dictionary setObject:@"1" forKey:@"decode"];
    
    WebCommunication * webComm = [WebCommunication new];
    [webComm callToServerRequestDictionary:dictionary onURL:url WithBlock:^(NSDictionary * response, NSInteger status_code, NSError *error, WebCommunication *webComm)
     {
         if ([response.allValues count] > 0)
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
             NSLog(@"%@", [response objectForKey:@"error_desc"]);
         }
         else
         {
             stateServiceResponse  = response;
         }
     }];
}

- (void)calculateTotalCostOfTheOrder
{
    float totalMoney = 0;
    for (ClothDetails * clothObj in selectedOrders)
    {
        float totalCloths = [clothObj.numberofItems floatValue];
        float pricePerCloth = [clothObj.clothPrice floatValue];
        float totalPrice = totalCloths * pricePerCloth;
        totalMoney += totalPrice;
    }
    totalOrderCost = totalMoney;
    
    if ([Utility boolForKey:@"couponApplied"])
    {
        float mini_order = [[Utility objectForKey:@"MinimumOrder"] floatValue];
        if (totalOrderCost >= mini_order)
        {
            float percentageOff = [[Utility objectForKey:@"PercentageOff"] floatValue];
            if (percentageOff > 0)
            {
                totalDiscountCost = (totalOrderCost*percentageOff)/100;
                totalOrderCost -= totalDiscountCost;
                [Utility setObject:[NSString stringWithFormat:@"%f", totalDiscountCost] forKey:@"totalDiscount"];
                totalDiscountLbl.text = [NSString stringWithFormat:@"- %.02f€",totalDiscountCost];
            }
            else
            {
                totalOrderCost = totalOrderCost - [[Utility objectForKey:@"totalDiscount"] floatValue];
            }
        }
        else
        {
            [self noCoupenCodeClicked:nil];
            [Utility setBool:NO forKey:@"couponApplied"];
            [Utility setObject:nil forKey:@"PercentageOff"];
            [Utility setObject:nil forKey:@"MinimumOrder"];
            [Utility setObject:nil forKey:@"DiscountCoupenName"];
        }
    }
    totalCartLbl.text = [NSString stringWithFormat:@"%.02f€",totalOrderCost];
    totalCartLbl.numberOfLines = 1;
    totalCartLbl.minimumScaleFactor = 8./totalCartLbl.font.pointSize;
    totalCartLbl.adjustsFontSizeToFitWidth = YES;
}

-(void)checkSavedCards {
    
    NSString * deviceToken = [Utility objectForKey:@"DeviceToken"];
    if (deviceToken == nil)
    {
        deviceToken = @"0123456789";
    }
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", kBaseURL]];
    
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:@"GET_SAVED_CARDS_SERVICE" forKey:@"request_type_sent"];
    [dictionary setObject:[Utility objectForKey:kUserId] forKey:kUserId];
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
             NSArray *savedCardsArray = [response objectForKey:@"saved_cards"];
             if (!savedCardsArray.count) {
                 CreditCardPaymentViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"CreditCardPaymentViewController"];
                 [self.navigationController pushViewController:controller animated:YES];
             }
             else {
                 SavedCardsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SavedCardsViewController"];
                 [controller setSavedCards:savedCardsArray];
                 [self.navigationController pushViewController:controller animated:YES];
                 
             }
             
         }
         [[AppDelegate sharedInstance] loadingEnd];
     }];
}

#pragma mark - UITextField Delegates

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    active_textfield = textField;
    
        return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [scrollView scrollToActiveTextField];
    if (textField == cityTextField || textField == stateTextField)
    {
        return NO;
    }
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == directionField)
    {
        [textField resignFirstResponder];
        ManualAddressViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ManualAddressViewController"];
        controller.locationText = textField.text;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else {
    
    textField.layer.cornerRadius = 6.0f;
    textField.layer.masksToBounds = YES;
    textField.layer.borderColor = kBlueBorderColor;
    textField.layer.borderWidth = 2.5f;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.layer.cornerRadius = 6.0f;
    textField.layer.masksToBounds = YES;
    textField.layer.borderColor = kGreyBorderColor;
    textField.layer.borderWidth = 2.5f;
    [textField layoutIfNeeded];

    if (isLogin)
    {
        [Utility setObject:directionField.text forKey:@"directionFieldText"];
        [Utility setObject:postalTextField.text forKey:@"postalTextFieldText"];
        [Utility setObject:notesField.text forKey:@"notesFieldText"];
        [Utility setObject:detailedAddressField.text forKey:@"detailedAddressText"];
    }
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == directionField)
    {
        [self dismisLocationPopover:textField.text];
    }
    [textField resignFirstResponder];
    return YES;
}

- (void)dismisLocationPopover:(NSString *)address
{
    [locationPopover dismissPopoverAnimated:NO];
    locationPopoverPresented = NO;
    
    [self clearStateAndCityField];
    [self getLocationFromAddressString:address];
}

- (void)clearStateAndCityField
{
    postalTextField.text = @"";
    stateTextField.text = @"";
    kAppDelegate.selectedStateId = @"";
    cityTextField.text = @"";
    kAppDelegate.selectedCityId = @"";
    isStateSelected = NO;
    if (isLogin)
    {
        [Utility setObject:nil forKey:@"stateTextFieldText"];
        [Utility setObject:nil forKey:@"stateTextFieldID"];
        [Utility setObject:nil forKey:@"cityTextFieldText"];
        [Utility setObject:nil forKey:@"cityTextFieldID"];
    }
}

#pragma mark - IBAction Methods

- (IBAction)backButtonClicked:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)showCalenderButtonClicked:(UIButton *)sender
{
    [active_textfield resignFirstResponder];
    
    //the view controller you want to present as popover
    dateController = [self.storyboard instantiateViewControllerWithIdentifier:@"DatePopoverController"];
    dateController.selected_tag = sender.tag;
    dateController.delegate = self;
    dateController.selected_index = selectedDateIndex;
    
    if (sender.tag == 1091)
    {
        collectionPickerContainerView.layer.cornerRadius = 6.0f;
        collectionPickerContainerView.layer.masksToBounds = YES;
        collectionPickerContainerView.layer.borderColor = kGreyBorderColor;
        collectionPickerContainerView.layer.borderWidth = 2.5f;
        
        gettingDateTime = YES;
        [self.navigationController pushViewController:dateController animated:YES];
    }
    else // 1092
    {
        if ([pickOrderDateLbl.text length] > 1 && [pickOrderTimeLbl.text length] >1)
        {
            deliveryPickerContainerView.layer.cornerRadius = 6.0f;
            deliveryPickerContainerView.layer.masksToBounds = YES;
            deliveryPickerContainerView.layer.borderColor = kGreyBorderColor;
            deliveryPickerContainerView.layer.borderWidth = 2.5f;
            
            gettingDateTime = YES;
            [self.navigationController pushViewController:dateController animated:YES];
        }
        else
        {
            [RSTAlertView showAlertMessage:NSLocalizedString(@"Por favor seleccione la fecha y hora de recogida en primer lugar.", nil) withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
                if (buttonIndex == 0) {}
            }];
        }
    }
}

- (IBAction)showTimeButtonClicked:(UIButton *)sender
{
    [active_textfield resignFirstResponder];
    
    //the view controller you want to present as popover
    timeslotController = [self.storyboard instantiateViewControllerWithIdentifier:@"TimePopOverController"];
    timeslotController.selected_tag = sender.tag;
    timeslotController.selected_index = selectedTimeIndex;
    timeslotController.selected_date_string = pickOrderDateLbl.text;
    timeslotController.selected_time_string = pickOrderTimeLbl.text;
    timeslotController.delegate = self;
    
    if (sender.tag == 1093)
    {
        if ([pickOrderDateLbl.text length] > 1)
        {
            collectionPickerContainerView.layer.cornerRadius = 6.0f;
            collectionPickerContainerView.layer.masksToBounds = YES;
            collectionPickerContainerView.layer.borderColor = kGreyBorderColor;
            collectionPickerContainerView.layer.borderWidth = 2.5f;
            
            gettingDateTime = YES;
            [self.navigationController pushViewController:timeslotController animated:YES];
        }
        else
        {
            [RSTAlertView showAlertMessage:NSLocalizedString(@"Please select collection date first.", nil) withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
                if (buttonIndex == 0) {}
            }];
        }
    }
    else // 1094
    {
        if ([pickOrderDateLbl.text length] > 1 && [pickOrderTimeLbl.text length] > 1 && [dropOrderDateLbl.text length] > 1)
        {
            deliveryPickerContainerView.layer.cornerRadius = 6.0f;
            deliveryPickerContainerView.layer.masksToBounds = YES;
            deliveryPickerContainerView.layer.borderColor = kGreyBorderColor;
            deliveryPickerContainerView.layer.borderWidth = 2.5f;
            
            gettingDateTime = YES;
            [self.navigationController pushViewController:timeslotController animated:YES];
        }
        else
        {
            [RSTAlertView showAlertMessage:NSLocalizedString(@"Please select collection time and delivery date first.", nil) withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
                if (buttonIndex == 0) {}
            }];
        }
    }
}

- (IBAction)applyCoupenCodeClicked:(UIButton *)sender
{
    [active_textfield resignFirstResponder];
    
    coupenDetailsArr = [[NSMutableArray alloc] init];
    
    if ([[coupenCodeField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0)
    {
        coupenCodeField.layer.cornerRadius = 6.0f;
        coupenCodeField.layer.masksToBounds = YES;
        coupenCodeField.layer.borderColor = kRedBorderColor;
        coupenCodeField.layer.borderWidth = 2.5f;
    }
    else
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
        
        
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", kBaseURL]];
        NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
        [dictionary setObject:@"APPLY_COUPON_SERVICE" forKey:@"request_type_sent"];
        [dictionary setValue:[coupenCodeField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"coupon_code"];
        [dictionary setObject:@"2" forKey:@"device_type"];
        [dictionary setObject:deviceToken forKey:@"device_id"];
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
             
             //NSLog(@"response : %@",response);
             
             if([[response objectForKey:@"error_code"] isEqualToString:@"400"])
             {
                 NSLog(@"Coupon Code not successfully applied due to some problem.");
                 
                 [self showErrorViewForCouponCode];
             }
             else
             {
                 NSLog(@"Coupon Code successfully applied.");
                 couponApplied =YES;

                 // Will Return an array in coupenDetailsArr
                 
                 float mini_order = [[response objectForKey:@"minimum_order"] floatValue];
                 if (totalOrderCost >= mini_order)
                 {
                     if ([[response objectForKey:@"discount_type"] intValue] == 1)
                     {
                         CGFloat percentageOff = [[response objectForKey:@"discount"] floatValue];
                         
                         totalDiscountCost = (totalOrderCost*percentageOff)/100;
                         couponID = [response objectForKey:@"id"];
                         totalOrderCost -= totalDiscountCost;
                         [Utility setObject:[NSString stringWithFormat:@"%f", percentageOff] forKey:@"PercentageOff"];
                     }
                     else
                     {
                         totalDiscountCost = [[response objectForKey:@"discount"] floatValue];
                         couponID = [response objectForKey:@"id"];
                         totalOrderCost -= totalDiscountCost;
                         [Utility setObject:nil forKey:@"PercentageOff"];
                     }
                     totalCartLbl.text = [NSString stringWithFormat:@"%.02f€",totalOrderCost];
                     [Utility setBool:YES forKey:@"couponApplied"];
                     [Utility setObject:[response objectForKey:@"minimum_order"] forKey:@"MinimumOrder"];
                     [Utility setObject:[NSString stringWithFormat:@"%f", totalDiscountCost] forKey:@"totalDiscount"];
                     [Utility setObject:[response objectForKey:@"coupon_code"] forKey:@"DiscountCoupenName"];
                     couponNameLbl.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"Discount:", nil), [response objectForKey:@"coupon_code"]];
                     
                     [self showSuccessViewForCouponCode];
                 }
                 else
                 {
                     [self showErrorViewForCouponCode];
                     totalDiscountCost = 0.0f;
                 }
             }
             [[AppDelegate sharedInstance] loadingEnd];
         }];
    }
}

- (IBAction)noCoupenCodeClicked:(UIButton *)sender
{
    coupenCodeField.layer.cornerRadius = 6.0f;
    coupenCodeField.layer.masksToBounds = YES;
    coupenCodeField.layer.borderColor = kGreyBorderColor;
    coupenCodeField.layer.borderWidth = 2.5f;
    
    isErrorViewShowing = NO;
    
    enterCoupenCodeBtn.hidden = NO;
    sendRequestBtn.alpha = 1.0;
    sendRequestBtn.userInteractionEnabled = YES;
    
    totalCartViewYConstraint.constant = 13.0;
    discountCartView.hidden = YES;
    enterCoupenCodeBtnYConstraint.constant = 73.0;
    errorInCoupenCodeView.hidden = YES;
    coupenCodeView.hidden = YES;
    sendRequestBtnYConstraint.constant = 113.0;
    
    [sendRequestBtn layoutIfNeeded];
    float viewHeight = sendRequestBtn.frame.origin.y + sendRequestBtn.frame.size.height + 24;
    mainViewHeightConstraint.constant = viewHeight;
    mainScrollViewHeightConstraint.constant = viewHeight;
    
    scrollView.contentOffset = CGPointMake(0, scrollView.contentSize.height);
}

- (IBAction)sendRequestBtnClicked:(UIButton *)sender
{

    [active_textfield resignFirstResponder];
    if (totalOrderCost >= 15.0 )
    {
    if (!([selectedOrders count] > 0))
    {
        {
            [RSTAlertView showAlertMessage:NSLocalizedString(kNoItemError, nil) withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
                if (buttonIndex == 0) {}
            }];
        }
        return;
    }
    
    if (isLogin)
    {
        NSCharacterSet * charSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        if ([[directionField.text stringByTrimmingCharactersInSet:charSet] length] == 0)
        {
            directionField.layer.cornerRadius = 6.0f;
            directionField.layer.masksToBounds = YES;
            directionField.layer.borderColor = kRedBorderColor;
            directionField.layer.borderWidth = 2.5f;
            
            scrollView.contentOffset = CGPointMake(0, 0);
        }
        else if ([[stateTextField.text stringByTrimmingCharactersInSet:charSet] length] == 0)
        {
            stateTextField.layer.cornerRadius = 6.0f;
            stateTextField.layer.masksToBounds = YES;
            stateTextField.layer.borderColor = kRedBorderColor;
            stateTextField.layer.borderWidth = 2.5f;
            
            scrollView.contentOffset = CGPointMake(0, directionField.frame.origin.y);
        }
        else if ([[cityTextField.text stringByTrimmingCharactersInSet:charSet] length] == 0)
        {
            cityTextField.layer.cornerRadius = 6.0f;
            cityTextField.layer.masksToBounds = YES;
            cityTextField.layer.borderColor = kRedBorderColor;
            cityTextField.layer.borderWidth = 2.5f;
            
            scrollView.contentOffset = CGPointMake(0, directionField.frame.origin.y);
        }
        else if ([[postalTextField.text stringByTrimmingCharactersInSet:charSet] length] == 0)
        {
            postalTextField.layer.cornerRadius = 6.0f;
            postalTextField.layer.masksToBounds = YES;
            postalTextField.layer.borderColor = kRedBorderColor;
            postalTextField.layer.borderWidth = 2.5f;
            
            scrollView.contentOffset = CGPointMake(0, directionField.frame.origin.y);
        }
        else if (([[pickOrderDateLbl.text stringByTrimmingCharactersInSet:charSet] length] == 0) || ([[pickOrderTimeLbl.text stringByTrimmingCharactersInSet:charSet] length] == 0))
        {
            collectionPickerContainerView.layer.cornerRadius = 6.0f;
            collectionPickerContainerView.layer.masksToBounds = YES;
            collectionPickerContainerView.layer.borderColor = kRedBorderColor;
            collectionPickerContainerView.layer.borderWidth = 2.5f;
            
            scrollView.contentOffset = CGPointMake(0, postalTextField.frame.origin.y);
        }
        else if (([[dropOrderDateLbl.text stringByTrimmingCharactersInSet:charSet] length] == 0) || ([[dropOrderTimeLbl.text stringByTrimmingCharactersInSet:charSet] length] == 0))
        {
            deliveryPickerContainerView.layer.cornerRadius = 6.0f;
            deliveryPickerContainerView.layer.masksToBounds = YES;
            deliveryPickerContainerView.layer.borderColor = kRedBorderColor;
            deliveryPickerContainerView.layer.borderWidth = 2.5f;
            
            scrollView.contentOffset = CGPointMake(0, postalTextField.frame.origin.y);
        }
        else
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
            
            NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", kBaseURL]];
            NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
            [dictionary setObject:@"PLACE_ORDER_SERVICE" forKey:@"request_type_sent"];
            
            if (couponID == nil)
            {
                couponID = @"";
            }
            [dictionary setValue:couponID forKey:@"coupon_id"];
            [dictionary setValue:[notesField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"special_instructions"];
            
            NSMutableDictionary * dict1 = (NSMutableDictionary *)[Utility objectForKey:@"pickOrderDateLblText"];
            [dictionary setValue:[dict1 objectForKey:@"ServerDate"] forKey:@"pickup_date"];
            [dictionary setValue:[pickOrderTimeLbl.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"pickup_time"];
            
            NSMutableDictionary * dict2 = (NSMutableDictionary *)[Utility objectForKey:@"dropOrderDateLblText"];
            [dictionary setValue:[dict2 objectForKey:@"ServerDate"] forKey:@"expected_delivery_date"];
            [dictionary setValue:[dropOrderTimeLbl.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"expected_delivery_time"];
            [dictionary setValue:[detailedAddressField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"complement"];
            [dictionary setValue:[directionField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"pickup_address"];
            [dictionary setValue:kAppDelegate.selectedCityId forKey:@"pickup_city_id"];
            [dictionary setValue:kAppDelegate.selectedStateId forKey:@"pickup_state_id"];
            [dictionary setValue:[postalTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"pickup_pincode"];
            
            NSMutableArray * orderItems = [self getArrayofSelectedItemsForOrder];
            [dictionary setObject:orderItems forKey:@"products"];
            
            [dictionary setObject:[Utility objectForKey:kUserId] forKey:@"consumer_id"];
            [dictionary setObject:[NSString stringWithFormat:@"%.02f",totalOrderCost] forKey:@"total_price"];
            [dictionary setObject:[Utility objectForKey:kUserName] forKey:@"consumer_name"];
            
            [dictionary setObject:@"2" forKey:@"enviornment"];
            [dictionary setObject:deviceToken forKey:@"device_id"];
            
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
                 
                 if([[response objectForKey:@"error_code"] isEqualToString:@"400"])
                 {
                     [RSTAlertView showAlertMessage:[response objectForKey:@"error_desc"] withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
                         if (buttonIndex == 0) {}
                     }];
                 }
                 else if ([[response objectForKey:@"payment_status"] isEqualToString:@"0"])
                 {
                     NSLog(@"Your Order is placed successfully.");
                     
                     orderId = [response objectForKey:@"id"];
                     totalAmount = [response objectForKey:@"total_price"];
                     [Utility setObject:orderId forKey:kOrderId];
                     [Utility setObject:totalAmount forKey:kTotalAmount];
                     
                     [self checkSavedCards];
                 }
                 
                 else if ([[response objectForKey:@"payment_status"] isEqualToString:@"1"]) {
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"CartItemsRemoved" object:nil];
                     
                     orderId = [response objectForKey:@"id"];
                     [Utility setObject:orderId forKey:kOrderId];
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
                     
                     [Utility setObject:nil forKey:kOrderId];

                 }
                 [[AppDelegate sharedInstance] loadingEnd];
             }];
        }
    }
    else
    {
        opaqueView.hidden = NO;
        loginAlertView.hidden = NO;
    }
    }
    else
    {
        [RSTAlertView showAlertMessage:@"El pedido mínimo es de 15€" withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
            if (buttonIndex == 0) {}
        }];
    }
 
}

- (IBAction)enterCoupenCodeBtnClicked:(UIButton *)sender
{
    
    if (totalOrderCost >= 15.0)
    {
    coupenCodeField.layer.borderColor = kGreyBorderColor;
    coupenCodeField.text = nil;
    
    discountCartView.hidden = YES;
    enterCoupenCodeBtn.hidden = YES;
    errorInCoupenCodeView.hidden = YES;
    coupenCodeView.hidden = NO;
    
    totalCartViewYConstraint.constant = 13.0;
    coupenCodeViewYConstraint.constant = 78.0;
    sendRequestBtnYConstraint.constant = 216.0;
    
    sendRequestBtn.alpha = 0.5;
    sendRequestBtn.userInteractionEnabled = NO;
    
    [sendRequestBtn layoutIfNeeded];
    float viewHeight = sendRequestBtn.frame.origin.y + sendRequestBtn.frame.size.height + 24;
    mainViewHeightConstraint.constant = viewHeight;
    mainScrollViewHeightConstraint.constant = viewHeight;
    
    scrollView.contentOffset = CGPointMake(0, scrollView.contentSize.height);
    }
    else
    {
        [RSTAlertView showAlertMessage:@"El pedido mínimo es de 15€" withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
            if (buttonIndex == 0) {}
        }];

    }
}

- (IBAction)menuButtonClicked:(UIButton *)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
    }];
}

- (IBAction)cartButtonClicked:(UIButton *)sender
{
    
}

- (NSMutableArray *)getArrayofSelectedItemsForOrder
{
    NSMutableArray * orderArr = [[NSMutableArray alloc] init];
    
    for (ClothDetails * clothObj in selectedOrders)
    {
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
        [dict setObject:clothObj.clothID forKey:@"id"];
        [dict setObject:clothObj.numberofItems forKey:@"quantity"];
        [orderArr addObject:dict];
    }
    return orderArr;
}

- (void)userDidCancelPayment
{
    [super viewWillAppear:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        CGPoint bottomOffset = CGPointMake(0, scrollView.contentSize.height - scrollView.bounds.size.height);
        [scrollView setContentOffset:bottomOffset animated:YES];
    });
    
    [self deleteMyOrdersFromServer];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)deleteMyOrdersFromServer
{
    NSString * deviceToken = [Utility objectForKey:@"DeviceToken"];
    if (deviceToken == nil)
    {
        deviceToken = @"0123456789";
    }
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", kBaseURL]];
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:@"CANCEL_ORDER_SERVICE" forKey:@"request_type_sent"];
    [dictionary setObject:orderId forKey:@"order_id"];
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
             NSLog(@"Failed To Delete Order from server.");
         }
         else
         {
             NSLog(@"Successfully Deleted Order from server.");
         }
         orderId = nil;
     }];
}


- (void)showSuccessViewForCouponCode
{
    discountCartView.hidden = NO;
    enterCoupenCodeBtn.hidden = YES;
    coupenCodeView.hidden = YES;
    errorInCoupenCodeView.hidden = YES;
    
    discountCartViewYConstraint.constant = 13.0;
    totalCartViewYConstraint.constant = 73.0;
    sendRequestBtnYConstraint.constant = 138.0;
    
    sendRequestBtn.alpha = 1.0;
    sendRequestBtn.userInteractionEnabled = YES;
    
    totalDiscountLbl.text = [NSString stringWithFormat:@"- %.02f€",[[Utility objectForKey:@"totalDiscount"] floatValue]];
    couponNameLbl.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"Discount:", nil), [Utility objectForKey:@"DiscountCoupenName"]];
    
    [sendRequestBtn layoutIfNeeded];
    float viewHeight = sendRequestBtn.frame.origin.y + sendRequestBtn.frame.size.height + 24;
    mainViewHeightConstraint.constant = viewHeight;
    mainScrollViewHeightConstraint.constant = viewHeight;
    
    scrollView.contentOffset = CGPointMake(0, scrollView.contentSize.height);
}

- (void)showErrorViewForCouponCode
{
    discountCartView.hidden = YES;
    enterCoupenCodeBtn.hidden = YES;
    errorInCoupenCodeView.hidden = NO;
    coupenCodeView.hidden = NO;
    
    totalCartViewYConstraint.constant = 13.0;
    errorInCoupenCodeViewYConstraint.constant = 78.0;
    coupenCodeViewYConstraint.constant = 154.0;
    sendRequestBtnYConstraint.constant = 292.0;
    
    sendRequestBtn.alpha = 0.5;
    sendRequestBtn.userInteractionEnabled = NO;
    
    coupenCodeField.layer.borderColor = kRedBorderColor;
    
    [sendRequestBtn layoutIfNeeded];
    float viewHeight = sendRequestBtn.frame.origin.y + sendRequestBtn.frame.size.height + 24;
    mainViewHeightConstraint.constant = viewHeight;
    mainScrollViewHeightConstraint.constant = viewHeight;
    if (!isErrorViewShowing)
    {
        scrollView.contentOffset = CGPointMake(0, scrollView.contentSize.height);
    }
    isErrorViewShowing = YES;
}

- (IBAction)stateButtonTapped:(UIButton *)sender
{
    stateTextField.layer.cornerRadius = 6.0f;
    stateTextField.layer.masksToBounds = YES;
    stateTextField.layer.borderColor = kGreyBorderColor;
    stateTextField.layer.borderWidth = 2.5f;
    
    [active_textfield resignFirstResponder];
    
    //the view controller you want to present as popover
    stateController = [self.storyboard instantiateViewControllerWithIdentifier:@"StatePopOverViewController"];
    stateController.statesDict = stateServiceResponse;
    stateController.delegate = self;
    
    popoverController = [[FPPopoverController alloc] initWithViewController:stateController];
    popoverController.border = NO;
    popoverController.tint = FPPopoverWhiteTint;
    [popoverController presentPopoverFromView:sender];
}

- (IBAction)cityButtonTapped:(UIButton *)sender
{
    cityTextField.layer.cornerRadius = 6.0f;
    cityTextField.layer.masksToBounds = YES;
    cityTextField.layer.borderColor = kGreyBorderColor;
    cityTextField.layer.borderWidth = 2.5f;
    
    [active_textfield resignFirstResponder];
    if (isStateSelected)
    {
        //the view controller you want to present as popover
        cityController = [self.storyboard instantiateViewControllerWithIdentifier:@"CityPopOverViewController"];
        cityController.statesDict = stateServiceResponse;
        cityController.delegate = self;
        
        popoverController = [[FPPopoverController alloc] initWithViewController:cityController];
        popoverController.border = NO;
        popoverController.tint = FPPopoverWhiteTint;
        [popoverController presentPopoverFromView:sender];
    }
    else
    {
        {
            [RSTAlertView showAlertMessage:NSLocalizedString(@"Please select a state first.", nil) withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
                if (buttonIndex == 0) {}
            }];
        }
    }
}

#pragma mark - StatePopOverViewController Delegate Methods

-(void)setState:(NSString *)stateName withSelectedID:(NSString *)stateID
{
    stateTextField.text = stateName;
    kAppDelegate.selectedStateId = stateID;
    
    [popoverController dismissPopoverAnimated:YES];
    [active_textfield resignFirstResponder];
    
    cityTextField.text = @"";
    isStateSelected = YES;
    if (isLogin)
    {
        [Utility setObject:stateTextField.text forKey:@"stateTextFieldText"];
        [Utility setObject:stateID forKey:@"stateTextFieldID"];
    }
}

#pragma mark - CityPopOverViewController Delegate Methods

-(void)setCity:(NSString *)cityName withSelectedID:(NSString *)cityID
{
    cityTextField.text = cityName;
    kAppDelegate.selectedCityId = cityID;
    
    [popoverController dismissPopoverAnimated:YES];
    [active_textfield resignFirstResponder];
    
    if (isLogin)
    {
        [Utility setObject:cityTextField.text forKey:@"cityTextFieldText"];
        [Utility setObject:cityID forKey:@"cityTextFieldID"];
    }
}

#pragma mark - LocationPopOverViewController Delegate Methods

-(void)selectedLocation:(NSString *)locationName
{
    directionField.text = locationName;
    if (isLogin)
    {
        [Utility setObject:directionField.text forKey:@"directionFieldText"];
    }
    [active_textfield resignFirstResponder];
    
    [self dismisLocationPopover:locationName];
}

#pragma mark - TimeSlot PopOverViewController Delegate Methods

-(void)selectedTimeSlot:(NSString *)timeSlot withSelectedTag:(NSInteger)tag andIndex:(NSInteger)indexSelected
{
    if (tag == 1093)
    {
        dropOrderTimeLbl.text = @"";
        dropOrderDateLbl.text = @"";
        pickOrderTimeLbl.text = timeSlot;
        if (isLogin)
            [Utility setObject:pickOrderTimeLbl.text forKey:@"pickOrderTimeLblText"];
    }
    else // 1094
    {
        dropOrderTimeLbl.text = timeSlot;
        if (isLogin)
            [Utility setObject:dropOrderTimeLbl.text forKey:@"dropOrderTimeLblText"];
    }
}

#pragma mark - Date PopOverViewController Delegate Methods

-(void)selectedDate:(NSMutableDictionary *)dateDictionary withSelectedTag:(NSInteger)tag andIndex:(NSInteger)indexSelected
{    
    dropOrderTimeLbl.text = @"";
    
    if (tag == 1091)
    {
        pickOrderTimeLbl.text = @"";
        dropOrderDateLbl.text = @"";
        
        selectedDateIndex = indexSelected;
        pickOrderDateLbl.text = [dateDictionary objectForKey:@"DeviceDate"];
        if (isLogin)
            [Utility setObject:dateDictionary forKey:@"pickOrderDateLblText"];
    }
    else // 1092
    {
        selectedTimeIndex = indexSelected;
        dropOrderDateLbl.text = [dateDictionary objectForKey:@"DeviceDate"];
        if (isLogin)
            [Utility setObject:dateDictionary forKey:@"dropOrderDateLblText"];
    }
}

- (IBAction)hideLoginAlertView:(UITapGestureRecognizer *)sender {
    opaqueView.hidden = YES;
    loginAlertView.hidden = YES;
}

@end
