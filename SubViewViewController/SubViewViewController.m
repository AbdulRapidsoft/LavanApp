//
//  SubViewViewController.m
//  LavanApp
//
//  Created by IPHONE-10 on 6/10/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

#import "SubViewViewController.h"
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <Social/Social.h>
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import "WebCommunication.h"
#import "LIALinkedInApplication.h"
#import "LIALinkedInHttpClient.h"
#import "OrderStatusViewController.h"
#import "AppDelegate.h"
#import "Utility.h"
#import "CenterViewController.h"

#define LINKEDIN_CLIENT_SECRET @"yUm5RF2adM5qZ8sZ"
#define LINKEDIN_CLIENT_ID     @"75r65jtc8kcczs"
#define LINKEDIN_REDIRECT_URI  @"https://www.rapidsofttechnologies.com"

static NSString * const kClientId = @"925804976832-fjp55aoq2b38tmcaeb7kvp3oqjrevfjg.apps.googleusercontent.com";

@interface SubViewViewController () <GPPSignInDelegate, GPPShareDelegate>
{
    NSString * personalCode;
}

@end

@implementation SubViewViewController

@synthesize pushType, backgroundView, orderNumber;

#pragma mark - view life cycle methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    personalCode = @"5BHSD3";

    self.navigationController.navigationBarHidden = YES;
    
    int type = [self.pushType intValue];
    switch (type)
    {
        case 1:
        {
            logoImageView.image = [UIImage imageNamed:@"PostalErrorImg.png"];
            shareView.hidden = YES;
            attentionView.hidden = YES;
            zipcodeView.hidden = NO;
            congratulationView.hidden = YES;
            self.backgroundView.backgroundColor = [UIColor colorWithRed:18.0/255.0 green:104.0/255.0 blue:131.0/255.0 alpha:1.0];
        }
            break;
        case 2:
        {
            logoImageView.image = [UIImage imageNamed:@"ShareScreenLogo.png"];
            shareView.hidden = NO;
            attentionView.hidden = YES;
            zipcodeView.hidden = YES;
            congratulationView.hidden = YES;
            self.backgroundView.backgroundColor = [UIColor colorWithRed:18.0/255.0 green:104.0/255.0 blue:131.0/255.0 alpha:1.0];
        }
            break;
        case 3:
        {
            logoImageView.image = [UIImage imageNamed:@"OrderedSelected.png"];
            shareView.hidden = YES;
            attentionView.hidden = YES;
            zipcodeView.hidden = YES;
            congratulationView.hidden = NO;
            self.backgroundView.backgroundColor = [UIColor colorWithRed:254.0/255.0 green:91.0/255.0 blue:109.0/255.0 alpha:1.0];
            closeBtn.hidden = YES;
            congratsLbl.text = [NSString stringWithFormat:@"%@ %@ %@",NSLocalizedString(@"Your order No.", nil), self.orderNumber ,NSLocalizedString(@"was successful. You can check your status at any time in the Your Orders section. Thank you for trusting Lavanapp.", nil)];
        
        }
            break;
        case 4:
        {
            logoImageView.image = [UIImage imageNamed:@"AttentionImage.png"];
            shareView.hidden = YES;
            attentionView.hidden = NO;
            zipcodeView.hidden = YES;
            congratulationView.hidden = YES;
            self.backgroundView.backgroundColor = [UIColor colorWithRed:18.0/255.0 green:104.0/255.0 blue:131.0/255.0 alpha:1.0];
        }
            break;
        default:
            
            break;
    }
    
    shareButtonsContainerView.layer.cornerRadius = 8;
    shareButtonsContainerView.layer.masksToBounds = YES;
    shareButtonsContainerView.layer.borderColor = [UIColor whiteColor].CGColor;
    shareButtonsContainerView.layer.borderWidth = 1.0;
    
    attentionViewCancleBtn.layer.cornerRadius = 8;
    attentionViewCancleBtn.layer.masksToBounds = YES;
    attentionViewCancleBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    attentionViewCancleBtn.layer.borderWidth = 2.0;
    
    attentionViewBackBtn.layer.cornerRadius = 8;
    attentionViewBackBtn.layer.masksToBounds = YES;
    attentionViewBackBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    attentionViewBackBtn.layer.borderWidth = 2.0;
    
    congratsViewYourOrderBtn.layer.cornerRadius = 8;
    congratsViewYourOrderBtn.layer.masksToBounds = YES;
    congratsViewYourOrderBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    congratsViewYourOrderBtn.layer.borderWidth = 2.0;
    
    congratsViewBackBtn.layer.cornerRadius = 8;
    congratsViewBackBtn.layer.masksToBounds = YES;
    congratsViewBackBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    congratsViewBackBtn.layer.borderWidth = 2.0;
}

-(void)viewWillDisappear:(BOOL)animated {
    if ([Utility boolForKey:kIsLogin]) {
        self.navigationController.navigationBarHidden = NO;
    }

}
#pragma mark -  memory methods

- (void)didReceiveMemoryWarning
{
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

#pragma mark - IBAction methods

- (IBAction)closeButtonTapped:(UIButton *)sender
{
    // Cross button
    int type = [self.pushType intValue];

    if (type == 1)
    {
        self.navigationController.navigationBarHidden = YES;
    }
    else
    {
        self.navigationController.navigationBarHidden = NO;
    }
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)shareAppButtonClicked:(UIButton *)sender
{
    switch (sender.tag)
    {
        case 51:
        {
            // FB
            NSLog(@"Facebook share");
            [self shareWithFacebook];
        }
            break;
        case 52:
        {
            // Twitter
            NSLog(@"Twitter share");
            [self shareWithTwitter];
        }
            break;
        case 53:
        {
            // Google
            NSLog(@"Google share");
            GPPSignIn * signIn  = [GPPSignIn sharedInstance];
            signIn.delegate = self;
            signIn.shouldFetchGooglePlusUser = YES;
            signIn.clientID = kClientId;
            signIn.scopes = @[kGTLAuthScopePlusLogin];
            
            if (![signIn trySilentAuthentication])
                [signIn authenticate];
        }
            break;
        case 54:
        {
            // LinkedIn
            NSLog(@"LinkedIn share");
            [self shareWithLinkedIn];
        }
            break;
         default:
            
            break;
    }
}

- (IBAction)attentionViewButtonClicked:(UIButton *)sender
{
    switch (sender.tag)
    {
        case 61:
        {
            // Yes Cancel my order
            NSLog(@"Yes Cancel my order");
        }
            break;
        case 62:
        {
            // No Back to order
            NSLog(@"No Back to order");
        }
            break;
        default:
            
            break;
    }
}

- (IBAction)congratulationViewButtonClicked:(UIButton *)sender
{
    self.navigationController.navigationBarHidden = NO;
    switch (sender.tag)
    {
        case 71:
        {
            // Go to your order
            //NSLog(@"Go to your order");
            [self.navigationController popViewControllerAnimated:NO];

            OrderStatusViewController * orderStatusController = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderStatusViewController"];
            [kAppDelegate.navController pushViewController:orderStatusController animated:NO];
        }
            break;
        case 72:
        {
            // back to top
            //NSLog(@"back to top");
//            CenterViewController * CenterViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CenterViewController"];
//            [kAppDelegate.navController pushViewController:CenterViewController animated:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CartItemsRemoved" object:nil];
            
            [Utility setObject:nil forKey:@"pickOrderDateLblText"];
            [Utility setObject:nil forKey:@"pickOrderTimeLblText"];
            [Utility setObject:nil forKey:@"dropOrderDateLblText"];
            [Utility setObject:nil forKey:@"dropOrderTimeLblText"];
            [Utility setObject:nil forKey:@"totalDiscount"];
            [Utility setObject:nil forKey:@"DiscountCoupenName"];
            [Utility setObject:nil forKey:@"PercentageOff"];
            [Utility setBool:NO forKey:@"couponApplied"];
            
            for (UIViewController *controller in kAppDelegate.navController.viewControllers) {
                if ([controller isKindOfClass:[CenterViewController class]]) {
                    //                index = (int)[kAppDelegate.navController.viewControllers indexOfObject:controller];
                    [kAppDelegate.navController popToViewController:controller animated:YES];
                }
            }

        }
            break;
        default:
            
            break;
    }
}

#pragma mark - Sharing Methods

-(void)shareWithFacebook
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController * facebookPost = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [facebookPost setInitialText:[NSString stringWithFormat:@"%@ - %@",NSLocalizedString(@"Lavanapp share with your friends and they will win next 5 Euro for services", nil), personalCode]];
        
        [self presentViewController:facebookPost animated:YES completion:nil];
        
        [facebookPost setCompletionHandler:^(SLComposeViewControllerResult result)
         {
             switch (result)
             {
                 case SLComposeViewControllerResultCancelled:
                     //NSLog(@"Facebook sharing Cancelled");
                     [[[UIAlertView alloc] initWithTitle:@"Lavanapp" message:NSLocalizedString(@"Facebook sharing cancelled.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
                     break;
                 case SLComposeViewControllerResultDone:
                     //NSLog(@"Sucessfully shared on Facebook");
                     [[[UIAlertView alloc] initWithTitle:@"Lavanapp" message:NSLocalizedString(@"Message has been sent sucessfully.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
                     break;
                     
                 default:
                     break;
             }
             [self dismissViewControllerAnimated:YES completion:nil];
         }];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"Alert" message:NSLocalizedString(@"Please set your Facebook account on Setting.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil] show];
        //NSLog(@"Please set your Facebook account in Setting.");
    }

//    FBSDKShareLinkContent *content = [FBSDKShareLinkContent new];
//    content.contentTitle = @"Lavanapp";
//    content.contentDescription = [NSString stringWithFormat:@"%@ - %@",NSLocalizedString(@"Lavanapp share with your friends and they will win next 5 Euro for services", nil), personalCode];
//    
//    [FBSDKShareDialog showFromViewController:self
//                                 withContent:content
//                                    delegate:nil];

}

-(void)shareWithTwitter
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController * twitterPost = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        [twitterPost setInitialText:[NSString stringWithFormat:@"%@ - %@",NSLocalizedString(@"Lavanapp share with your friends and they will win next 5 Euro for services", nil), personalCode]];

        [self presentViewController:twitterPost animated:YES completion:nil];
        
        [twitterPost setCompletionHandler:^(SLComposeViewControllerResult result)
         {
             switch (result)
             {
                 case SLComposeViewControllerResultCancelled:
                     //NSLog(@"Twitter sharing Cancelled");
                     [[[UIAlertView alloc] initWithTitle:@"Lavanapp" message:NSLocalizedString(@"Twitter sharing cancelled", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
                     break;
                 case SLComposeViewControllerResultDone:
                     //NSLog(@"Sucessfully shared on Twitter");
                     [[[UIAlertView alloc] initWithTitle:@"Lavanapp" message:NSLocalizedString(@"Message has been sent sucessfully.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
                     break;
                 default:
                     break;
             }
             [self dismissViewControllerAnimated:YES completion:nil];
         }];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"Alert" message:NSLocalizedString(@"Please set your Twitter account on Setting.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil] show];
        //NSLog(@"Please set your Twitter account in Setting.");
    }
}

-(void)shareWithGooglePlus
{
    id<GPPNativeShareBuilder> shareBuilder = [[GPPShare sharedInstance] nativeShareDialog];
    [shareBuilder setPrefillText:[NSString stringWithFormat:@"%@ - %@",NSLocalizedString(@"Lavanapp share with your friends and they will win next 5 Euro for services", nil), personalCode]];
    [GPPShare sharedInstance].delegate = self;
    [shareBuilder open];
}

-(void)shareWithLinkedIn
{
    if ([self.client validToken])
    {
        [self requestMeWithToken:[self.client accessToken]];
    }
    else
    {
        [self.client getAuthorizationCode:^(NSString *code) {
            [self.client getAccessToken:code success:^(NSDictionary *accessTokenData) {
                NSString * accessToken = [accessTokenData objectForKey:@"access_token"];
                [self requestMeWithToken:accessToken];
            }
                                failure:^(NSError *error) {
                NSLog(@"Quering accessToken failed %@", error);
            }];
        }
                                   cancel:^{
            NSLog(@"Authorization was cancelled by user");
        }
                                  failure:^(NSError *error) {
            NSLog(@"Authorization failed %@", error);
        }];
    }
}

- (void)requestMeWithToken:(NSString *)accessToken
{
       [self.client GET:[NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~:(id,first-name,last-name,maiden-name,formatted-name,phonetic-last-name,picture-url,location:(country:(code)),industry,distance,current-status,current-share,network,skills,phone-numbers,date-of-birth,main-address,positions:(title),educations:(school-name,field-of-study,start-date,end-date,degree,activities))?oauth2_access_token=%@&format=json", accessToken] parameters:nil success:^(AFHTTPRequestOperation * operation, NSDictionary * result) {
           
                NSString * shareUrl = [NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~/shares?oauth2_access_token=%@&format=json",accessToken];
                NSMutableDictionary * shareDict = [[NSMutableDictionary alloc] init];
                NSDictionary * visibility = [[NSDictionary alloc] initWithObjectsAndKeys:@"anyone", @"code", nil];
                [shareDict setObject:visibility forKey:@"visibility"];
                [shareDict setObject:[NSString stringWithFormat:@"%@ - %@",NSLocalizedString(@"Lavanapp share with your friends and they will win next 5 Euro for services", nil), personalCode] forKey:@"comment"];
                
                AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
                AFJSONRequestSerializer * requestSerializer = [AFJSONRequestSerializer serializer];
                [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                manager.requestSerializer = requestSerializer;
               
                [manager POST:shareUrl parameters:shareDict success:^(AFHTTPRequestOperation * operation, id responseObject) {
                        //NSLog(@"Shared Successfully: %@", responseObject);
                       [[[UIAlertView alloc] initWithTitle:@"Lavanapp" message:NSLocalizedString(@"Message has been sent sucessfully.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
                        }
                 
                        failure:^(AFHTTPRequestOperation * operation, NSError * error) {
                            [[[UIAlertView alloc] initWithTitle:@"Lavanapp" message:NSLocalizedString(@"Couldn't be shared due to some error.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
                        }];
                }
        
        failure:^(AFHTTPRequestOperation * operation, NSError * error) {
            NSLog(@"failed to fetch current user %@", error);
    }];
}

- (LIALinkedInHttpClient *)client
{
    LIALinkedInApplication * application = [LIALinkedInApplication applicationWithRedirectURL :@"https://www.rapidsofttechnologies.com"
                                    clientId:LINKEDIN_CLIENT_ID
                                clientSecret:LINKEDIN_CLIENT_SECRET
                                       state:@"DCEEFSK45453sdffef424"
                               grantedAccess:@[ @"r_emailaddress", @"r_basicprofile",@"rw_company_admin",@"w_share"]];
    
//    [@"r_fullprofile", @"r_network", @"rw_nus", @"rw_company_admin", @"r_emailaddress", @"r_basicprofile", @"w_messages", @"r_contactinfo", @"rw_groups"]
    
    return [LIALinkedInHttpClient clientForApplication:application presentingViewController:nil];
}

#pragma mark - GPPSignInDelegate Methods

- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth error: (NSError *) error
{
    if (!error)
    {
        [self shareWithGooglePlus];

    }
    NSLog(@"Received error %@ and auth object %@",error, auth);
}

- (void)finishedSharingWithError:(NSError *)error
{
    NSString * text;
    
    if (!error)
    {
        text = NSLocalizedString(@"Successful", nil);
    }
    else if (error.code == kGPPErrorShareboxCanceled)
    {
        text = NSLocalizedString(@"Canceled", nil);
    }
    else
    {
        text = [NSString stringWithFormat:@"Error (%@)", [error localizedDescription]];
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Lavanapp" message:[NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"Sharing", nil), text] delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    //NSLog(@"Status: %@", text);
}

@end
