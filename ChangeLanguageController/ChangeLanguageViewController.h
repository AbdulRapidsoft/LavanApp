//
//  ChangeLanguageViewController.h
//  LavanApp
//
//  Created by IPHONE-11 on 21/07/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeLanguageViewController : UIViewController
{
    __weak IBOutlet UIButton * doneButton;
    __weak IBOutlet UIButton * englishButton;
    __weak IBOutlet UIButton * spanishButton;
}

- (IBAction)languageButtonClicked:(UIButton *)sender;
- (IBAction)doneButtonClicked:(UIButton *)sender;
- (IBAction)backButtonClicked:(UIButton *)sender;

@end
