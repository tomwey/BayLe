//
//  SendMailCommand.m
//  Wallpapers10000+
//
//  Created by tangwei1 on 15/8/4.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import "SendMailCommand.h"
#import <sys/utsname.h>
#import <MessageUI/MessageUI.h>
#import "AWUIUtils.h"
#import "AWLocale.h"
#import "AWModalAlert.h"

/** 收件人 */
NSString * const AWMailRecipientsKey     = @"AWMailRecipientsKey";
NSString * const AWMailSubjectKey        = @"AWMailSubjectKey";
NSString * const AWMailAttachmentDataKey = @"AWMailAttachmentDataKey";
NSString * const AWMailBodyKey           = @"AWMailBodyKey";
NSString * const AWMailBodyIsHTMLKey     = @"AWMailBodyIsHTMLKey";

@interface SendMailCommand () <MFMailComposeViewControllerDelegate>

@end

@implementation SendMailCommand

- (void)execute
{
    Class mailClass = NSClassFromString(@"MFMailComposeViewController");
    if ( mailClass != nil ) {
        if ( ![MFMailComposeViewController canSendMail] ) {
            [AWModalAlert say:AWLocalizedString(@"Not yet configure email", nil) message:@""];
        } else {
            MFMailComposeViewController* emailDialog = [[[MFMailComposeViewController alloc] init] autorelease];
            emailDialog.mailComposeDelegate = self;
            
            // 设置收件人
            [self configureRecipients:emailDialog];
            
            // 设置主题
            [emailDialog setSubject:[self.userData objectForKey:AWMailSubjectKey]];
            
            // 设置附件
            id obj = [self.userData objectForKey:AWMailAttachmentDataKey];
            if ( obj ) {
                if ( [obj isKindOfClass:[UIImage class]] ) {
                    NSData* imageData = [NSData dataWithData:UIImagePNGRepresentation(obj)];
                    [emailDialog addAttachmentData:imageData mimeType:@"image/png" fileName:@"image.png"];
                } else if ( [obj isKindOfClass:[NSData class]] ) {
                    // TODO: 其它类型的附件
                }
            }
            
            // 设置邮件内容
            id emailBody = [self.userData objectForKey:AWMailBodyKey];
            if ( [emailBody length] == 0 ) {
                // 加入设备相关信息
                NSString *appID = [[NSUserDefaults standardUserDefaults] objectForKey:@"appID"];
                if ( [appID length] == 0 ) {
                    emailBody = [NSString stringWithFormat:@"\n\n\n\n\n\n//Application Info\nApp Version: %@\nDevice: %@\niOS Version: %@",
                                 AWAppVersion(), AWDeviceName(), AWOSVersionString()];
                } else {
                    emailBody = [NSString stringWithFormat:@"\n\n\n\n\n\n//Application Info\nApp ID: %@\nApp Version: %@\nDevice: %@\niOS Version: %@", appID, AWAppVersion(), AWDeviceName(), AWOSVersionString()];
                }
            }
            
            [emailDialog setMessageBody:emailBody isHTML:[[self.userData objectForKey:AWMailBodyIsHTMLKey] boolValue]];
            
            // 显示邮件发送界面
            UIViewController* controller = [self.userData objectForKey:AWContainerViewControllerKey];
            if ( !controller ) {
                controller = AWAppWindow().rootViewController;
            }
            
            [controller presentViewController:emailDialog animated:YES completion:nil];
        }
    } else {
        [AWModalAlert say:AWLocalizedString(@"Mail Not Supported!", nil) message:@""];
    }
}

- (void)configureRecipients:(MFMailComposeViewController *)emailDialog
{
    id recipients = [self.userData objectForKey:AWMailRecipientsKey];
    
    if ( recipients && [recipients isKindOfClass:[NSString class]] ) {
        recipients = @[[recipients description]];
    }
    
    if ( [recipients count] > 0 ) {
        [emailDialog setToRecipients:recipients];
    }
    
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    NSLog(@"mail completed! good %i",result);
    
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    NSString* msg= nil;
    if ( result == MFMailComposeResultSaved ) {
        msg = AWLocalizedString(@"Email saved!", nil);
    }else if ( result == MFMailComposeResultSent ) {
        msg = AWLocalizedString(@"Send Successfully", nil);
        [[NSNotificationCenter defaultCenter] postNotificationName:AWShareSuccessNotification object:NSStringFromClass([self class])];
    }else if ( result == MFMailComposeResultFailed ) {
        msg = AWLocalizedString(@"Send Email Failed,Please Check Your Network Connection!", nil);
        [[NSNotificationCenter defaultCenter] postNotificationName:AWShareFailureNotification object:NSStringFromClass([self class])];
    }
    
    if ( msg ) {
        [AWModalAlert say:msg message:@""];
    }
}

@end
