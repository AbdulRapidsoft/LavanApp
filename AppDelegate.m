
//
//  AppDelegate.m
//  LavanApp
//
//  Created by IPHONE-11 on 26/05/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "Utility.h"
#import "LoginViewController.h"
#import "ChildPageViewController.h"
#import "WebCommunication.h"
#import "RSTAlertView.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <GooglePlus/GooglePlus.h>
#import <Braintree/Braintree.h>

@interface AppDelegate ()
{
    UIViewController * sideMenuController;
    UIViewController * centerController;
    UIStoryboard * storyBoard;
}

@end

@implementation AppDelegate

@synthesize navController, container, last_selected_row;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.cartItemsArray = [NSMutableArray array];
    self.last_selected_row = 0;
    
    storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    self.navController = (UINavigationController *)[storyBoard instantiateViewControllerWithIdentifier:@"NavigationController"];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    
    BOOL isFirstLaunch = [Utility boolForKey:@"isFirstTimeLaunched"];
    if (isFirstLaunch)
    {
        // App is not launched for first time
        BOOL isLogin = [Utility boolForKey:kIsLogin];
        if (isLogin)
        {
            // When app is already logged in with a user
            [self loginUser];
        }
        else
        {
            // When app is not logged in with any user
            sideMenuController = (SecondSideMenuController *)[storyBoard instantiateViewControllerWithIdentifier:@"SecondSideMenuController"];
            centerController = (IntroPageViewController *)[storyBoard instantiateViewControllerWithIdentifier:@"IntroPageViewController"];
            [(IntroPageViewController *)centerController setIndex:3];
            
            (void)[self.navController initWithRootViewController:centerController];
            
            self.container = [MFSideMenuContainerViewController
                              containerWithCenterViewController:self.navController
                              leftMenuViewController:sideMenuController
                              rightMenuViewController:nil];
            self.container.panMode = MFSideMenuPanModeNone;
            self.container.shadow.enabled = NO;
            
            self.window.rootViewController = self.container;
            [self createStatusBarBackgroundView];
        }
                
    }
    else
    {
        // App is launched first time
        IntroPageViewController * introController = [storyBoard instantiateViewControllerWithIdentifier:@"IntroPageViewController"];
        [introController setIndex:0];
        (void)[self.navController initWithRootViewController:introController];
        self.window.rootViewController = self.navController;
        [self createStatusBarBackgroundView];
        [self.window makeKeyAndVisible];

    }
    
    //Status bar view
      NSString * deviceToken = [Utility objectForKey:@"DeviceToken"];
    if (deviceToken == nil)
    {
        [self getRegisterForRecievingPushNotifications:application];
    }
    
    [FBSDKLoginButton class];
    [Braintree setReturnURLScheme:@"com.unique.secomm.payments"];
    
    return YES;
}

- (void)getRegisterForRecievingPushNotifications:(UIApplication *)application
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationSettings * notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
#else
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
#endif
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString * token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    [Utility setObject:token forKey:@"DeviceToken"];
    NSLog(@"pushDeviceToken %@",token);
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    NSString * str = [NSString stringWithFormat:@"Error: %@", err];
    NSLog(@"%@",str);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    for (id key in userInfo)
    {
        NSLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
    }
    NSDictionary * pushDic = [userInfo objectForKey:@"aps"];
    NSLog(@"%@", pushDic);
}

+ (AppDelegate *)sharedInstance
{
    return [[UIApplication sharedApplication] delegate];
}

- (void)loadingStart
{
    UIView * blankview = [[UIView alloc]initWithFrame:self.window.bounds];
    blankview.backgroundColor = [UIColor lightGrayColor];
    blankview.alpha = 0.5;
    blankview.tag = 1111;
    UIActivityIndicatorView * loader = [[UIActivityIndicatorView alloc]init];
    loader.tag = 1212;
    loader.center = blankview.center;
    [loader startAnimating];
    [blankview addSubview:loader];
    [self.window addSubview:blankview];
}

- (void)loadingEnd
{
    UIView * blankview = (UIView *)[self.window viewWithTag:1111];
    UIActivityIndicatorView * loader = (UIActivityIndicatorView *)[blankview viewWithTag:1212];
    [loader stopAnimating];
    [blankview removeFromSuperview];
}

- (void)loadingStartWithoutIndicator
{
    UIView * blankview = [[UIView alloc]initWithFrame:self.window.bounds];
    blankview.backgroundColor = [UIColor lightGrayColor];
    blankview.alpha = 0.5;
    blankview.tag = 2222;
    [self.window addSubview:blankview];
}

- (void)loadingEndWithoutIndicator
{
    UIView * blankview = (UIView *)[self.window viewWithTag:2222];
    [blankview removeFromSuperview];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([[url scheme] caseInsensitiveCompare:@"com.unique.secomm"] == NSOrderedSame)
    {
        if ([url query].length)
        {
            return [GPPURLHandler handleURL:url
                          sourceApplication:sourceApplication
                                 annotation:annotation];
        }
    }
    if ([[url scheme] caseInsensitiveCompare:@"com.unique.secomm.payments"] == NSOrderedSame)
    {
        if ([url query].length)
        {
            return [Braintree handleOpenURL:url sourceApplication:sourceApplication];
        }
    }

    [kAppDelegate loadingStart];
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [Utility setObject:nil forKey:@"directionFieldText"];
    [Utility setObject:nil forKey:@"postalTextFieldText"];
    [Utility setObject:nil forKey:@"notesFieldText"];
    [Utility setObject:nil forKey:@"detailedAddressText"];
    [Utility setObject:nil forKey:@"pickOrderDateLblText"];
    [Utility setObject:nil forKey:@"pickOrderTimeLblText"];
    [Utility setObject:nil forKey:@"dropOrderDateLblText"];
    [Utility setObject:nil forKey:@"dropOrderTimeLblText"];
    [Utility setObject:nil forKey:@"totalDiscount"];
    [Utility setBool:NO forKey:@"couponApplied"];
    [Utility setObject:nil forKey:@"stateTextFieldText"];
    [Utility setObject:nil forKey:@"cityTextFieldText"];
    [Utility setObject:nil forKey:@"cityTextFieldID"];
    [Utility setObject:nil forKey:@"stateTextFieldID"];
}

- (void)loginUser{
    
    if (![Utility isNetworkAvailable])
    {
        [RSTAlertView showAlertMessage:NSLocalizedString(kNetworkError, nil) withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
            if (buttonIndex == 0) {}
        }];
        return;
    }

    UIImageView *splashView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SplashScreen"]];
    splashView.frame = kAppDelegate.window.bounds;
    [kAppDelegate.window addSubview:splashView];

    UIImageView *splashLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"splashLogo"]];
    
    //steps to to simulate centerY multiplier 1.2 of logo to the window
    CGFloat screenHalfHeight = (kAppDelegate.window.frame.size.height/2);
    CGFloat multiplierHeightToSubtract = (screenHalfHeight * 20)/100; //20%
    CGFloat originYForLogo = screenHalfHeight - multiplierHeightToSubtract - 28;// 28 = logo_height/2 - statusbar_height/2
    splashLogo.frame = CGRectMake((kAppDelegate.window.frame.size.width - 293)/2, originYForLogo, 293, 75); // logo_size = (293, 75)
    [kAppDelegate.window addSubview:splashLogo];

    NSString * deviceToken = [Utility objectForKey:@"DeviceToken"];
    if (deviceToken == nil)
    {
        deviceToken = @"0123456789";
    }

if ([[Utility objectForKey:kLoginType] isEqualToString:@"2"]) {
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", kBaseURL]];
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:@"LOGIN_FACEBOOK_SERVICE" forKey:@"request_type_sent"];
    [dictionary setValue:[Utility objectForKey:kUserEmail] forKey:@"email"];
    [dictionary setValue:[Utility objectForKey:kUserName] forKey:@"name"];
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
         
         NSLog(@"response : %@",response);
         
         if([[response objectForKey:@"error_code"] isEqualToString:@"400"])
         {
             
             [RSTAlertView showAlertMessage:[response objectForKey:@"error_desc"] withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
                 if (buttonIndex == 0) {}
             }];
        }
         else
         {
             [self showViewAfterSuccessfullyLogin];
         }
     }];
    
}
else {
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", kBaseURL]];
        NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
        [dictionary setObject:@"CONSUMER_SERVICE_LOGIN" forKey:@"request_type_sent"];
        [dictionary setValue:[Utility objectForKey:kUserEmail] forKey:@"email"];
        [dictionary setValue:[Utility objectForKey:kUserPassword] forKey:@"password"];
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
                     if (buttonIndex == 0) {
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
                         
                         sideMenuController = (SecondSideMenuController *)[storyBoard instantiateViewControllerWithIdentifier:@"SecondSideMenuController"];
                         centerController = (IntroPageViewController *)[storyBoard instantiateViewControllerWithIdentifier:@"IntroPageViewController"];
                         [(IntroPageViewController *)centerController setIndex:3];
                         
                         (void)[self.navController initWithRootViewController:centerController];
                         
                         self.container = [MFSideMenuContainerViewController
                                           containerWithCenterViewController:self.navController
                                           leftMenuViewController:sideMenuController
                                           rightMenuViewController:nil];
                         self.container.panMode = MFSideMenuPanModeNone;
                         self.container.shadow.enabled = NO;
                         
                         self.window.rootViewController = self.container;
                         [self createStatusBarBackgroundView];

                     }
                 }];
             }
             else
             {                     
                 [self showViewAfterSuccessfullyLogin];
             }
             [[AppDelegate sharedInstance] loadingEnd];
         }];
}

}

-(void)showViewAfterSuccessfullyLogin {
    
    FirstSideMenuController * sideMenuController = [storyBoard instantiateViewControllerWithIdentifier:@"FirstSideMenuController"];
    
    NSArray * navigationViewControllers = kAppDelegate.navController.viewControllers;
    BOOL isCenterAvailable = NO;
    for (UIViewController * controller in navigationViewControllers)
    {
        if ([controller isKindOfClass:[CenterViewController class]])
        {
            kAppDelegate.navController = (UINavigationController *)[storyBoard instantiateViewControllerWithIdentifier:@"NavigationController"];
            (void)[kAppDelegate.navController initWithRootViewController:controller];
            isCenterAvailable = YES;
        }
    }
    if (!isCenterAvailable)
    {
        CenterViewController * controller = [storyBoard instantiateViewControllerWithIdentifier:@"CenterViewController"];
        kAppDelegate.navController = (UINavigationController *)[storyBoard instantiateViewControllerWithIdentifier:@"NavigationController"];
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
    [self createStatusBarBackgroundView];

}

-(void)createStatusBarBackgroundView {
    [[UINavigationBar appearance] setBackgroundColor:[UIColor colorWithRed:45.0/255.0 green:190.0/255.0 blue:255.0/255.0 alpha:1]];
    [self.navController.navigationBar setBackgroundColor:[UIColor colorWithRed:45.0/255.0 green:190.0/255.0 blue:255.0/255.0 alpha:1]];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 20)];
        view.backgroundColor = [UIColor colorWithRed:43.0/255.0 green:184.0/255.0 blue:247.0/255.0 alpha:1];
        view.tag = 2010;
        [self.window.rootViewController.view addSubview:view];
    }

}

@end
