//
//  AWMaskView.m
//  Wallpapers10000+
//
//  Created by tangwei1 on 15/11/4.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import "AWMaskView.h"

@implementation AWMaskView

- (void)show:(BOOL)animated completion:( void (^)(BOOL finished) )completion
{
    if ( !animated ) {
        self.alpha = 1.0;
        if ( completion ) {
            completion(YES);
        }
    } else {
        [UIView animateWithDuration:.3 animations:^{
            self.alpha = 1.0;
        } completion:completion];
    }
}

- (void)dismiss:(BOOL)animated completion:( void (^)(BOOL finished) )completion
{
    if ( !animated ) {
        self.alpha = 0.0;
        if ( completion ) {
            completion(YES);
        }
    } else {
        [UIView animateWithDuration:.3 animations:^{
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            if ( completion ) {
                completion(YES);
            }
        }];
    }
}

@end

// 创建一个遮罩
AWMaskView* AWCreateMaskView(CGRect frame, UIColor *color, CGFloat alpha)
{
    return AWCreateMaskViewInView(frame, color, alpha, nil);
}

// 创建一个遮罩，并添加到视图
AWMaskView* AWCreateMaskViewInView(CGRect frame, UIColor *color, CGFloat alpha, UIView* view)
{
    AWMaskView* maskView = [[[AWMaskView alloc] init] autorelease];
    maskView.frame = frame;
    maskView.backgroundColor = color;
    maskView.alpha = alpha;
    
    [view addSubview:maskView];
    
    return maskView;
}