//
//  WebViewController.h
//  LavanApp
//
//  Created by IPHONE-10 on 6/18/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController
{
    __weak IBOutlet UIWebView * webView;
}

@property (nonatomic, strong) NSString * pushType;

@end
