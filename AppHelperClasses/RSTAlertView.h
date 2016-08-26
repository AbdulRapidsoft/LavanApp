//
//  RSTAlertView.h
//  LavanApp
//
//  Created by IPHONE-11 on 28/05/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ALLALERTMSGSTITLE           @"Lavanapp"

// generic alert view title strings
#define CANCELBUTTON					@"Cancel"
#define YESBUTTON						@"Yes"
#define NOBUTTON						@"No"
#define CLOSEBUTTON						@"Close"
#define RETRYBUTTON						@"Retry"
#define OPENBUTTON						@"Open"
#define LOGOUTBUTTON					@"Logout"
#define VIEWBUTTON						@"View"
#define TRYAGAIN						@"Try again"
#define SENDPASSWORD					@"Email Password Reminder"
#define GOTOLOGIN						@"Go To Login"
#define ADDBUTTON						@"Add"
#define OKBUTTON						@"OK"
#define CANCELBUTTON					@"Cancel"
#define YESBUTTON						@"Yes"
#define NOBUTTON						@"No"
#define ACCEPTBUTTON					@"Accept"
#define REJECTBUTTON					@"Reject"
#define CLOSEBUTTON						@"Close"
#define RETRYBUTTON						@"Retry"
#define OPENBUTTON						@"Open"
#define LOGOUTBUTTON					@"Logout"
#define VIEWBUTTON						@"View"
#define ACTIVATEBUTTON					OKBUTTON  @" To Activate"
#define TRYAGAIN						@"Try again"
#define SENDPASSWORD					@"Email Password Reminder"
#define GOTOLOGIN						@"Go To Login"
#define ADDBUTTON						@"Add"
#define DELETEBUTTON					@"Delete"
#define EDITBUTTON                      @"Edit"

typedef enum
{
    eOk							=	1,			// Ok
    eOkCancel,									// Ok Cancel
    eYesNo,										// Yes No
    eAcceptReject,								// Accept Reject
    eClose,										// Close
    eCloseRetry,								// Close Retry
    eRetryOpen,									// Retry Open-Link
    eOkRetryCancel,								// Ok Retry Cancel
    eCancelLogout,								// Cancel Logout
    eCloseView,									// Close View
    eActivateCancel,							// Ok-To-Activate Cancel
    eTryAgain,									// Try-Again
    eTryAgainSendPassword,						// Try-Again Email-Password-Reminder
    eTryAgainGotoLogin,							// Try-Again Go-To-Login
    eCancelGotoLogin,							// Cancel Go-To-Login
    eDeleteEditCancel,
} AlertButtonsType;

@interface RSTAlertView : UIAlertView <UIAlertViewDelegate>

@property (copy) void(^handler)(NSInteger index);

+ (RSTAlertView *)showAlertMessage:(NSString *)message withButtons:(AlertButtonsType)btnType completionHandler:(void(^)(NSInteger buttonIndex))handler;

@end
