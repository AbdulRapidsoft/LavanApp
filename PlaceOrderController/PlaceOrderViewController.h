//
//  PlaceOrderViewController.h
//  LavanApp
//
//  Created by IPHONE-10 on 6/2/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TPKeyboardAvoidingScrollView.h"
#import <Braintree/Braintree.h>
#import <MapKit/MapKit.h>
#import "SelectedOrderCell.h"
#import "AddMoreOrderCell.h"
#import "ClothDetails.h"
#import "MFSideMenu.h"
#import <MapKit/MapKit.h>
#import "AppDelegate.h"
#import "WebCommunication.h"
#import "Utility.h"
#import "RSTAlertView.h"
#import "FPPopoverController.h"
#import "StatePopOverViewController.h"
#import "CityPopOverViewController.h"
#import "LocationPopoverController.h"
#import "DatePopoverController.h"
#import "TimePopOverController.h"
#import "LoginViewController.h"
#import "SubViewViewController.h"
#import "SavedCardsViewController.h"
#import "ManualAddressViewController.h"
#import "CreditCardPaymentViewController.h"
#import "CreditCardPaymentViewController.h"
#import "SPGooglePlacesAutocompleteQuery.h"
#import "SPGooglePlacesAutocompletePlace.h"

@class SPGooglePlacesAutocompleteQuery;

@interface PlaceOrderViewController : UIViewController < UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate>
{
    __weak IBOutlet MKMapView * locationMapView;
    __weak IBOutlet UITextField * directionField;
    __weak IBOutlet UITextField * notesField;
    __weak IBOutlet UITextField * coupenCodeField;
    __weak IBOutlet UITextField * pickOrderDateLbl;
    __weak IBOutlet UITextField * pickOrderTimeLbl;
    __weak IBOutlet UITextField * dropOrderDateLbl;
    __weak IBOutlet UITextField * dropOrderTimeLbl;
    __weak IBOutlet UITextField * cityTextField;
    __weak IBOutlet UITextField * stateTextField;
    __weak IBOutlet UITextField * postalTextField;
    __weak IBOutlet UITextField * detailedAddressField;
    __weak IBOutlet UILabel * totalCartLbl;
    __weak IBOutlet UILabel * totalDiscountLbl;
    __weak IBOutlet UILabel * couponNameLbl;
    __weak IBOutlet UIButton * enterCoupenCodeBtn;
    __weak IBOutlet UIButton * applyCoupenCodeBtn;
    __weak IBOutlet UIButton * sendRequestBtn;
    __weak IBOutlet UIButton * stateButton;
    __weak IBOutlet UIButton * cityButton;
    __weak IBOutlet UIView * totalCartView;
    __weak IBOutlet UIView * discountCartView;
    __weak IBOutlet UIView * coupenCodeView;
    __weak IBOutlet UIView * errorInCoupenCodeView;
    __weak IBOutlet UIView * containerView;
    __weak IBOutlet UIView * collectionPickerContainerView;
    __weak IBOutlet UIView * deliveryPickerContainerView;
    __weak IBOutlet UITableView * selectedItemsTable;
    __weak IBOutlet UIView *loginAlertView;
    __weak IBOutlet UIView *opaqueView;
    __weak IBOutlet TPKeyboardAvoidingScrollView * scrollView;
    __weak IBOutlet NSLayoutConstraint * tableHeightConstraint;
    __weak IBOutlet NSLayoutConstraint * totalCartViewYConstraint;
    __weak IBOutlet NSLayoutConstraint * discountCartViewYConstraint;
    __weak IBOutlet NSLayoutConstraint * enterCoupenCodeBtnYConstraint;
    __weak IBOutlet NSLayoutConstraint * errorInCoupenCodeViewYConstraint;
    __weak IBOutlet NSLayoutConstraint * coupenCodeViewYConstraint;
    __weak IBOutlet NSLayoutConstraint * sendRequestBtnYConstraint;
    __weak IBOutlet NSLayoutConstraint * mainViewHeightConstraint;
    __weak IBOutlet NSLayoutConstraint * mainScrollViewHeightConstraint;
    
    NSMutableArray * coupenDetailsArr;
    NSMutableArray * selectedOrders;
    float totalOrderCost;
    float totalDiscountCost;
    NSString * couponID;
    NSArray * searchResultPlaces;
    SPGooglePlacesAutocompleteQuery * searchQuery;
    BOOL locationPopoverPresented;
}

@property (nonatomic, strong) Braintree * brainTree;
@property (nonatomic, strong) NSString * selectedAddress;

- (IBAction)backButtonClicked:(UIButton *)sender;
- (IBAction)showCalenderButtonClicked:(UIButton *)sender;
- (IBAction)showTimeButtonClicked:(UIButton *)sender;
- (IBAction)applyCoupenCodeClicked:(UIButton *)sender;
- (IBAction)noCoupenCodeClicked:(UIButton *)sender;
- (IBAction)sendRequestBtnClicked:(UIButton *)sender;
- (IBAction)enterCoupenCodeBtnClicked:(UIButton *)sender;

@end
