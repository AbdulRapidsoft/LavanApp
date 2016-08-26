//
//  LoginViewController.m
//  LavanApp
//
//  Created by IPHONE-10 on 5/26/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
{
    AppDelegate * appDelegate;
}

@property (weak, nonatomic) IBOutlet UILabel * cartCountLabel;

@end

@implementation LoginViewController

#pragma mark - view life cycle methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    usernameField.leftViewMode = UITextFieldViewModeAlways;
    passwordField.leftViewMode = UITextFieldViewModeAlways;

    UIImageView * leftView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 21)];
    leftView1.contentMode = UIViewContentModeScaleAspectFit;
    leftView1.backgroundColor = [UIColor clearColor];
    leftView1.image = [UIImage imageNamed:@"MailFieldImg.png"];
    usernameField.leftView = leftView1;
    
    UIImageView * leftView2 = [[UIImageView alloc] initWithFrame:leftView1.frame];
    leftView2.contentMode = UIViewContentModeScaleAspectFit;
    leftView2.backgroundColor = [UIColor clearColor];
    leftView2.image = [UIImage imageNamed:@"PasswordFieldImg.png"];
    passwordField.leftView = leftView2;
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LogoImage.png"]];
    
    loginButton.layer.masksToBounds = YES;
    loginButton.layer.cornerRadius = 5.0;
    
    facebookButton.layer.masksToBounds = YES;
    facebookButton.layer.cornerRadius = 5.0;


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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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

#pragma mark - memory management methods

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextField Delegates

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
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

#pragma mark - IBAction Methods

- (IBAction)loginButtonClicked:(UIButton *)sender
{
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];

    if ([[usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0)
    {
        [RSTAlertView showAlertMessage:NSLocalizedString(kEmptyEmailAlert, nil) withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
            if (buttonIndex == 0) {}
        }];
        usernameField.layer.cornerRadius = 6.0f;
        usernameField.layer.masksToBounds = YES;
        usernameField.layer.borderColor = kRedBorderColor;
        usernameField.layer.borderWidth = 2.5f;
    }
    else if ([[passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0)
    {
        [RSTAlertView showAlertMessage:kEmptyPasswordAlert withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
            if (buttonIndex == 0) {}
        }];
        passwordField.layer.cornerRadius = 6.0f;
        passwordField.layer.masksToBounds = YES;
        passwordField.layer.borderColor = kRedBorderColor;
        passwordField.layer.borderWidth = 2.5f;
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
        [dictionary setObject:@"CONSUMER_SERVICE_LOGIN" forKey:@"request_type_sent"];
        [dictionary setValue:[usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"email"];
        [dictionary setValue:[passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"password"];
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
             
             if([[response objectForKey:@"error_code"] isEqualToString:@"400"])
             {
                 [RSTAlertView showAlertMessage:[response objectForKey:@"error_desc"] withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
                     if (buttonIndex == 0) {}
                 }];
             }
             else
             {
                 [Utility setObject:usernameField.text forKey:kUserEmail];
                 [Utility setObject:passwordField.text forKey:kUserPassword];
                 [Utility setObject:[response objectForKey:@"name"] forKey:kUserName];
                 [Utility setObject:[response objectForKey:@"phone_no"] forKey:kUserMobileNo];
                 [Utility setObject:[response objectForKey:@"consumer_id"] forKey:kUserId];
                 [Utility setObject:[response objectForKey:@"want_news"] forKey:kWantNews];
                 [Utility setObject:@"1" forKey:kLoginType];
                 
                 [self showViewAfterSuccessfullyLogin];
             }
             [[AppDelegate sharedInstance] loadingEnd];
         }];
    }
}

- (IBAction)loginViaFBClicked:(UIButton *)sender
{
    login = [[FBSDKLoginManager alloc] init];
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
                              NSLog(@"%@",result);
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
                              [dictionary setObject:@"LOGIN_FACEBOOK_SERVICE" forKey:@"request_type_sent"];
                              [dictionary setValue:[result objectForKey:@"email"] forKey:@"email"];
                              [dictionary setValue:[result objectForKey:@"name"] forKey:@"name"];
                              [dictionary setObject:@"2" forKey:@"device_type"];
                              [dictionary setObject:deviceToken forKey:@"device_id"];
                              dictionary = (NSMutableDictionary *)[Utility convertIntoBase64:[dictionary allValues] dictionary:dictionary];

                              [dictionary setObject:@"1" forKey:@"decode"];
                              
                              WebCommunication * webComm = [WebCommunication new];
                              [webComm callToServerRequestDictionary:dictionary onURL:url WithBlock:^(NSDictionary * response, NSInteger status_code, NSError * error, WebCommunication * webComm)
                               {
                                   [kAppDelegate loadingEnd];

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
                                   
                                   if([[response objectForKey:@"error_code"] isEqualToString:@"400"])
                                   {

                                       [RSTAlertView showAlertMessage:[response objectForKey:@"error_desc"] withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
                                           if (buttonIndex == 0) {}
                                       }];

                                   }
                                   else
                                   {
                                       [Utility setObject:[response objectForKey:@"email"] forKey:kUserEmail];
                                       [Utility setObject:[response objectForKey:@"name"] forKey:kUserName];
                                       [Utility setObject:[response objectForKey:@"phone_no"] forKey:kUserMobileNo];
                                       [Utility setObject:[response objectForKey:@"id"] forKey:kUserId];
                                       [Utility setObject:[response objectForKey:@"want_news"] forKey:kWantNews];
                                       [Utility setObject:@"2" forKey:kLoginType];

                                       [self showViewAfterSuccessfullyLogin];
                                   }
                               }];
                          }
                      }];
                 }
             }
             else
             {
                 [kAppDelegate loadingEnd];

                 [RSTAlertView showAlertMessage:NSLocalizedString(@"Could not get Email from your account", nil) withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
                     if (buttonIndex == 0) {}
                     return ;
                 }];
             }

        }

     }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)forgotPasswordClicked:(UIButton *)sender
{
    NSLog(@"Forgot Password Clicked");
}

- (IBAction)menuButtonClicked:(UIButton *)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
    }];
}

- (IBAction)cartButtonClicked:(UIButton *)sender
{
    NSLog(@"cart Button Clicked");
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

- (void)showViewAfterSuccessfullyLogin
{
    [Utility setBool:YES forKey:kIsLogin];
    
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

@end
