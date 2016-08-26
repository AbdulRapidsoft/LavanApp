//
//  ForgotPasswordViewController.m
//  LavanApp
//
//  Created by IPHONE-10 on 6/19/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

#import "ForgotPasswordViewController.h"

@interface ForgotPasswordViewController ()
{
    AppDelegate * appDelegate;
}

@property (weak, nonatomic) IBOutlet UILabel * cartCountLabel;

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    emailTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView * leftView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 21)];
    leftView1.contentMode = UIViewContentModeScaleAspectFit;
    leftView1.backgroundColor = [UIColor clearColor];
    leftView1.image = [UIImage imageNamed:@"MailFieldImg.png"];
    emailTextField.leftView = leftView1;
    
    emailTextField.layer.cornerRadius = 6.0f;
    emailTextField.layer.masksToBounds = YES;
    emailTextField.layer.borderColor = kGreyBorderColor;
    emailTextField.layer.borderWidth = 2.5f;

    sendButton.layer.masksToBounds = YES;
    sendButton.layer.cornerRadius = 5.0;

    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LogoImage.png"]];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)menuButtonClicked:(UIButton *)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
    }];
}

- (IBAction)sendButtonClicked:(UIButton *)sender
{
    [emailTextField resignFirstResponder];
    
    if ([[emailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0)
    {
        [RSTAlertView showAlertMessage:NSLocalizedString(kValidEmailAlert, nil) withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
            if (buttonIndex == 0) {}
        }];
    }
    else if (![Utility emailValidate:emailTextField.text])
    {
        [RSTAlertView showAlertMessage:NSLocalizedString(kValidEmailAlert, nil) withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
            if (buttonIndex == 0) {}
        }];
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
        [dictionary setObject:@"CONSUMER_FORGET_PASSWORD" forKey:@"request_type_sent"];
        [dictionary setValue:[emailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"email"];
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
             
             if([[response objectForKey:@"mail_send"] isEqualToString:@"1"])
             {
                 [RSTAlertView showAlertMessage:NSLocalizedString(@"A mail has been sent to your mail id.", nil) withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
                     if (buttonIndex == 0)
                     {
                         [emailTextField resignFirstResponder];
                         [self.navigationController popViewControllerAnimated:YES];
                     }
                 }];
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

- (IBAction)backButtonClicked:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.layer.cornerRadius = 6.0f;
    textField.layer.masksToBounds = YES;
    textField.layer.borderColor = kBlueBorderColor;
    textField.layer.borderWidth = 2.5f;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.layer.cornerRadius = 6.0f;
    textField.layer.masksToBounds = YES;
    textField.layer.borderColor = kGreyBorderColor;
    textField.layer.borderWidth = 2.5f;
    [textField layoutIfNeeded];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
