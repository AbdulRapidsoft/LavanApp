//
//  ChangeLanguageViewController.m
//  LavanApp
//
//  Created by IPHONE-11 on 21/07/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

#import "ChangeLanguageViewController.h"
#import "RSTAlertView.h"
#import "Definition.h"

@interface ChangeLanguageViewController ()

@end

@implementation ChangeLanguageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    doneButton.layer.masksToBounds = YES;
    doneButton.layer.cornerRadius = 5.0;
    
    self.navigationController.navigationBarHidden = YES;

//    NSArray * app_languages = [[NSUserDefaults standardUserDefaults] valueForKey:@"AppleLanguages"];
//    NSLog(@"%@", app_languages);
//    
//    if ([[app_languages objectAtIndex:0] isEqualToString:@"es"])
//    {
//        [englishButton setImage:[UIImage imageNamed:@"UncheckboxImage.png"] forState:UIControlStateNormal];
//        englishButton.selected = NO;
//        [spanishButton setImage:[UIImage imageNamed:@"CheckboxImage.png"] forState:UIControlStateNormal];
//        spanishButton.selected = YES;
//    }
//    else
//    {
//        [englishButton setImage:[UIImage imageNamed:@"CheckboxImage.png"] forState:UIControlStateNormal];
//        englishButton.selected = YES;
//        [spanishButton setImage:[UIImage imageNamed:@"UncheckboxImage.png"] forState:UIControlStateNormal];
//        spanishButton.selected = NO;
//    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)languageButtonClicked:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected)
    {
        //NSLog(@"selected");
        [sender setImage:[UIImage imageNamed:@"CheckboxImage.png"] forState:UIControlStateNormal];

        if (sender.tag == 1061)
        {
            [spanishButton setImage:[UIImage imageNamed:@"UncheckboxImage.png"] forState:UIControlStateNormal];
            spanishButton.selected = !spanishButton.selected;
        }
        else
        {
            [englishButton setImage:[UIImage imageNamed:@"UncheckboxImage.png"] forState:UIControlStateNormal];
            englishButton.selected = !englishButton.selected;
        }
    }
    else
    {
        //NSLog(@"not selected");
        [sender setImage:[UIImage imageNamed:@"UncheckboxImage.png"] forState:UIControlStateNormal];

        if (sender.tag == 1061)
        {
            [spanishButton setImage:[UIImage imageNamed:@"CheckboxImage.png"] forState:UIControlStateNormal];
            spanishButton.selected = !spanishButton.selected;
        }
        else
        {
            [englishButton setImage:[UIImage imageNamed:@"CheckboxImage.png"] forState:UIControlStateNormal];
            englishButton.selected = !englishButton.selected;
        }
    }
}

- (IBAction)doneButtonClicked:(UIButton *)sender
{
    [RSTAlertView showAlertMessage:NSLocalizedString(kChangeLanguageAlert, nil) withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            
//            if (spanishButton.selected)
//            {
//                [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"es", @"en", nil] forKey:@"AppleLanguages"];
//            }
//            else
//            {
//                [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"en", @"es", nil] forKey:@"AppleLanguages"];
//            }
//            [[NSUserDefaults standardUserDefaults] synchronize];

            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (IBAction)backButtonClicked:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
