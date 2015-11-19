//
//  UITableViewAdditions.m
//  Wallpapers10000+
//
//  Created by tangwei1 on 15/8/6.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import "UITableViewAdditions.h"
#import <objc/runtime.h>
#import "AWUIUtils.h"
#import "UIViewAdditions.h"

static char kAWBlankLabelKey;
static char kAWBlankImageKey;

@implementation UITableView (EmptyAdditions)

@dynamic blankImage, blankImageView, blankLabel, blankMessage;


- (void)aw_setBlankLabel:(UILabel *)aLabel
{
    objc_setAssociatedObject(self, &kAWBlankLabelKey, aLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)aw_blankLabel
{
    UILabel* blankLabel = (UILabel *)objc_getAssociatedObject(self, &kAWBlankLabelKey);
    if ( !blankLabel ) {
        UIColor* color = self.backgroundColor;
        
        if ( [color isEqual:[UIColor clearColor]] ) {
            color = [UIColor whiteColor];
        } else {
            color = [color colorWithAlphaComponent:0.9];
        }
        blankLabel = AWCreateLabel(CGRectZero, nil, NSTextAlignmentCenter,
                                   AWSystemFontWithSize(16, NO),
                                   color);
        [[self containerView] addSubview:blankLabel];

        blankLabel.numberOfLines = 0;
        
        [self aw_setBlankLabel:blankLabel];
    }
    
    [[self containerView] bringSubviewToFront:blankLabel];
    
    return blankLabel;
}

- (void)aw_setBlankImageView:(UIImageView *)aImageView
{
    objc_setAssociatedObject(self, &kAWBlankImageKey, aImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImageView *)aw_blankImageView
{
    UIImageView* blankImageView = (UIImageView *)objc_getAssociatedObject(self, &kAWBlankImageKey);
    
    if ( !blankImageView ) {
        blankImageView = AWCreateImageView(nil);
        [[self containerView] addSubview:blankImageView];
        
        [self aw_setBlankImageView:blankImageView];
    }
    
    [[self containerView] bringSubviewToFront:blankImageView];
    
    return blankImageView;
}

- (void)setBlankImage:(UIImage *)blankImage
{
    if ( blankImage ) {
        self.hidden = YES;
        
        [self.blankImageView setImage:blankImage];
        
        self.blankImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        self.blankImageView.center = CGPointMake([self containerView].width / 2, [self containerView].height / 2);
    } else {
        self.hidden = NO;
        
        [self.blankImageView removeFromSuperview];
        [self aw_setBlankImageView:nil];
    }
}

- (UIImage *)blankImage
{
    return self.blankImageView.image;
}

- (UIView *)containerView
{
    return self.superview;
}

- (void)setBlankMessage:(NSString *)blankMessage
{
    if ( blankMessage.length > 0 ) {
        
        self.hidden = YES;
        
        CGSize constrainedSize = CGSizeMake([self containerView].width - 40, 5000);
        CGSize size = [blankMessage sizeWithFont:self.blankLabel.font
                               constrainedToSize:constrainedSize];
        self.blankLabel.bounds = CGRectMake(0, 0, size.width, size.height);
        self.blankLabel.center = CGPointMake([self containerView].width / 2, [self containerView].height / 2);
        
        self.blankLabel.text = blankMessage;

    } else {
        
        self.hidden = NO;
        
        [self.blankLabel removeFromSuperview];
        [self aw_setBlankLabel:nil];
    }
}

- (NSString *)blankMessage
{
    return self.blankLabel.text;
}

- (UILabel *)blankLabel
{
    return [self aw_blankLabel];
}

- (UIImageView *)blankImageView
{
    return [self aw_blankImageView];
}

@end
