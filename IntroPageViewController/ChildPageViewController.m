//
//  ChildPageViewController.m
//  GotOil
//
//  Created by IPHONE-10 on 4/27/15.
//  Copyright (c) 2015 IPHONE-10. All rights reserved.
//

#import "ChildPageViewController.h"

@interface ChildPageViewController ()
{
    UIPageControl *pageControl;
}

@end

@implementation ChildPageViewController

#pragma mark - view life cycle methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    zipcodeField.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView * leftView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 21)];
    leftView1.contentMode = UIViewContentModeScaleAspectFit;
    leftView1.backgroundColor = [UIColor clearColor];
    leftView1.image = [UIImage imageNamed:@"PostalFieldImg.png"];
    zipcodeField.leftView = leftView1;

    zipcodeButton.layer.masksToBounds = YES;
    zipcodeButton.layer.cornerRadius = 5.0;
    zipcodeField.layer.cornerRadius = 6.0f;
    zipcodeField.layer.masksToBounds = YES;
    zipcodeField.layer.borderColor = kGreyBorderColor;
    zipcodeField.layer.borderWidth = 2.5f;
    
    [registerButton setTitle:NSLocalizedString(@"REGISTER", nil) forState:UIControlStateNormal];
    [loginBtn setTitle:NSLocalizedString(@"LOGIN", nil) forState:UIControlStateNormal];

    self.navigationController.navigationBarHidden = YES;
    if (self.index < 4)
    {
        NSArray * imgPath = [NSArray arrayWithObjects:@"WalkThroughOne.png",@"WalkThroughTwo.png",@"WalkThroughThree.png",@"WalkThroughFour.png",nil];
        
        NSArray * walkThorughStrings = [NSArray arrayWithObjects:@"TU ROPA\nLIMPIA Y\nPLANCHADA\nEN 24 HORAS\nESTÉS\nDONDE\nESTÉS",@"TU\nSERVICIO\nDE\nTINTORERÍA\nSIN\nMOVERTE\nDE\nCASA",@"VE\nHACIENDO\nPLANES PARA\nDISFRUTAR\nTU TIEMPO\nLIBRE",@"REGÍSTRATE\nO INICIA\nSESIÓN\nPARA\nDISFRUTAR\nDEL\nMUNDO\nLAVANAPP",nil];
        
        imageView.image = [UIImage imageNamed:[imgPath objectAtIndex:self.index]];

        NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString:[walkThorughStrings objectAtIndex:self.index]];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        [style setLineSpacing:4];
        [attrString addAttribute:NSParagraphStyleAttributeName
                           value:style
                           range:NSMakeRange(0, attrString.length)];
        
        if (self.view.bounds.size.height == 568) {
            [attrString addAttribute:NSFontAttributeName value:[UIFont fontWithName: walkthroughTextview.font.fontName size:35.0] range:NSMakeRange(0, attrString.length)];
        }
        else if (self.view.bounds.size.height == 480) {
            [attrString addAttribute:NSFontAttributeName value:[UIFont fontWithName: walkthroughTextview.font.fontName size:29.0] range:NSMakeRange(0, attrString.length)];
        }
        else if (self.view.bounds.size.height == 667) {
            [attrString addAttribute:NSFontAttributeName value:[UIFont fontWithName: walkthroughTextview.font.fontName size:41.0] range:NSMakeRange(0, attrString.length)];
        }
        else {
            [attrString addAttribute:NSFontAttributeName value:[UIFont fontWithName: walkthroughTextview.font.fontName size:43.0] range:NSMakeRange(0, attrString.length)];
        }
        
        [attrString addAttribute:NSParagraphStyleAttributeName
                           value:style
                           range:NSMakeRange(0, attrString.length)];
        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attrString.length)];
        walkthroughTextview.attributedText = attrString;
        if (self.index == 3) {
            
            NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString:@"REGÍSTRATE\nO INICIA\nSESIÓN\nPARA\nDISFRUTAR\nDEL\nMUNDO\nLAVANAPP"];
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            [style setLineSpacing:4];
            [attrString addAttribute:NSParagraphStyleAttributeName
                               value:style
                               range:NSMakeRange(0, attrString.length)];
            
            if (self.view.bounds.size.height == 568) {
                [attrString addAttribute:NSFontAttributeName value:[UIFont fontWithName: walkthroughTextview.font.fontName size:35.0] range:NSMakeRange(0, attrString.length)];
            }
            else if (self.view.bounds.size.height == 480) {
                [attrString addAttribute:NSFontAttributeName value:[UIFont fontWithName: walkthroughTextview.font.fontName size:29.0] range:NSMakeRange(0, attrString.length)];
            }
            else if (self.view.bounds.size.height == 667) {
                [attrString addAttribute:NSFontAttributeName value:[UIFont fontWithName: walkthroughTextview.font.fontName size:41.0] range:NSMakeRange(0, attrString.length)];
            }
            else {
                [attrString addAttribute:NSFontAttributeName value:[UIFont fontWithName: walkthroughTextview.font.fontName size:43.0] range:NSMakeRange(0, attrString.length)];
            }
            
            [attrString addAttribute:NSParagraphStyleAttributeName
                               value:style
                               range:NSMakeRange(0, attrString.length)];
            [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attrString.length)];
            walkthroughTextview.attributedText = attrString;
        }
        
        if (self.index == 3)
        {
            zipcodeField.hidden = NO;
            zipcodeButton.hidden = NO;
            registerButton.hidden = NO;
            loginBtn.hidden = NO;
            [[self.view viewWithTag:256] setHidden:NO];
    
        }
        else
        {
            zipcodeField.hidden = YES;
            zipcodeButton.hidden = YES;
            registerButton.hidden = YES;
            loginBtn.hidden = YES;
            [[self.view viewWithTag:256] setHidden:YES];

        }
    }
    else
    {
        zipcodeField.hidden = YES;
        zipcodeButton.hidden = YES;
        registerButton.hidden = YES;
        loginBtn.hidden = YES;
        [[self.view viewWithTag:256] setHidden:YES];

    }
    
    pageControl = [[UIPageControl alloc] init];;
    pageControl.pageIndicatorTintColor = [UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:0.3];
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    pageControl.backgroundColor = [UIColor clearColor];
    [pageControl setOpaque:NO];
    pageControl.frame = CGRectMake((self.view.frame.size.width / 2) - 50,self.view.frame.size.height - 20 ,100,20);
    pageControl.numberOfPages = 3;
    pageControl.userInteractionEnabled = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissMfMenuController) name:@"dismissMfMenuController" object:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    if (self.index < 3) {
        pageControl.currentPage = self.index;
        [self.view addSubview:pageControl];

    }
}
-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.view setNeedsDisplay];
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
    NSString * finalString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([finalString length] > 10)
        return NO;
    else
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

#pragma mark - IBAction methods

- (IBAction)zipcodeButtonClicked:(UIButton *)sender
{
    [zipcodeField resignFirstResponder];
    
    if ([[zipcodeField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0)
    {
        zipcodeField.layer.cornerRadius = 6.0f;
        zipcodeField.layer.masksToBounds = YES;
        zipcodeField.layer.borderColor = kRedBorderColor;
        zipcodeField.layer.borderWidth = 2.5f;
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
        
        NSString * postelCode = [zipcodeField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
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
             
             if([[response objectForKey:@"verify_status"] isEqualToString:@"1"])
             {
                 [RSTAlertView showAlertMessage:NSLocalizedString(kZipcodeSuccess, nil) withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
                     if (buttonIndex == 0) {}
                 }];
                 
             }
             else
             {
                 SubViewViewController * subviewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SubViewViewController"];
                 subviewController.pushType = @"1";
                 [kAppDelegate.navController pushViewController:subviewController animated:NO];
             }
             [[AppDelegate sharedInstance] loadingEnd];
         }];
    }
}

#pragma mark - IBAction methods

- (IBAction)leftButtonTapped:(UIButton *)sender
{
    kAppDelegate.navController = (UINavigationController *)[self.storyboard instantiateViewControllerWithIdentifier:@"NavigationController"];
    
    SecondSideMenuController * sideMenuController = [self.storyboard instantiateViewControllerWithIdentifier:@"SecondSideMenuController"];
    
    RegisterViewController * registerController = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterViewController"];
    (void)[kAppDelegate.navController initWithRootViewController:registerController];
    
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
    
    kAppDelegate.container.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:kAppDelegate.container animated:YES completion:nil];
}


- (IBAction)rightButtonTapped:(UIButton *)sender
{
    kAppDelegate.navController = (UINavigationController *)[self.storyboard instantiateViewControllerWithIdentifier:@"NavigationController"];
    
    SecondSideMenuController * sideMenuController = [self.storyboard instantiateViewControllerWithIdentifier:@"SecondSideMenuController"];
    
    LoginViewController * loginController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    (void)[kAppDelegate.navController initWithRootViewController:loginController];
    
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
    
    kAppDelegate.container.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
      [self presentViewController:kAppDelegate.container animated:YES completion:nil];
}

-(void)dismissMfMenuController {
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.view layoutSubviews];
    [self.view setNeedsDisplay];
}

@end
