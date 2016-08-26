//
//  ManualAddressViewController.h
//  LavanApp
//
//  Created by IPHONE-10 on 10/15/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPGooglePlacesAutocompleteQuery.h"
#import "SPGooglePlacesAutocompletePlace.h"
#import "WebCommunication.h"
#import "Utility.h"
#import "RSTAlertView.h"
#import "Definition.h"
#import "PlaceOrderViewController.h"

@interface ManualAddressViewController : UIViewController
{
    __weak IBOutlet UITextField *addressTxtField;
    __weak IBOutlet UITableView *resultsTableView;
    __weak IBOutlet UIButton *yourCartBtn;
}
@property(nonatomic,strong)NSString * locationText;

@end
