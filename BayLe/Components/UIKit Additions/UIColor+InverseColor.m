//
//  InverseColor.m
//  BayLe
//
//  Created by tangwei1 on 15/11/25.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import "UIColor+InverseColor.h"

@implementation UIColor (InverseColor)

- (UIColor *)inverseColor
{
    CGColorRef oldCGColor = self.CGColor;
    NSInteger numberOfComponents = CGColorGetNumberOfComponents(oldCGColor);
    
    if ( numberOfComponents <= 1 ) {
        // 只有alpha
        return [UIColor colorWithCGColor:oldCGColor];
    }
    
    const CGFloat* oldComponentColors = CGColorGetComponents(oldCGColor);
    CGFloat newComponentColors[numberOfComponents];
    
    int i = -1;
    // 4
    while (++i < numberOfComponents - 1) {
        newComponentColors[i] = 1 - oldComponentColors[i];
    }
    newComponentColors[i] = oldComponentColors[i]; // alpha
    
    CGColorRef newCGColor = CGColorCreate(CGColorGetColorSpace(oldCGColor), newComponentColors);
    UIColor* newColor = [UIColor colorWithCGColor:newCGColor];
    CGColorRelease(newCGColor);
    
    return newColor;
}

@end
