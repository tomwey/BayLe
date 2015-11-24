//
//  LoadEmptyOrErrorHandle.m
//  BayLe
//
//  Created by tangwei1 on 15/11/24.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import "LoadEmptyOrErrorHandle.h"
#import <objc/runtime.h>

@implementation UITableView (LoadEmptyOrErrorHandle)

static char kLoadEmptyOrErrorHandleCallbackKey;
static char kLoadEmptyOrErrorHandleToastKey;

@dynamic reloadCallback;

- (void)setReloadCallback:(id<ReloadDataProtocol>)reloadCallback
{
    objc_setAssociatedObject(self, &kLoadEmptyOrErrorHandleCallbackKey, reloadCallback, OBJC_ASSOCIATION_ASSIGN);
}

- (id <ReloadDataProtocol>)reloadCallback
{
    return objc_getAssociatedObject(self, &kLoadEmptyOrErrorHandleCallbackKey);
}

- (UILabel *)toastLabel
{
    UILabel* toastLabel = objc_getAssociatedObject(self, &kLoadEmptyOrErrorHandleToastKey);
    if ( !toastLabel ) {
        toastLabel = [[[UILabel alloc] init] autorelease];
        objc_setAssociatedObject(self, &kLoadEmptyOrErrorHandleToastKey, toastLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        toastLabel.textAlignment = NSTextAlignmentLeft;
        toastLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        toastLabel.numberOfLines = 0;
        toastLabel.layer.cornerRadius = 6;
        toastLabel.clipsToBounds = YES;
        [self addSubview:toastLabel];
    }
    return toastLabel;
}

/** 显示吐司提示 */
- (void)showToast:(NSString *)message
{
    UILabel *toastLabel = [self toastLabel];
    [toastLabel bringSubviewToFront:toastLabel];
    
    CGFloat width = CGRectGetWidth(self.frame) * 0.618;
    
    CGSize size = [message sizeWithFont:toastLabel.font constrainedToSize:CGSizeMake(width, 5000) lineBreakMode:toastLabel.lineBreakMode];
//    CGFloat height = MIN(size.height, 37);
    
    toastLabel.frame = CGRectMake(0, 0, width, size.height);
    toastLabel.center = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) + 10 + CGRectGetHeight(toastLabel.frame) / 2);
    
    [UIView animateWithDuration:.3 animations:^{
        toastLabel.center = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) - 10 - CGRectGetHeight(toastLabel.frame) / 2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.3 delay:1.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
            toastLabel.center = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) + 10 + CGRectGetHeight(toastLabel.frame) / 2);
        } completion:^(BOOL finished) {
            
        }];
    }];
}

/**
 * 显示纯文本提示
 * @param message 提示文字
 */
- (void)showMessage:(NSString *)message
{
    
}

/**
 * 显示图片提示
 * 提示图片
 */
- (void)showImage:(NSString *)image
{
    
}

@end
