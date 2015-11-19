//
//  CustomNavBar.m
//  Wallpapers10000+
//
//  Created by tangwei1 on 15/11/16.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import "AWCustomNavBar.h"
#import "UIViewAdditions.h"

@implementation AWCustomNavBar
{
    UIImageView* _contentView;
    UILabel*     _titleLabel;
}

@dynamic backgroundColor, backgroundImage, title;

@synthesize contentView = _contentView;

- (id)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] ) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ( self = [super initWithCoder:aDecoder] ) {
        [self setup];
    }
    
    return self;
}

- (BOOL)OSVersionIsLower:(CGFloat)version
{
    return [[[UIDevice currentDevice] systemVersion] floatValue] < version;
}

- (void)setup
{
    CGFloat height = [self OSVersionIsLower:7.0] ? 44 : 64;
    self.frame = CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), height);
    
    _contentView = [[[UIImageView alloc] initWithImage:nil] autorelease];
    _contentView.frame = self.bounds;
    _contentView.backgroundColor = [UIColor blackColor];
    
    [self addSubview:_contentView];
    
    [self sendSubviewToBack:_contentView];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    _contentView.backgroundColor = backgroundColor;
}

- (UIColor *)backgroundColor { return _contentView.backgroundColor; }

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    _contentView.image = backgroundImage;
}

- (UIImage *)backgroundImage { return _contentView.image; }

- (void)setTitle:(NSString *)title
{
    if ( !_titleLabel ) {
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 44,
                                                                CGRectGetWidth([[UIScreen mainScreen] bounds]),
                                                                44)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:_titleLabel];
        [_titleLabel release];
    }
    
    _titleLabel.text = title;
}

- (NSString *)title { return _titleLabel.text; }

- (UILabel *)titleLabel { return _titleLabel; }

- (void)setTitleView:(UIView *)titleView
{
    [_titleView removeFromSuperview];
    
    if ( _titleView != titleView ) {
        [_titleView release];
        _titleView = [titleView retain];
    }
    
    if ( _titleView ) {
        self.title = nil;
        _titleLabel.hidden = YES;
        
        [self addSubview:_titleView];
    }
}

- (void)setLeftButton:(UIButton *)leftButton
{
    [_leftButton removeFromSuperview];
    
    if ( _leftButton != leftButton ) {
        [_leftButton release];
        _leftButton = [leftButton retain];
    }
    
    if ( _leftButton ) {
        [self addSubview:_leftButton];
    }
}

- (void)setRightButton:(UIButton *)rightButton
{
    [_rightButton removeFromSuperview];
    
    if ( _rightButton != rightButton ) {
        [_rightButton release];
        _rightButton = [rightButton retain];
    }
    
    if ( _rightButton ) {
        [self addSubview:_rightButton];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _titleView.height = MIN(_titleView.height, 44);
    
    if ( _titleView.height <= 0 ) {
        _titleView.height = 30;
    }
    
    _titleView.center = CGPointMake(self.width / 2, self.height - 44 + 22);
    
    _leftButton.height = MIN(_leftButton.height, 44);
    if ( _leftButton.height <= 0 ) {
        _leftButton.height = 30;
    }
    
    _leftButton.center = CGPointMake(15 + _leftButton.width / 2, self.height - 44 + 22 );
    
    _rightButton.height = MIN(_rightButton.height, 44);
    if ( _rightButton.height <= 0 ) {
        _rightButton.height = 30;
    }
    
    _rightButton.center = CGPointMake(self.width - 15 - _rightButton.width / 2, self.height - 44 + 22 );
    
}

- (void)dealloc
{
    [_leftButton release];
    [_rightButton release];
    [_titleView release];
    
    [super dealloc];
}

@end
