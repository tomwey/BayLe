//
//  UILabelTextLength.h
//  BayLe
//
//  Created by tangwei1 on 15/11/20.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (TextSize)

/** 获取UILabel文本的大小 */
- (CGSize)textSizeForConstrainedSize:(CGSize)size;

@end
