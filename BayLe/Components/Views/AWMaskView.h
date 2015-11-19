//
//  AWMaskView.h
//  Wallpapers10000+
//
//  Created by tangwei1 on 15/11/4.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AWMaskView : UIView

// 暂时只支持淡入淡出
- (void)show:(BOOL)animated completion:( void (^)(BOOL finished) )completion;
- (void)dismiss:(BOOL)animated completion:( void (^)(BOOL finished) )completion;

@end

// 创建一个遮罩
AWMaskView* AWCreateMaskView(CGRect frame, UIColor *color, CGFloat alpha);

// 创建一个遮罩，并添加到视图
AWMaskView* AWCreateMaskViewInView(CGRect frame, UIColor *color, CGFloat alpha, UIView* view);
