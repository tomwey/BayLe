//
//  SendMailCommand.h
//  Wallpapers10000+
//
//  Created by tangwei1 on 15/8/4.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import "ShareCommand.h"

/** 收件人 */
FOUNDATION_EXTERN NSString * const AWMailRecipientsKey;

/** 主题 */
FOUNDATION_EXTERN NSString * const AWMailSubjectKey;

/** 附件 */
FOUNDATION_EXTERN NSString * const AWMailAttachmentDataKey;

/** 邮件内容 */
FOUNDATION_EXTERN NSString * const AWMailBodyKey;

/** 邮件内容是否是HTML格式 */
FOUNDATION_EXTERN NSString * const AWMailBodyIsHTMLKey;

@interface SendMailCommand : ShareCommand

@end
