//
//  RegisterViewController.m
//  LavanApp
//
//  Created by IPHONE-10 on 5/26/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()
{
    AppDelegate * appDelegate;
    UITextField * active_textfield;
    NSString * accessToken;
    NSString * appID;
    NSString * userID;
    BOOL isFbSignUp;
    BOOL isAlertShownForFirstTime;
    NSTimer *resendTimer;
    UIView *opaqueView;
}
@property (weak, nonatomic) IBOutlet UILabel * cartCountLabel;

@end

@implementation RegisterViewController

#pragma mark - view life cycle methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    nameField.leftViewMode = UITextFieldViewModeAlways;
    mailField.leftViewMode = UITextFieldViewModeAlways;
    confirmMailField.leftViewMode = UITextFieldViewModeAlways;
    passwordField.leftViewMode = UITextFieldViewModeAlways;
    confirmPassword.leftViewMode = UITextFieldViewModeAlways;
    mobileNumberField.leftViewMode = UITextFieldViewModeAlways;
    OTPTextField.leftViewMode = UITextFieldViewModeAlways;
    postalCodeTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView * leftView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 21)];
    leftView1.contentMode = UIViewContentModeScaleAspectFit;
    leftView1.backgroundColor = [UIColor clearColor];
    leftView1.image = [UIImage imageNamed:@"NameFieldImg.png"];
    nameField.leftView = leftView1;
    UIImageView * leftView2 = [[UIImageView alloc] initWithFrame:leftView1.frame];
    leftView2.contentMode = UIViewContentModeScaleAspectFit;
    leftView2.backgroundColor = [UIColor clearColor];
    leftView2.image = [UIImage imageNamed:@"MailFieldImg.png"];
    mailField.leftView = leftView2;
    UIImageView * leftView3 = [[UIImageView alloc] initWithFrame:leftView1.frame];
    leftView3.contentMode = UIViewContentModeScaleAspectFit;
    leftView3.backgroundColor = [UIColor clearColor];
    leftView3.image = [UIImage imageNamed:@"MailFieldImg.png"];
    confirmMailField.leftView = leftView3;
    UIImageView * leftView4 = [[UIImageView alloc] initWithFrame:leftView1.frame];
    leftView4.contentMode = UIViewContentModeScaleAspectFit;
    leftView4.backgroundColor = [UIColor clearColor];
    leftView4.image = [UIImage imageNamed:@"PasswordFieldImg.png"];
    passwordField.leftView = leftView4;
    UIImageView * leftView5 = [[UIImageView alloc] initWithFrame:leftView1.frame];
    leftView5.contentMode = UIViewContentModeScaleAspectFit;
    leftView5.backgroundColor = [UIColor clearColor];
    leftView5.image = [UIImage imageNamed:@"PasswordFieldImg.png"];
    confirmPassword.leftView = leftView5;
    UIImageView * leftView6 = [[UIImageView alloc] initWithFrame:leftView1.frame];
    leftView6.contentMode = UIViewContentModeScaleAspectFit;
    leftView6.backgroundColor = [UIColor clearColor];
    leftView6.image = [UIImage imageNamed:@"NumberFieldImg.png"];
    mobileNumberField.leftView = leftView6;
    UIImageView * leftView7 = [[UIImageView alloc] initWithFrame:leftView1.frame];
    leftView7.contentMode = UIViewContentModeScaleAspectFit;
    leftView7.backgroundColor = [UIColor clearColor];
    leftView7.image = [UIImage imageNamed:@"PasswordFieldImg.png"];
    OTPTextField.leftView = leftView7;
    UIImageView * leftView8 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 21)];
    leftView8.contentMode = UIViewContentModeScaleAspectFit;
    leftView8.backgroundColor = [UIColor clearColor];
    leftView8.image = [UIImage imageNamed:@"PostalFieldImg"];
    postalCodeTextField.leftView = leftView8;

    postalCodeTextField.placeholder = NSLocalizedString(@"Enter Postal Code", nil);
    [self showErrorViewWithHeight:0.0f];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LogoImage.png"]];
    
    registerButton.layer.masksToBounds = YES;
    registerButton.layer.cornerRadius = 5.0;
    [fbSignUpBtn setTitle:NSLocalizedString(@"SIGNUP WITH FACEBOOK", nil) forState:UIControlStateNormal];
    
    resendButton.layer.masksToBounds = YES;
    resendButton.layer.cornerRadius = 5.0;

    okButton.layer.masksToBounds = YES;
    okButton.layer.cornerRadius = 5.0;
    
    fbSignUpBtn.layer.masksToBounds = YES;
    fbSignUpBtn.layer.cornerRadius = 5.0;
    
    otpEmailBtn.layer.masksToBounds = YES;
    otpEmailBtn.layer.cornerRadius = 5.0;

    pleaseConfirmLabel.text = NSLocalizedString(@"Please confirm OTP, sent to your registered mobile number", nil);
    [okButton setTitle:NSLocalizedString(@"VERIFY", nil) forState:UIControlStateNormal];
    [otpEmailBtn setTitle:NSLocalizedString(@"Send OTP Via Email", nil) forState:UIControlStateNormal];
    
    NSMutableAttributedString * termsString = [[NSMutableAttributedString alloc] initWithString:@"Acepto los Términos y condiciones y la Política de privacidad" attributes:nil];
    [termsString addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange (11, 22)];
    [termsString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange (11, 22)];
    termsLabel.attributedText = termsString;
    
    if (opaqueView) {
        [opaqueView removeFromSuperview];
    }

    opaqueView = [[UIView alloc] initWithFrame:kAppDelegate.window.bounds];
    opaqueView.backgroundColor = [UIColor blackColor];
    opaqueView.alpha = 0.6;
    
    OTPView.translatesAutoresizingMaskIntoConstraints = YES;
    OTPView.frame = CGRectMake((kAppDelegate.window.bounds.size.width / 2) - (OTPView.frame.size.width / 2), (self.view.frame.size.height / 2) - (OTPView.frame.size.height / 2), OTPView.frame.size.width, OTPView.frame.size.height);

    if (OTPView) {
        [OTPView removeFromSuperview];
    }

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self markAllTextFieldGrayCorner];
    self.navigationController.navigationBarHidden = NO;

    self.navigationItem.hidesBackButton = YES;
    
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

-(void)viewWillDisappear:(BOOL)animated {
    [resendTimer invalidate];
    resendTimer = nil;

}

-(void)dealloc {
    [resendTimer invalidate];
    resendTimer = nil;
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

    if (textField == mobileNumberField)
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

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (!(textField == OTPTextField)) {
        textField.layer.cornerRadius = 6.0f;
        textField.layer.masksToBounds = YES;
        textField.layer.borderColor = kBlueBorderColor;
        textField.layer.borderWidth = 2.5f;

    }
   }

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (!(textField == OTPTextField)) {
        textField.layer.cornerRadius = 6.0f;
        textField.layer.masksToBounds = YES;
        textField.layer.borderColor = kGreyBorderColor;
        textField.layer.borderWidth = 2.5f;
        [textField layoutIfNeeded];

    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (void)showErrorViewWithHeight:(float)height
{
    errorHeightConstraint.constant = height; //92 origional height
    if (height > 0)
    {
        errorView.hidden = NO;
    }
    else
    {
        errorView.hidden = YES;
    }
    
    [registerButton layoutIfNeeded];
    float viewHeight = registerButton.frame.origin.y + registerButton.frame.size.height + 15;
    mainViewHeightConstraint.constant = viewHeight;
    mainScrollViewHeightConstraint.constant = viewHeight;
}

- (void)markTextFieldRedCorner:(UITextField *)textField
{
    textField.layer.cornerRadius = 6.0f;
    textField.layer.masksToBounds = YES;
    textField.layer.borderColor = kRedBorderColor;
    textField.layer.borderWidth = 2.5f;
    
    scrollView.contentOffset = CGPointMake(0, 0);
}

- (void)markAllTextFieldGrayCorner
{
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
    
    OTPTextField.layer.cornerRadius = 6.0f;
    OTPTextField.layer.masksToBounds = YES;    
    OTPView.layer.cornerRadius = 6.0f;
    OTPView.layer.masksToBounds = YES;


}

#pragma mark - IBAction Methods

- (IBAction)registrationButtonClicked:(UIButton *)sender
{

    [active_textfield resignFirstResponder];
    [self showErrorViewWithHeight:0.0f];
    [self markAllTextFieldGrayCorner];
    
    
    if (isFbSignUp) {
        [self fbSignUp];
    }
    else
        [self regularSignUp];
}

- (IBAction)termsAndConditionBtnClicked:(UIButton *)sender {
    WebViewController * webController = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
    webController.pushType = @"3";
    [kAppDelegate.navController pushViewController:webController animated:NO];
}

- (IBAction)checkBoxButtonClicked:(UIButton *)sender
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

- (IBAction)resendOTPBtnTapped:(UIButton *)sender {
    //call resend otp service
    OTPTextField.text = @"";
    [[AppDelegate sharedInstance] loadingStart];
    
    NSString * deviceToken = [Utility objectForKey:@"DeviceToken"];
    if (deviceToken == nil)
    {
        deviceToken = @"0123456789";
    }
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", kBaseURL]];
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:@"SEND_OTA_SERVICE" forKey:@"request_type_sent"];
    [dictionary setValue:[mobileNumberField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"phone_no"];
    [dictionary setObject:[Utility objectForKey:kUserId] forKey:kUserId];
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
         
         if([[response objectForKey:@"ota_send_status"] isEqualToString:@"1"])
         {
             resendButton.enabled = NO;
             resendButton.alpha = 0.3;
             otpEmailBtn.enabled = NO;
             otpEmailBtn.alpha = 0.3;

             resendTimer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(reEnableResendBtn) userInfo:nil repeats:NO];


         }
         else
         {
        }
         [[AppDelegate sharedInstance] loadingEnd];
     }];

}

- (IBAction)submitOTPBtnTapped:(UIButton *)sender {
    //call otp submit service
    if (OTPTextField.text.length) {
        [[AppDelegate sharedInstance] loadingStart];
        
        NSString * deviceToken = [Utility objectForKey:@"DeviceToken"];
        if (deviceToken == nil)
        {
            deviceToken = @"0123456789";
        }
        
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", kBaseURL]];
        NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
        [dictionary setObject:@"CHECK_REGISTRATION_OTA_SERVICE" forKey:@"request_type_sent"];
        [dictionary setValue:[OTPTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"ota"];
        [dictionary setObject:[Utility objectForKey:kUserId] forKey:kUserId];
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
             
             if([[response objectForKey:@"verification_status"] isEqualToString:@"1"])
             {
                 [self verifyZipCode];
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
}

- (IBAction)opaqueViewTapped:(UITapGestureRecognizer *)sender {
}

- (IBAction)cancelOTPBtnTapped:(UIButton *)sender {
    [resendTimer invalidate];
    resendTimer = nil;

    if (opaqueView) {
        [opaqueView removeFromSuperview];
    }
    if (OTPView) {
        [OTPView removeFromSuperview];
    }
}

- (IBAction)signUpViaFBClicked:(UIButton *)sender
{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logOut];
    [login logInWithReadPermissions:@[@"public_profile", @"email", @"user_friends",@"user_likes",@"user_photos"] handler:^(FBSDKLoginManagerLoginResult * result, NSError * error)
     {
         NSLog(@"%@", result);
         if (error)
         {
             [kAppDelegate loadingEnd];
             [RSTAlertView showAlertMessage:NSLocalizedString(@"Could not complete your request", nil) withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
                 if (buttonIndex == 0) {}
                 return ;
             }];
         }
         else if (result.isCancelled)
         {
             [kAppDelegate loadingEnd];
             [RSTAlertView showAlertMessage:NSLocalizedString(@"Could not complete the request", nil) withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
                 if (buttonIndex == 0) {}
                 return ;
             }];
         }
         else
         {
             NSLog(@"%@",result.grantedPermissions);
             appID = result.token.appID;
             accessToken = result.token.tokenString;
             userID = result.token.userID;
             
             //Login successful via Facebook, ask for user's profile
             if ([result.grantedPermissions containsObject:@"email"])
             {
                 NSLog(@"Granted all permission");
                 
                 if ([FBSDKAccessToken currentAccessToken])
                 {
                     [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:[NSDictionary dictionaryWithObject:@"id,name,email" forKey:@"fields"]] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
                      {
                          if (!error)
                          {
                              [kAppDelegate loadingEnd];

                              fbSignUpBtn.enabled = NO;
                              fbSignUpBtn.alpha = 0.4;
                              
                              mailField.text = [result objectForKey:@"email"];
                              nameField.text = [result objectForKey:@"name"];
                              confirmMailField.text = [result objectForKey:@"email"];
                              nameField.enabled = NO;
                              nameField.alpha = 0.4;
                              mailField.enabled = NO;
                              mailField.alpha = 0.4;
                              confirmMailField.enabled = NO;
                              confirmMailField.alpha = 0.4;
                              passwordField.enabled = NO;
                              passwordField.alpha = 0.4;
                              passwordTxtFieldHeightConstraint.constant = 0;
                              confirmPassword.enabled = NO;
                              confirmPassword.alpha = 0.4;
                              repeatPasswordTxtFieldHeightConstraint.constant = 0;
                              email_passwordVerticalConstraint.constant = 0;
                              password_confirmPasswordVerticalConstraint.constant = 0;
                              mobileNumberField.text = @"";
                              postalCodeTextField.text = @"";
                              isFbSignUp = YES;
                              [Utility setObject:@"2" forKey:kLoginType];
                          }
                          else {
                              [kAppDelegate loadingEnd];
                          }
                      }];
                 }
                 else
                 {
                     [kAppDelegate loadingEnd];
                     [RSTAlertView showAlertMessage:NSLocalizedString(@"Could not complete your request", nil) withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
                         if (buttonIndex == 0) {}
                         return ;
                 }];
             }
         }
             else {
                 [kAppDelegate loadingEnd];
                 [RSTAlertView showAlertMessage:NSLocalizedString(@"Could not get Email from your account", nil) withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
                     if (buttonIndex == 0) {}
                     return ;
                 }];
             }
        }
     }];
}

- (IBAction)otpViaEmailBtnTapped:(UIButton *)sender {
    //call resend otp service
    OTPTextField.text = @"";

    [[AppDelegate sharedInstance] loadingStart];
    
    NSString * deviceToken = [Utility objectForKey:@"DeviceToken"];
    if (deviceToken == nil)
    {
        deviceToken = @"0123456789";
    }
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", kBaseURL]];
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:@"SEND_OTA_EMAIL_SERVICE" forKey:@"request_type_sent"];
    [dictionary setValue:mailField.text forKey:@"email"];
    [dictionary setObject:[Utility objectForKey:kUserId] forKey:kUserId];
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
         
         if([[response objectForKey:@"ota_send_status"] isEqualToString:@"1"])
         {
             [RSTAlertView showAlertMessage:@"Gracias, te hemos enviado el código de verificación a tu correo electrónico" withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
                 if (buttonIndex == 0) {}
             }];
             resendButton.enabled = NO;
             resendButton.alpha = 0.3;
             otpEmailBtn.enabled = NO;
             otpEmailBtn.alpha = 0.3;
             
             resendTimer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(reEnableResendBtn) userInfo:nil repeats:NO];
             
         }
         else
         {
         }
         [[AppDelegate sharedInstance] loadingEnd];
     }];
}

- (IBAction)termsCheckBoxBtnTapped:(UIButton *)sender {
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

#pragma mark - Class Methods

-(void)signUpUserSuccessfully {
    [resendTimer invalidate];
    resendTimer = nil;
            [Utility setObject:nameField.text forKey:kUserName];
            [Utility setObject:mailField.text forKey:kUserEmail];
            [Utility setObject:passwordField.text forKey:kUserPassword];
            [Utility setObject:mobileNumberField.text forKey:kUserMobileNo];
            if (checkboxButton.selected)
            {
                [Utility setObject:@"1" forKey:kWantNews];
            }
            else
            {
                [Utility setObject:@"0" forKey:kWantNews];
            }
    
            [Utility setBool:YES forKey:kIsLogin];
            [Utility setObject:@"1" forKey:kLoginType];
    
            FirstSideMenuController * sideMenuController = [self.storyboard instantiateViewControllerWithIdentifier:@"FirstSideMenuController"];
    
            NSArray * navigationViewControllers = kAppDelegate.navController.viewControllers;
            BOOL isCenterAvailable = NO;
            for (UIViewController * controller in navigationViewControllers)
            {
                if ([controller isKindOfClass:[CenterViewController class]])
                {
                    kAppDelegate.navController = (UINavigationController *)[self.storyboard instantiateViewControllerWithIdentifier:@"NavigationController"];
                    (void)[kAppDelegate.navController initWithRootViewController:controller];
                    isCenterAvailable = YES;
                }
            }
            if (!isCenterAvailable)
            {
                CenterViewController * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"CenterViewController"];
                kAppDelegate.navController = (UINavigationController *)[self.storyboard instantiateViewControllerWithIdentifier:@"NavigationController"];
                (void)[kAppDelegate.navController initWithRootViewController:controller];
            }
    
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
    
    NSArray *subViewArray = [kAppDelegate.window subviews];
    for (id obj in subViewArray)
    {
        [obj removeFromSuperview];
    }

            kAppDelegate.window.rootViewController = kAppDelegate.container;
            [kAppDelegate.window makeKeyAndVisible];
}

-(void)reEnableResendBtn {
    if (!isAlertShownForFirstTime) {
        [RSTAlertView showAlertMessage:NSLocalizedString(kOTPEmailDialogue, nil) withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
            if (buttonIndex == 0) {}
        }];
        isAlertShownForFirstTime = YES;
    }
   
    resendButton.enabled = YES;
    resendButton.alpha = 1;
    otpEmailBtn.enabled = YES;
    otpEmailBtn.alpha = 1;
}

-(void)verifyZipCode {
    if ([[postalCodeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0)
    {
        postalCodeTextField.layer.cornerRadius = 6.0f;
        postalCodeTextField.layer.masksToBounds = YES;
        postalCodeTextField.layer.borderColor = kRedBorderColor;
        postalCodeTextField.layer.borderWidth = 2.5f;
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
        
        NSString * postelCode = [postalCodeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", kBaseURL]];
        
        NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
        [dictionary setObject:@"POSTALCODE_VERIFICATION_SERVICE" forKey:@"request_type_sent"];
        [dictionary setObject:postelCode forKey:@"postal_code"];
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
            [self signUpUserSuccessfully];
             [[AppDelegate sharedInstance] loadingEnd];
         }];
    }
}

-(void)fbSignUp {
    
    NSCharacterSet * charSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    
    if ([[nameField.text stringByTrimmingCharactersInSet:charSet] length] == 0)
    {
        errorMessageLbl.text = NSLocalizedString(kEmptyNameAlert, nil);
        
        [self markTextFieldRedCorner:nameField];
        [self showErrorViewWithHeight:92.0f];
    }
    else if (![Utility emailValidate:mailField.text]) {
        [RSTAlertView showAlertMessage:NSLocalizedString(@"Invalid Email", nil) withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
            if (buttonIndex == 0) {}
        }];
        return;
    }
    else if ((([[mailField.text stringByTrimmingCharactersInSet:charSet] length] == 0) && ([[confirmMailField.text stringByTrimmingCharactersInSet:charSet] length] == 0)) || ![mailField.text isEqualToString:confirmMailField.text])
    {
        errorMessageLbl.text = NSLocalizedString(@"Both emails are not matching,Please review the fields marked in red.", nil);
        
        [self markTextFieldRedCorner:mailField];
        [self markTextFieldRedCorner:confirmMailField];
        [self showErrorViewWithHeight:92.0f];
    }
      else if (([[mobileNumberField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] < 8))
    {
        errorMessageLbl.text = NSLocalizedString(@"Please enter valid phone no, It should be 8 to 15 digits.", nil);
        
        [self markTextFieldRedCorner:mobileNumberField];
        [self showErrorViewWithHeight:92.0f];
    }
    else if (([[postalCodeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] < 5))
    {
        errorMessageLbl.text = NSLocalizedString(kIncorrectPostalCodeAlert, nil);
        
        [self markTextFieldRedCorner:postalCodeTextField];
        [self showErrorViewWithHeight:92.0f];
    }
    else if (!TermsCheckBoxBtn.selected)
    {
        [RSTAlertView showAlertMessage:@"Por favor, introduzca sus términos y condiciones en primer lugar." withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
            if (buttonIndex == 0) {}
        }];
        return;
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
        [dictionary setObject:@"SIGNUP_FACEBOOK_SERVICE" forKey:@"request_type_sent"];
        [dictionary setValue:[nameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"name"];
        [dictionary setValue:[mailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"email"];
        [dictionary setValue:[mobileNumberField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"phone_no"];
        [dictionary setValue:[postalCodeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"postal_code"];
        [dictionary setObject:@"2" forKey:@"device_type"];
        [dictionary setObject:deviceToken forKey:@"push_id"];
        if (checkboxButton.selected)
        {
            [dictionary setObject:@"1" forKey:@"want_news"];
        }
        else
        {
            [dictionary setObject:@"0" forKey:@"want_news"];
        }

        dictionary = (NSMutableDictionary *)[Utility convertIntoBase64:[dictionary allValues] dictionary:dictionary];
        
        [dictionary setObject:@"1" forKey:@"decode"];
        
        WebCommunication * webComm = [WebCommunication new];
        [webComm callToServerRequestDictionary:dictionary onURL:url WithBlock:^(NSDictionary * response, NSInteger status_code, NSError *error, WebCommunication * webComm)
         {
             [[AppDelegate sharedInstance] loadingEnd];

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
             
             if ([response objectForKey:@"error_desc"])
             {
                 [RSTAlertView showAlertMessage:[response objectForKey:@"error_desc"] withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
                     if (buttonIndex == 0) {}
                 }];
                 return;
             }

             if (![response objectForKey:@"register_status"]) {
                 [RSTAlertView showAlertMessage:@"This user already exists. Please Login." withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
                 }];
                 
             }
             
             else
             {
                [Utility setObject:[response objectForKey:@"consumer_id"] forKey:kUserId];
                 
                 [kAppDelegate.window addSubview:opaqueView];
                 [kAppDelegate.window addSubview:OTPView];
                 [[UIApplication sharedApplication].keyWindow bringSubviewToFront:OTPView];
                 resendButton.enabled = NO;
                 resendButton.alpha = 0.3;
                 otpEmailBtn.enabled = NO;
                 otpEmailBtn.alpha = 0.3;
                 
                 resendTimer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(reEnableResendBtn) userInfo:nil repeats:NO];
             }
         }];
    }
}

-(void)regularSignUp {
    
    NSCharacterSet * charSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    
    if ([[nameField.text stringByTrimmingCharactersInSet:charSet] length] == 0)
    {
        errorMessageLbl.text = NSLocalizedString(kEmptyNameAlert, nil);
        
        [self markTextFieldRedCorner:nameField];
        [self showErrorViewWithHeight:92.0f];
    }
    else if (![Utility emailValidate:mailField.text]) {
        [RSTAlertView showAlertMessage:NSLocalizedString(@"Invalid Email", nil) withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
            if (buttonIndex == 0) {}
        }];
        return;
    }
    else if ((([[mailField.text stringByTrimmingCharactersInSet:charSet] length] == 0) && ([[confirmMailField.text stringByTrimmingCharactersInSet:charSet] length] == 0)) || ![mailField.text isEqualToString:confirmMailField.text])
    {
        errorMessageLbl.text = NSLocalizedString(@"Both emails are not matching,Please review the fields marked in red.", nil);
        
        [self markTextFieldRedCorner:mailField];
        [self markTextFieldRedCorner:confirmMailField];
        [self showErrorViewWithHeight:92.0f];
    }
    else if ((([[passwordField.text stringByTrimmingCharactersInSet:charSet] length] == 0) && ([[confirmPassword.text stringByTrimmingCharactersInSet:charSet] length] == 0)) || ![passwordField.text isEqualToString:confirmPassword.text] || [[passwordField.text stringByTrimmingCharactersInSet:charSet] length] < 8)
    {
        errorMessageLbl.text = NSLocalizedString(@"Both passwords are not matching,it should be more than 8 character.please review the fields marked in red.", nil);
        
        [self markTextFieldRedCorner:passwordField];
        [self markTextFieldRedCorner:confirmPassword];
        [self showErrorViewWithHeight:92.0f];
    }
    else if (([[mobileNumberField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] < 8))
    {
        errorMessageLbl.text = NSLocalizedString(@"Please enter valid phone no, It should be 8 to 15 digits.", nil);
        
        [self markTextFieldRedCorner:mobileNumberField];
        [self showErrorViewWithHeight:92.0f];
    }
    else if (([[postalCodeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] < 5))
    {
        errorMessageLbl.text = NSLocalizedString(kIncorrectPostalCodeAlert, nil);
        
        [self markTextFieldRedCorner:postalCodeTextField];
        [self showErrorViewWithHeight:92.0f];
    }
    else if (!TermsCheckBoxBtn.selected)
    {
        [RSTAlertView showAlertMessage:@"Por favor, introduzca sus términos y condiciones en primer lugar." withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
            if (buttonIndex == 0) {}
        }];
        return;
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
        [dictionary setObject:@"CONSUMER_REGISTRATION" forKey:@"request_type_sent"];
        [dictionary setValue:[nameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"name"];
        [dictionary setValue:[mailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"email"];
        [dictionary setValue:[passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"password"];
        [dictionary setValue:[mobileNumberField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"phone_no"];
        [dictionary setValue:[postalCodeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"postal_code"];
        [dictionary setObject:@"2" forKey:@"device_type"];
        [dictionary setObject:deviceToken forKey:@"push_id"];
        if (checkboxButton.selected)
        {
            [dictionary setObject:@"1" forKey:@"want_news"];
        }
        else
        {
            [dictionary setObject:@"0" forKey:@"want_news"];
        }
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
             
             if([[response objectForKey:@"register_status"] isEqualToString:@"1"])
             {
                 [Utility setObject:[response objectForKey:@"consumer_id"] forKey:kUserId];
                 
                 [kAppDelegate.window addSubview:opaqueView];
                 [kAppDelegate.window addSubview:OTPView];

                 resendButton.enabled = NO;
                 resendButton.alpha = 0.3;
                 otpEmailBtn.enabled = NO;
                 otpEmailBtn.alpha = 0.3;
                 
                 resendTimer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(reEnableResendBtn) userInfo:nil repeats:NO];
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
}
@end
