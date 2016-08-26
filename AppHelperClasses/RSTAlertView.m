//
//  RSTAlertView.m
//  LavanApp
//
//  Created by IPHONE-11 on 28/05/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

#import "RSTAlertView.h"

@implementation RSTAlertView

+ (RSTAlertView *)showAlertMessage:(NSString *)message withButtons:(AlertButtonsType)btnType completionHandler:(void(^)(NSInteger buttonIndex))handler_
{
    // delegate can be nil if the controller doesn't conform to alert view delegate protocol
    RSTAlertView * alert = nil;
    
    switch (btnType)
    {
        case eOk:
            alert = [[RSTAlertView alloc] initWithTitle:ALLALERTMSGSTITLE
                                               message:message
                                              delegate:nil
                                     cancelButtonTitle:NSLocalizedString(OKBUTTON, nil)
                                     otherButtonTitles:nil];
            break;
        case eOkCancel:
            alert = [[RSTAlertView alloc] initWithTitle:ALLALERTMSGSTITLE
                                               message:message
                                              delegate:nil
                                     cancelButtonTitle:OKBUTTON
                                     otherButtonTitles:CANCELBUTTON, nil];
            break;
        case eYesNo:
            alert = [[RSTAlertView alloc] initWithTitle:ALLALERTMSGSTITLE
                                               message:message
                                              delegate:nil
                                     cancelButtonTitle:NSLocalizedString(NOBUTTON, nil)
                                     otherButtonTitles:NSLocalizedString(YESBUTTON, nil), nil];
            break;
        case eAcceptReject:
            alert = [[RSTAlertView alloc] initWithTitle:ALLALERTMSGSTITLE
                                               message:message
                                              delegate:nil
                                     cancelButtonTitle:ACCEPTBUTTON
                                     otherButtonTitles:REJECTBUTTON, nil];
            break;
        case eClose:
            alert = [[RSTAlertView alloc] initWithTitle:ALLALERTMSGSTITLE
                                               message:message
                                              delegate:nil
                                     cancelButtonTitle:CLOSEBUTTON
                                     otherButtonTitles:nil];
            break;
        case eCloseRetry:
            alert = [[RSTAlertView alloc] initWithTitle:ALLALERTMSGSTITLE
                                               message:message
                                              delegate:nil
                                     cancelButtonTitle:CLOSEBUTTON
                                     otherButtonTitles:RETRYBUTTON, nil];
            break;
        case eRetryOpen:
            alert = [[RSTAlertView alloc] initWithTitle:ALLALERTMSGSTITLE
                                               message:message
                                              delegate:nil
                                     cancelButtonTitle:RETRYBUTTON
                                     otherButtonTitles:OPENBUTTON, nil];
            break;
        case eOkRetryCancel:
            alert = [[RSTAlertView alloc] initWithTitle:ALLALERTMSGSTITLE
                                               message:message
                                              delegate:nil
                                     cancelButtonTitle:OKBUTTON
                                     otherButtonTitles:RETRYBUTTON, CANCELBUTTON, nil];
            break;
        case eCancelLogout:
            alert = [[RSTAlertView alloc] initWithTitle:ALLALERTMSGSTITLE
                                               message:message
                                              delegate:nil
                                     cancelButtonTitle:CANCELBUTTON
                                     otherButtonTitles:LOGOUTBUTTON, nil];
            break;
        case eCloseView:
            alert = [[RSTAlertView alloc] initWithTitle:ALLALERTMSGSTITLE
                                               message:message
                                              delegate:nil
                                     cancelButtonTitle:CLOSEBUTTON
                                     otherButtonTitles:VIEWBUTTON, nil];
            break;
        case eActivateCancel:
            alert = [[RSTAlertView alloc] initWithTitle:ALLALERTMSGSTITLE
                                               message:message
                                              delegate:nil
                                     cancelButtonTitle:ACTIVATEBUTTON
                                     otherButtonTitles:CANCELBUTTON, nil];
            break;
        case eTryAgain:
            alert = [[RSTAlertView alloc] initWithTitle:ALLALERTMSGSTITLE
                                               message:message
                                              delegate:nil
                                     cancelButtonTitle:TRYAGAIN
                                     otherButtonTitles:nil];
            break;
        case eTryAgainSendPassword:
            alert = [[RSTAlertView alloc] initWithTitle:ALLALERTMSGSTITLE
                                               message:message
                                              delegate:nil
                                     cancelButtonTitle:TRYAGAIN
                                     otherButtonTitles:SENDPASSWORD, nil];
            break;
        case eTryAgainGotoLogin:
            alert = [[RSTAlertView alloc] initWithTitle:ALLALERTMSGSTITLE
                                               message:message
                                              delegate:nil
                                     cancelButtonTitle:TRYAGAIN
                                     otherButtonTitles:GOTOLOGIN, nil];
            break;
        case eDeleteEditCancel:
            alert = [[RSTAlertView alloc] initWithTitle:ALLALERTMSGSTITLE
                                               message:message
                                              delegate:nil
                                     cancelButtonTitle:CANCELBUTTON
                                     otherButtonTitles:EDITBUTTON,DELETEBUTTON, nil];
            break;
            case eCancelGotoLogin:
            alert = [[RSTAlertView alloc] initWithTitle:ALLALERTMSGSTITLE
                                                message:message
                                               delegate:nil
                                      cancelButtonTitle:NSLocalizedString(CANCELBUTTON, nil)
                                      otherButtonTitles:NSLocalizedString(GOTOLOGIN, nil), nil];
            break;
    }
    if (handler_)
    {
        alert.handler = handler_;
        alert.delegate = alert;
    }
    [alert show];
    return alert;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    alertView.delegate = nil;
    self.handler(buttonIndex);
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    alertView.delegate = nil;
    self.handler(-1);
}

@end
