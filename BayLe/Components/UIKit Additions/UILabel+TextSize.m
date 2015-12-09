//
//  UILabelTextLength.m
//  BayLe
//
//  Created by tangwei1 on 15/11/20.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import "UILabel+TextSize.h"

@implementation UILabel (TextSize)

- (CGSize)textSizeForConstrainedSize:(CGSize)size
{
    return [self.text sizeWithFont:self.font constrainedToSize:size lineBreakMode:self.lineBreakMode];
}

@end
