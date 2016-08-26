//
//  IntroPageViewController.m
//  GotOil
//
//  Created by IPHONE-10 on 4/27/15.
//  Copyright (c) 2015 IPHONE-10. All rights reserved.
//

#import "IntroPageViewController.h"

@interface IntroPageViewController ()<PostalCodeSuccessDelegate>
{
    int currentStoredPageIndex;
}

@end

@implementation IntroPageViewController

#pragma mark - view life cycle methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [Utility setBool:YES forKey:@"isFirstTimeLaunched"];
    
    currentStoredPageIndex = -1;
    self.navigationController.navigationBarHidden = YES;

    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageController.delegate = self;
    self.pageController.dataSource = self;
    CGRect rect = [[self view] bounds];
    rect.size.height = rect.size.height;
    [[self.pageController view] setFrame:rect];
    [self.pageController.view setBackgroundColor:[UIColor colorWithRed:18.0/255.0 green:104.0/255.0 blue:131.0/255.0 alpha:1]];
    
    ChildPageViewController * initialViewController = [self viewControllerAtIndex:self.index];
    NSArray * viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
    
    
    for (UIView * subView in [AppDelegate sharedInstance].window.rootViewController.view.subviews)
    {
        if (subView.tag == 2010)
        {
            subView.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:.1];
        }
    }
}

#pragma mark - memory management methods

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

- (void)postalCodeSuccessfullySendToServer
{
}

- (void)loadMenuViewController
{
    kAppDelegate.navController = (UINavigationController *)[self.storyboard instantiateViewControllerWithIdentifier:@"NavigationController"];
    
    SecondSideMenuController * sideMenuController = [self.storyboard instantiateViewControllerWithIdentifier:@"SecondSideMenuController"];
    
    CenterViewController * centerController = (CenterViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"CenterViewController"];
    (void)[kAppDelegate.navController initWithRootViewController:centerController];
    
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

#pragma mark - UIPageViewController delegate methods

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [(ChildPageViewController *)viewController index];
    if (index == 0)
    {
        return nil;
    }
    index--;
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [(ChildPageViewController *)viewController index];
    index++;
    if (index == 4)
    {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (ChildPageViewController *)viewControllerAtIndex:(NSUInteger)index
{
    ChildPageViewController * childController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChildPageViewController"];
    childController.index = index;
    childController.delegate = self;
    return childController;
}

@end
