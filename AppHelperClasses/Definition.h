//
//  Definition.h
//  LavanApp
//
//  Created by IPHONE-11 on 27/05/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

#import "AppDelegate.h"

#ifndef LavanApp_Definition_h
#define LavanApp_Definition_h

#define kBaseURL  @"http://dev2.rapidsoft.in/Lavanapp/services/index"
#define kTokenURL @"http://dev2.rapidsoft.in/Lavanapp/payment/client_token"

//#define kBaseURL  @"http://dev2.rapidsoft.in/lavanapp_web/services/index"
//#define kTokenURL @"http://dev2.rapidsoft.in/lavanapp_web/payment/client_token"

//#define kTokenURL @"http://test.rapidsoft.in/Lavanapp/payment/client_token"
//#define kBaseURL  @"http://test.rapidsoft.in/Lavanapp/services/index"

//#define kBaseURL  @"http://project.rapidsoft.in/Lavanapp/services/index"
//#define kTokenURL @"http://project.rapidsoft.in/Lavanapp/payment/client_token"

//#define kBaseURL  @"http://lavanapp.com/services/index"
//#define kTokenURL @"http://lavanapp.com/payment/client_token"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define kAppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

#define kAlert                       @"Alert"
#define kOK                          @"OK"
#define kValidEmailAlert             @"Please enter valid email ID."
#define kEmptyNameAlert              @"Please enter your name."
#define kEmptyEmailAlert             @"Email ID can't be empty."
#define kEmptyPasswordAlert          @"Password can't be empty."
#define kEmptyNumberAlert            @"Mobile number can't be empty."
#define kEmptyCouponCodeAlert        @"Discount code field is empty."
#define kEmptyZipCodeAlert           @"Postal Code field is empty."
#define kGeneralServerErrorAlert     @"Algo salió mal"
#define kMinimumDigitsInNumber       @"Please enter valid phone no, It should be 8 to 15 digits."
#define kConfirmMailAlert            @"Mail and Confirm Mail values are not same."
#define kConfirmPasswordAlert        @"Password and Confirm Password values are not same."
#define kNetworkError                @"Network error please try again later."
#define kLogoutAlert                 @"Are you sure you want to Logout from the App."
#define kDeleteAccountAlert          @"Are you sure you want to delete your account?"
#define kCancelChangesAlert          @"Are you sure you want to revert your profile changes."
#define kLoginForOrderAlert          @"You need to login first before placing an order."
#define kMinimumCharactersInPassword @"Minimum 8 characters required for password field."
#define kNoItemError                 @"Your cart is empty please insert some products to place order."
#define kChangeLanguageAlert         @"You need to restart the app again to change the language."
#define kIncorrectOTPAlert           @"Incorrect OTP"
#define kIncorrectPostalCodeAlert    @"Please Enter Valid Postal Code"
#define kZipcodeSuccess              @"Congrats! Our service is available in your area. Please Login or Signup to continue."
#define kOTPEmailDialogue            @"Don't received sms? then, resend SMS or confirm your account via email"
#define kDeleteCardAlert             @"Are you sure you want to delete this card."
#define kNoSlotsAlert                @"Lo sentimos, no hay ranuras de tiempo disponibles para hoy. Por favor seleccione otro día"

#define kUserName                    @"userName"
#define kUserEmail                   @"userEmail"
#define kUserPassword                @"userPassword"
#define kUserMobileNo                @"userMobileNo"
#define kUserId                      @"consumer_id"
#define kWantNews                    @"Want_News"
#define kIsLogin                     @"isLogin"
#define kLoginType                   @"loginType"
#define kRobotoFontRegular           @"Roboto-Regular"
#define kRobotoFontBold              @"Roboto-Bold"
#define kOrderId                     @"orderId"
#define kTotalAmount                 @"totalAmount"
#define kIsSavedCard                 @"isSavedCard"
#define kIsManualAddress             @"isManualAddress"

#define kBlueBorderColor             [[UIColor colorWithRed:167.0/255.0 green:233.0/255.0 blue:255.0/255.0 alpha:1] CGColor]
#define kRedBorderColor              [[UIColor colorWithRed:238.0/255.0 green:159.0/255.0 blue:150.0/255.0 alpha:1] CGColor]
#define kGreyBorderColor             [[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1] CGColor]

#endif
