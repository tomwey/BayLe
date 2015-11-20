//
//  AWCaret.h
//  BayLe
//
//  Created by tangwei1 on 15/11/20.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CaretDirection) {
    CaretDirectionTop,    // 尖朝上
    CaretDirectionBottom, // 尖朝下
};

@interface AWCaret : UIView

/** 设置尖尖的方向，默认值为CaretDirectionBottom */
@property (nonatomic, assign) CaretDirection direction;

/** 设置Caret填充颜色, 默认为白色 */
@property (nonatomic, retain) UIColor* fillColor;

@end
