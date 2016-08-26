//
//  WebViewController.m
//  LavanApp
//
//  Created by IPHONE-10 on 6/18/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

#import "WebViewController.h"
#import "AppDelegate.h"

//#define kAppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@interface WebViewController ()<UIWebViewDelegate>

@end

@implementation WebViewController

@synthesize pushType;

- (void)viewDidLoad
{
    webView.scrollView.bounces =NO;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

//    self.navigationController.navigationBarHidden = YES;

    NSString * htmlFile;
    NSString * urlAddress;
    int type = [self.pushType intValue];
    switch (type)
    {
        case 1:
        {
            self.title = NSLocalizedString(@"Contact Us", nil);
            urlAddress = @"http://test.rapidsoft.in/Lavanapp/consumer/index/contactUs";
            htmlFile = [[NSBundle mainBundle] pathForResource:@"contact_us" ofType:@"html"];
            break;
        }
        case 2:
        {
            self.title = NSLocalizedString(@"FAQ", nil);
            urlAddress = @"http://test.rapidsoft.in/Lavanapp/consumer/index/faq";
            htmlFile = [[NSBundle mainBundle] pathForResource:@"Help" ofType:@"html"];
            break;
        }
        case 3:
        {
            self.title = NSLocalizedString(@"Terms of Uses", nil);
            urlAddress = @"http://test.rapidsoft.in/Lavanapp/consumer/index/termsConditions";
            htmlFile = [[NSBundle mainBundle] pathForResource:@"terms_and_condition" ofType:@"html"];
            break;
        }
        case 4:
        {
            self.title = NSLocalizedString(@"Privacy Policy", nil);
            urlAddress = @"http://test.rapidsoft.in/Lavanapp/consumer/index/privatePolicy";
            htmlFile = [[NSBundle mainBundle] pathForResource:@"privacyPolicy" ofType:@"html"];
            break;
        }
        case 5:
        {
            self.title = NSLocalizedString(@"How It Works", nil);
            urlAddress = @"http://test.rapidsoft.in/Lavanapp/consumer/index/privatePolicy";
            htmlFile = [[NSBundle mainBundle] pathForResource:@"how_it_works" ofType:@"html"];
            break;
        }

        default:
            break;
    }
    NSError *error;
    NSString * htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:&error];
    webView.delegate = self;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:htmlFile]]];
    //[webView loadHTMLString:htmlString baseURL:nil];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    

    
//    [kAppDelegate.navController.navigationItem.backBarButtonItem setTitle:@"ttt"];


}
//UIButton *_button = [UIButton buttonWithType:UIButtonTypeCustom];
//[_button setFrame:CGRectMake(0.f, 0.f, 128.f, 128.f)]; // SET the values for your wishes
//[_button setCenter:CGPointMake(128.f, 128.f)]; // SET the values for your wishes
//[_button setClipsToBounds:false];
//[_button setBackgroundImage:[UIImage imageNamed:@"jquery-mobile-icon.png"] forState:UIControlStateNormal]; // SET the image name for your wishes
//[_button setTitle:@"Button" forState:UIControlStateNormal];
//[_button.titleLabel setFont:[UIFont systemFontOfSize:24.f]];
//[_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal]; // SET the colour for your wishes
//[_button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted]; // SET the colour for your wishes
//[_button setTitleEdgeInsets:UIEdgeInsetsMake(0.f, 0.f, -110.f, 0.f)]; // SET the values for your wishes
//[_button addTarget:self action:@selector(buttonTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication]delegate];
//    self.navigationItem.hidesBackButton = YES;
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
    backButton.backgroundColor = [UIColor clearColor];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton setTitle:@"Volver" forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal]; // SET the colour for your wishes
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -10.0, 0.0,60.0)];
    [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -30.0, 0.0, 0.0)];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithCustomView:backButton];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    return YES;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
