//
//  CenterViewController.m
//  LavanApp
//
//  Created by IPHONE-10 on 5/28/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

//%%% customizeable button attributes
#define X_BUFFER 0 //%%% the number of pixels on either side of the segment
#define Y_BUFFER 30 //%%% number of pixels on top of the segment
#define HEIGHT 30 //%%% height of the segment

//%%% customizeable selector bar attributes (the black bar under the buttons)
#define ANIMATION_SPEED 0.1 //%%% the number of seconds it takes to complete the animation
#define SELECTOR_HEIGHT 4 //%%% thickness of the selector bar

#define X_OFFSET 0 //%%% for some reason there's a little bit of a glitchy offset.  I'm going to look for a better workaround in the future
#define NAVIGATION_VIEW_HEIGHT 60 //%%% Navigationview height containing segment buttons and selector
#define SEGMENT_IMAGE_HEIGHT 150 //%%% Segment imageview height
#define SELECTOR_Y_BUFFER   NAVIGATION_VIEW_HEIGHT - SELECTOR_HEIGHT //%%% the y-value of the bar that shows what page you are on (0 is the top)
#define SEGMENT_BUTTON_WIDTH 100 //%%% Segment buttons width

#define MOREINDICATORBUTTON_WIDTH 25

#import "CenterViewController.h"
#import "PlaceOrderViewController.h"
#import "MFSideMenu.h"
#import "Definition.h"
#import "WebCommunication.h"
#import "Utility.h"
#import "RSTAlertView.h"

@interface CenterViewController () <PlaceOrderProtocolDelegate>
{
    UIScrollView * pageScrollView;
    UIScrollView * navigationScrollView;
    UIViewController * currentSegmentViewController;
    NSMutableArray * segmentButtonsArray;
    UIButton * leftMoreIndicatorButton, * rightMoreIndicatorButton;
    NSInteger currentPageIndex, segmentButtonWidth;
    AppDelegate * appDelegate;
    NSMutableArray * tabsArray;
}

@property (weak, nonatomic) IBOutlet UILabel *cartCountLabel;


@end

@implementation CenterViewController

#pragma mark - view life cycle methods

- (void)viewDidLoad
{
    segmentButtonWidth = 82;
    categoryImagesArray = [NSMutableArray new];
    buttonText = [[NSMutableArray alloc] init];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LogoImage.png"]];
    
    self.viewControllerArray = [[NSMutableArray alloc] init];
    currentSegmentViewController = [[UIViewController alloc] init];
    segmentButtonsArray = [NSMutableArray array];
    currentPageIndex = 0;
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    [self.pageController.view setFrame:CGRectMake(0, 64 + NAVIGATION_VIEW_HEIGHT, self.pageController.view.frame.size.width, self.pageController.view.frame.size.height - (64 + NAVIGATION_VIEW_HEIGHT))];
    self.pageController.dataSource = nil;
    [self.pageController.view setBackgroundColor:[UIColor colorWithRed:18.0/255.0 green:104.0/255.0 blue:131.0/255.0 alpha:1]];
    [self.view addSubview:self.pageController.view];
    
    self.cartCountLabel.layer.cornerRadius = 10;
    self.cartCountLabel.layer.masksToBounds = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCenterView) name:@"refreshCenterView" object:nil];
    
    //[self getAllCategoriesFromServer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;

    if (!([tabsArray count] > 0))
    {
        [self getAllCategoriesFromServer];
    }

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
        placeOrderBtn.hidden = YES;
    }
}

- (void)getAllCategoriesFromServer
{
    if (![Utility isNetworkAvailable])
    {
        [RSTAlertView showAlertMessage:NSLocalizedString(kNetworkError, nil) withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
            if (buttonIndex == 0) {}
        }];
        return;
    }
    
    UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    NSMutableArray * controllerArr = [[NSMutableArray alloc] init];
    
    NSString * deviceToken = [Utility objectForKey:@"DeviceToken"];
    if (deviceToken == nil)
    {
        deviceToken = @"0123456789";
    }
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", kBaseURL]];
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:@"ALL_CATEGORY_SERVICE" forKey:@"request_type_sent"];
    [dictionary setObject:@"2" forKey:@"device_type"];
    [dictionary setObject:deviceToken forKey:@"device_id"];
    dictionary = (NSMutableDictionary *)[Utility convertIntoBase64:[dictionary allValues] dictionary:dictionary];
    
    [dictionary setObject:@"1" forKey:@"decode"];
    
    [kAppDelegate loadingStart];
    
    WebCommunication * webComm = [WebCommunication new];
    [webComm callToServerRequestDictionary:dictionary onURL:url WithBlock:^(NSDictionary * response, NSInteger status_code, NSError *error, WebCommunication * webComm)
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
         
         if([[response objectForKey:@"error_code"] isEqualToString:@"400"])
         {
             NSLog(@"Could not get category successfully due to some problem.");
         }
         else
         {
             tabsArray = (NSMutableArray *)[response valueForKey:@"category_list"];
             if(tabsArray)
             {
                 for (int i = 0; i < tabsArray.count; i++)
                 {
                     ShirtsViewController * controller = (ShirtsViewController *)[storyBoard instantiateViewControllerWithIdentifier:@"ShirtsViewController"];
                     controller.catagoryType = [NSString stringWithFormat:@"%d", [[[tabsArray objectAtIndex:i] objectForKey:@"id"] intValue]];
                     controller.delegate = self;
                     [controllerArr addObject:controller];
                     [buttonText addObject:[[tabsArray objectAtIndex:i] objectForKey:@"name"]];
                     [categoryImagesArray addObject:[[tabsArray objectAtIndex:i] objectForKey:@"image"]];
                 }
                 [self.viewControllerArray addObjectsFromArray:controllerArr];
                 if (tabsArray.count < 4)
                 {
                     segmentButtonWidth = self.view.bounds.size.width/[self.viewControllerArray count];
                 }
                 
                 navigationScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,64,self.view.frame.size.width ,NAVIGATION_VIEW_HEIGHT)];
                 navigationScrollView.delegate = self;
                 navigationScrollView.showsHorizontalScrollIndicator = NO;
                 [navigationScrollView setBounces:NO];
                 
                 [self setupPageViewController];
                 [self setupSegmentButtons];
             }
         }
     }];
}

#pragma mark - memory management methods

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PlaceOrderProtocolDelegate methods

- (void)itemSelectedForPlaceingOrder:(ClothDetails *)selectedItem
{
    if ([appDelegate.cartItemsArray count] > 0)
    {
        if ([appDelegate.cartItemsArray containsObject:selectedItem])
        {
            int totalItems = [selectedItem.numberofItems intValue];
            totalItems += 1;
            selectedItem.numberofItems = [NSString stringWithFormat:@"%d", totalItems];
        }
        else
        {
            [appDelegate.cartItemsArray addObject:selectedItem];
            selectedItem.numberofItems = @"1";
        }
    }
    else
    {
        [appDelegate.cartItemsArray addObject:selectedItem];
        selectedItem.numberofItems = @"1";
    }
    
    placeOrderBtn.hidden = NO;
    [self.view bringSubviewToFront:placeOrderBtn];
    
    self.cartCountLabel.hidden = NO;
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

- (void)itemDeselectedForPlaceingOrder:(ClothDetails *)selectedItem
{
    NSMutableArray * toDelete = [NSMutableArray array];
    for (ClothDetails * clothObj in appDelegate.cartItemsArray)
    {
        if ([clothObj.clothID isEqualToString:selectedItem.clothID])
        {
            int totalItems = [clothObj.numberofItems intValue];
            if (totalItems == 1)
            {
                selectedItem.numberofItems = @"0";
                [toDelete addObject:selectedItem];
            }
            else
            {
                totalItems -= 1;
                clothObj.numberofItems = [NSString stringWithFormat:@"%d", totalItems];
            }
        }
    }
    if ([toDelete count] > 0)
    {
        [appDelegate.cartItemsArray removeObjectsInArray:toDelete];
    }
    
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


    if ([appDelegate.cartItemsArray count] < 1)
    {
        placeOrderBtn.hidden = YES;
        [self.cartCountLabel setHidden:YES];
    }
}

#pragma mark - navigation methods

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
}

#pragma mark - class methods

//This stuff here is customizeable: buttons, views, etc
////////////////////////////////////////////////////////////
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//%%%%%%%%%%%%%%%%%    CUSTOMIZEABLE    %%%%%%%%%%%%%%%%%%//
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//

//%%% color of the status bar
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    
    //    return UIStatusBarStyleDefault;
}

//%%% sets up the tabs using a loop.  You can take apart the loop to customize individual buttons, but remember to tag the buttons.  (button.tag=0 and the second button.tag=1, etc)
-(void)setupSegmentButtons
{
    NSInteger numControllers = [self.viewControllerArray count];
    
    self.navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,navigationScrollView.frame.size.width,NAVIGATION_VIEW_HEIGHT)];
    
    int xPosition = 0;
    int firstWidth = 0;
    for (int i = 0; i < numControllers; i++)
    {
        NSString * button_title = [buttonText objectAtIndex:i];
        CGSize stringsize = [button_title sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:22]}];
        int width_btn = stringsize.width;
        UIButton * button;
        UIButton * categoryImageView;
        {
            categoryImageView = [[UIButton alloc] initWithFrame:CGRectMake((xPosition + (width_btn/2)) - 15, 5, 30, 30 )];

            button = [[UIButton alloc] initWithFrame:CGRectMake(xPosition, Y_BUFFER, width_btn, HEIGHT)];
            xPosition += width_btn;
        }
        
        if (i == 0)
        {
            firstWidth = xPosition;
            [button setTitleColor:[UIColor colorWithRed:45.0/255.0 green:190.0/255.0 blue:255.0/255.0 alpha:1] forState:UIControlStateNormal];
        }
        else
        {
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        
        categoryImageView.tag = i;
        button.tag = i; //%%% IMPORTANT: if you make your own custom buttons, you have to tag them appropriately
        [button addTarget:self action:@selector(tapSegmentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [categoryImageView addTarget:self action:@selector(tapSegmentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:[buttonText objectAtIndex:i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:kRobotoFontBold size:6.0];
        if (i % 2 == 0) {

        }
        
        NSURL *imageURL = [NSURL URLWithString:[categoryImagesArray objectAtIndex:i]];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage *image = [UIImage imageWithData:imageData];
        [categoryImageView setImage:image forState:UIControlStateNormal];
        categoryImageView.contentMode = UIViewContentModeScaleAspectFit;

        [self.navigationView addSubview:button];
        [self.navigationView addSubview:categoryImageView];
        [segmentButtonsArray addObject:button];
    }
    [navigationScrollView setContentSize:CGSizeMake(xPosition,NAVIGATION_VIEW_HEIGHT)];
    self.navigationView.frame = CGRectMake(0, 0, xPosition, NAVIGATION_VIEW_HEIGHT);
    [navigationScrollView addSubview:self.navigationView];
    [self.view addSubview:navigationScrollView];
    
    rightMoreIndicatorButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - MOREINDICATORBUTTON_WIDTH + 3, 64, MOREINDICATORBUTTON_WIDTH, NAVIGATION_VIEW_HEIGHT)];
    leftMoreIndicatorButton = [[UIButton alloc] initWithFrame:CGRectMake(-3, 64, MOREINDICATORBUTTON_WIDTH, NAVIGATION_VIEW_HEIGHT)];
    
    rightMoreIndicatorButton.contentMode = UIViewContentModeCenter;
    leftMoreIndicatorButton.contentMode = UIViewContentModeCenter;
    rightMoreIndicatorButton.tag = 5001;
    leftMoreIndicatorButton.tag = 5002;
    [rightMoreIndicatorButton setImage:[UIImage imageNamed:@"RightIndicator.png"] forState:UIControlStateNormal];
    [leftMoreIndicatorButton setImage:[UIImage imageNamed:@"LeftIndicator.png"] forState:UIControlStateNormal];
    [rightMoreIndicatorButton setBackgroundColor:[UIColor whiteColor]];
    [leftMoreIndicatorButton setBackgroundColor:[UIColor whiteColor]];
    [rightMoreIndicatorButton addTarget:self action:@selector(arrowButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [leftMoreIndicatorButton addTarget:self action:@selector(arrowButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftMoreIndicatorButton];
    [self.view addSubview:rightMoreIndicatorButton];
    
    [leftMoreIndicatorButton setHidden:YES];
    if (xPosition < self.view.frame.size.width)
    {
        rightMoreIndicatorButton.hidden = YES;
    }

    [self setupSelector:firstWidth];
}

- (void)arrowButtonClicked:(UIButton *)arrowButton
{
    NSInteger tempIndex = currentPageIndex;
    __weak typeof(self) weakSelf = self;

    if (arrowButton.tag == 5001)
    {
        tempIndex += 1;
        // right button
        NSLog(@"right button");
        if(tempIndex < [self.viewControllerArray count])
        {
            [self.pageController setViewControllers:@[[self.viewControllerArray objectAtIndex:tempIndex]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL complete){
                // if the action finishes scrolling (i.e. the user doesn't stop it in the middle),then it updates the page that it's currently on
                if (complete)
                {
                    [weakSelf updateCurrentPageIndex:(int)tempIndex];
                    NSString * button_title = [buttonText objectAtIndex:tempIndex];
                    CGSize stringsize = [button_title sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:22]}];
                    int width_btn = stringsize.width;
                    UIButton *btn = [segmentButtonsArray objectAtIndex:tempIndex];
                    self.selectionBar.frame = CGRectMake(btn.frame.origin.x, self.selectionBar.frame.origin.y, width_btn, self.selectionBar.frame.size.height);
                    CGRect frame = CGRectMake(btn.frame.origin.x, self.selectionBar.frame.origin.y, self.selectionBar.frame.size.width, self.selectionBar.frame.size.height); //wherever you want to scroll
                    [navigationScrollView scrollRectToVisible:frame animated:YES];
                }
            }];
        }
    }
    else
    {
        tempIndex -= 1;
        // left button
        NSLog(@"left button");
        if(tempIndex < [self.viewControllerArray count])
        {
            [self.pageController setViewControllers:@[[self.viewControllerArray objectAtIndex:tempIndex]] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:^(BOOL complete){
                // if the action finishes scrolling (i.e. the user doesn't stop it in the middle),then it updates the page that it's currently on
                if (complete)
                {
                    [weakSelf updateCurrentPageIndex:(int)tempIndex];
                    NSString * button_title = [buttonText objectAtIndex:tempIndex];
                    CGSize stringsize = [button_title sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:22]}];
                    int width_btn = stringsize.width;
                    UIButton *btn = [segmentButtonsArray objectAtIndex:tempIndex];
                    self.selectionBar.frame = CGRectMake(btn.frame.origin.x, self.selectionBar.frame.origin.y, width_btn, self.selectionBar.frame.size.height);
                    CGRect frame = CGRectMake(btn.frame.origin.x, self.selectionBar.frame.origin.y, self.selectionBar.frame.size.width, self.selectionBar.frame.size.height); //wherever you want to scroll
                    [navigationScrollView scrollRectToVisible:frame animated:YES];
                }
            }];
        }
    }
    [self setBtnTextColors:tempIndex];
}

//%%% sets up the selection bar under the buttons on the navigation bar
-(void)setupSelector:(int)width
{
    self.selectionBar = [[UIView alloc] initWithFrame:CGRectMake(X_BUFFER-X_OFFSET, SELECTOR_Y_BUFFER,width, SELECTOR_HEIGHT)];
    self.selectionBar.backgroundColor = [UIColor colorWithRed:45.0/255.0 green:190.0/255.0 blue:255.0/255.0 alpha:1]; //%%% sbcolor
    self.selectionBar.alpha = 0.8; //%%% sbalpha
    [self.navigationView addSubview:self.selectionBar];
}

//                                                        //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//%%%%%%%%%%%%%%%%%    CUSTOMIZEABLE    %%%%%%%%%%%%%%%%%%//
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
////////////////////////////////////////////////////////////





//generally, this shouldn't be changed unless you know what you're changing
////////////////////////////////////////////////////////////
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//%%%%%%%%%%%%%%%%%%        SETUP       %%%%%%%%%%%%%%%%%%//
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//                                                        //

//%%% generic setup stuff for a pageview controller.  Sets up the scrolling style and delegate for the controller
-(void)setupPageViewController
{
    self.pageController.delegate = self;
    self.pageController.dataSource = self;
    [self.pageController setViewControllers:@[[self.viewControllerArray objectAtIndex:0]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self syncScrollView];
}

//%%% this allows us to get information back from the scrollview, namely the coordinate information that we can link to the selection bar.
-(void)syncScrollView
{
    for (UIView * view in self.pageController.view.subviews)
    {
        if([view isKindOfClass:[UIScrollView class]])
        {
            pageScrollView = (UIScrollView *)view;
            pageScrollView.delegate = self;
        }
    }
}


//                                                        //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//%%%%%%%%%%%%%%%%%%        SETUP       %%%%%%%%%%%%%%%%%%//
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
////////////////////////////////////////////////////////////




//%%% methods called when you tap a button or scroll through the pages
// generally shouldn't touch this unless you know what you're doing or
// have a particular performance thing in mind
//////////////////////////////////////////////////////////
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//%%%%%%%%%%%%%%%        MOVEMENT         %%%%%%%%%%%%%%//
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//                                                      //

//%%% when you tap one of the buttons, it shows that page,
//but it also has to animate the other pages to make it feel like you're crossing a 2d expansion,
//so there's a loop that shows every view controller in the array up to the one you selected
//eg: if you're on page 1 and you click tab 3, then it shows you page 2 and then page 3
-(void)tapSegmentButtonAction:(UIButton *)button
{
    NSString * button_title = [buttonText objectAtIndex:button.tag];
    CGSize stringsize = [button_title sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:22]}];
    int width_btn = stringsize.width;
    
    UIButton *tempBtn = [segmentButtonsArray objectAtIndex:button.tag];
    self.selectionBar.frame = CGRectMake(tempBtn.frame.origin.x, self.selectionBar.frame.origin.y, width_btn, self.selectionBar.frame.size.height);
    
    [tempBtn setTitleColor:[UIColor colorWithRed:45.0/255.0 green:190.0/255.0 blue:255.0/255.0 alpha:1] forState:UIControlStateNormal];

    for (UIView * subView in button.superview.subviews)
    {
        if ([subView isKindOfClass:[UIButton class]])
        {
            if (subView != tempBtn)
            {
                [(UIButton *)subView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
        }
    }
    
    NSInteger tempIndex = currentPageIndex;
    
    __weak typeof(self) weakSelf = self;
    
    //%%% check to see if you're going left -> right or right -> left
    if (button.tag > tempIndex)
    {
        //%%% scroll through all the objects between the two points
        for (int i = (int)tempIndex+1; i <= button.tag; i++)
        {
            [self.pageController setViewControllers:@[[self.viewControllerArray objectAtIndex:i]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL complete){
                
                //%%% if the action finishes scrolling (i.e. the user doesn't stop it in the middle),
                //then it updates the page that it's currently on
                if (complete)
                {
                    [weakSelf updateCurrentPageIndex:i];
                }
            }];
        }
    }
    //%%% this is the same thing but for going right -> left
    else if (button.tag < tempIndex)
    {
        for (int i = (int)tempIndex-1; i >= button.tag; i--)
        {
            [self.pageController setViewControllers:@[[self.viewControllerArray objectAtIndex:i]] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:^(BOOL complete){
                if (complete)
                {
                    [weakSelf updateCurrentPageIndex:i];
                }
            }];
        }
    }
    
    if (button.tag == 0) {
        rightMoreIndicatorButton.hidden = NO;
        leftMoreIndicatorButton.hidden = YES;
    }
    else if (button.tag > 0) {
        rightMoreIndicatorButton.hidden = NO;
        leftMoreIndicatorButton.hidden = NO;
    }
    if (button.tag == [self.viewControllerArray count] - 1) {
        rightMoreIndicatorButton.hidden = YES;
        leftMoreIndicatorButton.hidden = NO;
    }

}

//%%% makes sure the nav bar is always aware of what page you're on
//in reference to the array of view controllers you gave
-(void)updateCurrentPageIndex:(int)newIndex
{
    currentPageIndex = newIndex;
}

-(void)setBtnTextColors:(NSInteger)currentIndex
{
    if (currentIndex == 0) {
        rightMoreIndicatorButton.hidden = NO;
        leftMoreIndicatorButton.hidden = YES;
    }
    else if (currentIndex > 0) {
        rightMoreIndicatorButton.hidden = NO;
        leftMoreIndicatorButton.hidden = NO;
    }
    if (currentIndex == [self.viewControllerArray count] - 1) {
        rightMoreIndicatorButton.hidden = YES;
        leftMoreIndicatorButton.hidden = NO;
    }
        
    for (UIButton * button in segmentButtonsArray)
    {
        if (button.tag == currentIndex)
        {
            [button setTitleColor:[UIColor colorWithRed:45.0/255.0 green:190.0/255.0 blue:255.0/255.0 alpha:1] forState:UIControlStateNormal];
        }
        else
        {
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
}

#pragma mark - UIScrollview methods

//%%% method is called when any of the pages moves.
//It extracts the xcoordinate from the center point and instructs the selection bar to move accordingly
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == pageScrollView)
    {
        CGFloat xFromCenter = self.view.frame.size.width - pageScrollView.contentOffset.x; //%%% positive for right swipe, negative for left
        
        //%%% checks to see what page you are on and adjusts the xCoor accordingly.
        //i.e. if you're on the second page, it makes sure that the bar starts from the frame.origin.x of the
        //second tab instead of the beginning
        
        int xCoor = 0;
        CGRect last_frame;
        for (int i = 0; i <= currentPageIndex; i++)
        {
            UIButton * segment_button = [segmentButtonsArray objectAtIndex:i];
            if (!(i == currentPageIndex))
            {
                xCoor += segment_button.frame.size.width;
            }
            last_frame = segment_button.frame;
        }
        
        self.selectionBar.frame = CGRectMake(xCoor-xFromCenter/[self.viewControllerArray count], self.selectionBar.frame.origin.y, last_frame.size.width, self.selectionBar.frame.size.height);
        CGRect frame = CGRectMake(xCoor-xFromCenter/[self.viewControllerArray count], self.selectionBar.frame.origin.y, self.selectionBar.frame.size.width, self.selectionBar.frame.size.height); //wherever you want to scroll
        [navigationScrollView scrollRectToVisible:frame animated:YES];
    }
    else
    {
        CGFloat totalOffset = navigationScrollView.contentSize.width - self.view.frame.size.width;
        if (navigationScrollView.contentOffset.x  == totalOffset)
        {
            rightMoreIndicatorButton.hidden = YES;
        }
        else
        {
            rightMoreIndicatorButton.hidden = NO;
        }
        
        if (navigationScrollView.contentOffset.x > 0)                                                                                                                                                                                                                                                                               
        {
            [leftMoreIndicatorButton setHidden:NO];
        }
        else
        {
            [leftMoreIndicatorButton setHidden:YES];
        }
    }
}

//                                                      //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//%%%%%%%%%%%%%%%         MOVEMENT         %%%%%%%%%%%%%//
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//////////////////////////////////////////////////////////


#pragma mark - UIPageViewController Data Source and Delegate

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = [self indexOfController:viewController];
    
    [self setBtnTextColors:index];
    
    if ((index == NSNotFound) || (index == 0))
    {
        return nil;
    }
    
    index--;
    return [self.viewControllerArray objectAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index = [self indexOfController:viewController];
    
    [self setBtnTextColors:index];
    
    if (index == NSNotFound)
    {
        return nil;
    }
    index++;
    
    if (index == [self.viewControllerArray count])
    {
        return nil;
    }
    return [self.viewControllerArray objectAtIndex:index];
}

-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (completed)
    {
        currentPageIndex = [self indexOfController:[pageViewController.viewControllers lastObject]];
        
        NSString * button_title = [buttonText objectAtIndex:currentPageIndex];
        CGSize stringsize = [button_title sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:22]}];
        int width_btn = stringsize.width;
        
        UIButton *tempBtn = [segmentButtonsArray objectAtIndex:currentPageIndex];
        self.selectionBar.frame = CGRectMake(tempBtn.frame.origin.x, self.selectionBar.frame.origin.y, width_btn, self.selectionBar.frame.size.height);
        
        [tempBtn setTitleColor:[UIColor colorWithRed:45.0/255.0 green:190.0/255.0 blue:255.0/255.0 alpha:1] forState:UIControlStateNormal];
        
        for (UIView * subView in tempBtn.superview.subviews)
        {
            if ([subView isKindOfClass:[UIButton class]])
            {
                if (subView != tempBtn)
                {
                    [(UIButton *)subView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                }
            }
        }

    }
}

//%%% checks to see which item we are currently looking at from the array of view controllers.
// not really a delegate method, but is used in all the delegate methods, so might as well include it here
-(NSInteger)indexOfController:(UIViewController *)viewController
{
    for (int i = 0; i < [self.viewControllerArray count]; i++)
    {
        if (viewController == [self.viewControllerArray objectAtIndex:i])
        {
            return i;
        }
    }
    return NSNotFound;
}

#pragma mark - IBAction Methods

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

- (IBAction)placeOrderButtonClicked:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"PlaceOrderScreen" sender:self];
}

-(void)refreshCenterView {
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
        placeOrderBtn.hidden = YES;
    }
}
@end
