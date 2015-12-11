//
//  UIButton+CustomTitleLabel.m
//  BayLe
//
//  Created by tangwei1 on 15/12/11.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import "UIButton+CustomTitleLabel.h"

@implementation UIButton (CustomTitleLabel)

- (void)setTitleFont:(UIFont *)font
{
    [[self titleLabel] setFont:font];
}

- (UIFont *)titleFont
{
    return [[self titleLabel] font];
}

@end
