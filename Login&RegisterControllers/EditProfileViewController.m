//
//  EditProfileViewController.m
//  LavanApp
//
//  Created by IPHONE-10 on 6/9/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

#import "EditProfileViewController.h"

@interface EditProfileViewController ()
{
    AppDelegate * appDelegate;
    UITextField * active_textfield;
}

@property (weak, nonatomic) IBOutlet UILabel * cartCountLabel;

@end

@implementation EditProfileViewController

#pragma mark - view life cycle methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImage *image = [UIImage imageNamed:@"LogoImage"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:image];
//    self.navigationItem.title = @"Lavanapp";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:23]};
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //check if loggedin via facebook
    if ([[Utility objectForKey:kLoginType] isEqual: @"2"])
    {
        [nameTextField setEnabled:NO];
        [passwordTextField setEnabled:NO];
        [mobileNoTextField setEnabled:NO];
        [showButton setEnabled:NO];
    }
    [emailTextField setEnabled:NO];
    [mobileNoTextField setEnabled:NO];
    
    nameTextField.leftViewMode = UITextFieldViewModeAlways;
    emailTextField.leftViewMode = UITextFieldViewModeAlways;
    passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    mobileNoTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView * leftView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 21)];
    leftView1.contentMode = UIViewContentModeScaleAspectFit;
    leftView1.backgroundColor = [UIColor clearColor];
    leftView1.image = [UIImage imageNamed:@"NameFieldImg.png"];
    nameTextField.leftView = leftView1;
    UIImageView * leftView2 = [[UIImageView alloc] initWithFrame:leftView1.frame];
    leftView2.contentMode = UIViewContentModeScaleAspectFit;
    leftView2.backgroundColor = [UIColor clearColor];
    leftView2.image = [UIImage imageNamed:@"MailFieldImg.png"];
    emailTextField.leftView = leftView2;
    UIImageView * leftView3 = [[UIImageView alloc] initWithFrame:leftView1.frame];
    leftView3.contentMode = UIViewContentModeScaleAspectFit;
    leftView3.backgroundColor = [UIColor clearColor];
    leftView3.image = [UIImage imageNamed:@"PasswordFieldImg.png"];
    passwordTextField.leftView = leftView3;
    UIImageView * leftView4 = [[UIImageView alloc] initWithFrame:leftView1.frame];
    leftView4.contentMode = UIViewContentModeScaleAspectFit;
    leftView4.backgroundColor = [UIColor clearColor];
    leftView4.image = [UIImage imageNamed:@"NumberFieldImg.png"];
    mobileNoTextField.leftView = leftView4;
    
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
    saveButton.layer.masksToBounds = YES;
    saveButton.layer.cornerRadius = 5.0;

    [self populateAccount];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.cartCountLabel.layer.cornerRadius = 10;
    self.cartCountLabel.layer.masksToBounds = YES;

    appDelegate = [AppDelegate sharedInstance];
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
        [self.cartCountLabel setHidden:YES];
    }
}

#pragma mark - memory management methods

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextField Delegates

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    active_textfield = textField;
    
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [scrollView scrollToActiveTextField];

    if (textField == mobileNoTextField)
    {
        NSString * finalString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if ([finalString length] > 15)
            return NO;
        else
            return YES;
    }
    else
    {
        NSString * finalString = [textField.text stringByReplacingCharactersInRange:range withString:string];
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

#pragma mark - IBAction Methods

- (IBAction)checkboxButtonClicked:(UIButton *)sender
{
    [active_textfield resignFirstResponder];
    
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

- (IBAction)cancelButtonClicked:(UIButton *)sender
{
    [active_textfield resignFirstResponder];

    {
        [RSTAlertView showAlertMessage:NSLocalizedString(kCancelChangesAlert, nil) withButtons:eYesNo completionHandler:^(NSInteger buttonIndex) {
            if (buttonIndex == 1)
            {
                [self populateAccount];
            }
        }];
    }
}

- (IBAction)saveButtonClicked:(UIButton *)sender
{
    [active_textfield resignFirstResponder];

    if ([[Utility objectForKey:kLoginType] isEqual: @"2"])
    {
        [self sendSaveRequestToServer];
    }
    else
    {
        NSCharacterSet * charSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];

        if ([[nameTextField.text stringByTrimmingCharactersInSet:charSet] length] == 0)
        {
            [RSTAlertView showAlertMessage:NSLocalizedString(@"Please enter your name.", nil) withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
                if (buttonIndex == 0) {}
            }];
            nameTextField.layer.cornerRadius = 6.0f;
            nameTextField.layer.masksToBounds = YES;
            nameTextField.layer.borderColor = kRedBorderColor;
            nameTextField.layer.borderWidth = 2.5f;
        }
        else if (([[passwordTextField.text stringByTrimmingCharactersInSet:charSet] length] == 0) || ([[passwordTextField.text stringByTrimmingCharactersInSet:charSet] length] < 8))
        {
            [RSTAlertView showAlertMessage:NSLocalizedString(@"Please enter password with minimum length 8.", nil) withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
                if (buttonIndex == 0) {}
            }];
            passwordTextField.layer.cornerRadius = 6.0f;
            passwordTextField.layer.masksToBounds = YES;
            passwordTextField.layer.borderColor = kRedBorderColor;
            passwordTextField.layer.borderWidth = 2.5f;
        }
        else if ([[mobileNoTextField.text stringByTrimmingCharactersInSet:charSet] length] == 0)
        {
            [RSTAlertView showAlertMessage:NSLocalizedString(@"Please enter valid phone no, It should be 8 to 15 digits.", nil) withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
                if (buttonIndex == 0) {}
            }];
            mobileNoTextField.layer.cornerRadius = 6.0f;
            mobileNoTextField.layer.masksToBounds = YES;
            mobileNoTextField.layer.borderColor = kRedBorderColor;
            mobileNoTextField.layer.borderWidth = 2.5f;
        }
        else
        {
            [self sendSaveRequestToServer];
        }
    }
}

- (void)sendSaveRequestToServer
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
    [dictionary setObject:@"EDIT_CONSUMER_SERVICE" forKey:@"request_type_sent"];
    [dictionary setValue:[nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"name"];
    [dictionary setValue:[emailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"email"];
    [dictionary setValue:[passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"password"];
    [dictionary setValue:[mobileNoTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"phone_no"];
    
    if ([[Utility objectForKey:kLoginType] isEqualToString:@"2"]) {
        [dictionary setObject:@"1" forKey:@"login_via_facebook"];
        [dictionary setValue:@"dummyPassword" forKey:@"password"];
    }
    else
        [dictionary setObject:@"0" forKey:@"login_via_facebook"];
    
    [dictionary setObject:@"2" forKey:@"device_type"];
    [dictionary setObject:deviceToken forKey:@"device_id"];
    if (checkboxButton.selected)
    {
        [dictionary setObject:@"1" forKey:@"want_news"];
    }
    else
    {
        [dictionary setObject:@"0" forKey:@"want_news"];
    }
    [dictionary setObject:[Utility objectForKey:kUserId] forKey:@"consumer_id"];
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
         
         if([[response objectForKey:@"update_status"] isEqualToString:@"1"])
         {
             [RSTAlertView showAlertMessage:NSLocalizedString(@"Your account updated successfully.", nil) withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
                 if (buttonIndex == 0) {}
             }];
             
             [Utility setObject:nameTextField.text forKey:kUserName];
             [Utility setObject:emailTextField.text forKey:kUserEmail];
             [Utility setObject:passwordTextField.text forKey:kUserPassword];
             [Utility setObject:mobileNoTextField.text forKey:kUserMobileNo];
             
             [[NSNotificationCenter defaultCenter] postNotificationName:@"setUsername" object:nil];
             
             if (checkboxButton.selected)
             {
                 [Utility setObject:@"1" forKey:@"Want_News"];
             }
             else
             {
                 [Utility setObject:@"0" forKey:@"Want_News"];
             }
             
             NSArray *viewControllers = kAppDelegate.navController.viewControllers;
             for (UIViewController *controller in viewControllers) {
                 if ([controller isKindOfClass:[CenterViewController class]]) {
                     [kAppDelegate.navController popToViewController:controller animated:YES];
                 }
             }
         }
         else
         {
             [RSTAlertView showAlertMessage:[response objectForKey:@"error_desc"] withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
                 if (buttonIndex == 0) {}
             }];
         }
         [[AppDelegate sharedInstance] loadingEnd];
     }];
}

- (IBAction)deleteAccountButtonClicked:(UIButton *)sender
{
    [active_textfield resignFirstResponder];

    [RSTAlertView showAlertMessage:NSLocalizedString(kDeleteAccountAlert, nil) withButtons:eYesNo completionHandler:^(NSInteger buttonIndex) {
        if (buttonIndex == 1)
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
            [dictionary setObject:@"DELETE_CONSUMER_SERVICE" forKey:@"request_type_sent"];
            [dictionary setObject:@"2" forKey:@"device_type"];
            [dictionary setObject:deviceToken forKey:@"device_id"];
            [dictionary setObject:[Utility objectForKey:kUserId] forKey:@"consumer_id"];
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

                 NSLog(@"response : %@",response);
                 
                 if([[response objectForKey:@"delete_status"] isEqualToString:@"1"])
                 {
                     [RSTAlertView showAlertMessage:NSLocalizedString(@"Your account deleted successfully.", nil) withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
                         if (buttonIndex == 0) {}
                     }];

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
                     
                     ChildPageViewController * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ChildPageViewController"];
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
                     kAppDelegate.window.rootViewController = kAppDelegate.container;
                     [kAppDelegate.window makeKeyAndVisible];
                 }
                 else
                 {
                     [RSTAlertView showAlertMessage:[response objectForKey:@"error_desc"] withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
                         if (buttonIndex == 0) {}
                     }];
                 }
                 [[AppDelegate sharedInstance] loadingEnd];
             }];
        }
    }];
}

- (IBAction)showPasswordButtonClicked:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected)
    {
        passwordTextField.secureTextEntry = NO;
        [sender setTitle:NSLocalizedString(@"HIDE", nil) forState:UIControlStateNormal];
    }
    else
    {
        passwordTextField.secureTextEntry = YES;
        [sender setTitle:NSLocalizedString(@"SHOW", nil) forState:UIControlStateNormal];
    }
}

- (IBAction)menuButtonClicked:(UIButton *)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
    }];
}

- (IBAction)cartButtonClicked:(UIButton *)sender
{
    if ([appDelegate.cartItemsArray count] > 0)
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


#pragma mark - class methods

-(void)populateAccount
{
    nameTextField.text = [Utility objectForKey:kUserName];
    emailTextField.text = [Utility objectForKey:kUserEmail];
    passwordTextField.text = [Utility objectForKey:kUserPassword];
    mobileNoTextField.text = [Utility objectForKey:kUserMobileNo];
    
    NSString * news_state = [Utility objectForKey:kWantNews];
    if ([news_state isEqualToString:@"1"])
    {
        [checkboxButton setImage:[UIImage imageNamed:@"CheckboxImage.png"] forState:UIControlStateNormal];
        checkboxButton.selected = YES;
    }
    else
    {
        [checkboxButton setImage:[UIImage imageNamed:@"UncheckboxImage.png"] forState:UIControlStateNormal];
        checkboxButton.selected = NO;
    }
}

@end
