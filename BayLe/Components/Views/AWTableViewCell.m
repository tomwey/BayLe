//
//  AWTableViewCell.m
//  Wallpapers10000+
//
//  Created by tangwei1 on 15/7/17.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import "AWTableViewCell.h"
#import "AWUIUtils.h"

@interface AWTableViewCell ()

@property (nonatomic, retain, readonly) UIView* topLine;
@property (nonatomic, retain, readonly) UIView* bottomLine;

@end

@implementation AWTableViewCell
{
    CGFloat _lineHeight;
}

@synthesize topLine = _topLine;
@synthesize bottomLine = _bottomLine;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier] ) {
        if ( [self respondsToSelector:@selector(setSeparatorInset:)] ) {
            self.separatorInset = UIEdgeInsetsZero;
        }
        
        if ( [self respondsToSelector:@selector(setLayoutMargins:)] ) {
            self.layoutMargins = UIEdgeInsetsZero;
        }
        
        _allowShowBottomLine =
        _allowShowTopLine    = NO;
        
        _lineColor = [AWColorFromRGB(224, 224, 224) retain];
        
        _topLineWidth = _bottomLineWidth = AWFullScreenWidth();
        _lineHeight = AWOSVersionIsLower(8.0) ? 1.0 : 0.5;
    }
    
    return self;
}

- (void)dealloc
{
    [_lineColor release];
    
    [super dealloc];
}

//- (void)setLineColor:(UIColor *)lineColor
//{
//    if ( _lineColor != lineColor ) {
//        [_lineColor release];
//        
//        _lineColor = [lineColor retain];
//        
//        if ( self.allowShowTopLine ) {
//            [self updateTopLine];
//        }
//        
//        if ( self.allowShowBottomLine ) {
//            [self updateBottomLine];
//        }
//    }
//}

- (void)setAllowShowTopLine:(BOOL)allowShowTopLine
{
    _allowShowTopLine = allowShowTopLine;
    self.topLine.hidden = !allowShowTopLine;
    
//    [self updateTopLine];
}

- (void)setAllowShowBottomLine:(BOOL)allowShowBottomLine
{
    _allowShowBottomLine = allowShowBottomLine;
    self.bottomLine.hidden = !allowShowBottomLine;
    
//    [self updateBottomLine];
}

//- (void)setTopLineWidth:(CGFloat)topLineWidth
//{
//    _topLineWidth = topLineWidth;
//    
//    [self updateTopLine];
//}
//
//- (void)setBottomLineWidth:(CGFloat)bottomLineWidth
//{
//    _bottomLineWidth = bottomLineWidth;
//    
//    [self updateBottomLine];
//}

- (void)updateTopLine
{
    if ( _allowShowTopLine ) {
        self.topLine.backgroundColor = _lineColor;
        [self.contentView bringSubviewToFront:self.topLine];
        self.topLine.frame = CGRectMake(CGRectGetWidth(self.bounds) - _topLineWidth, 0, _topLineWidth, _lineHeight);
    }
}

- (void)updateBottomLine
{
    if ( _allowShowBottomLine ) {
        self.bottomLine.backgroundColor = _lineColor;
        [self.contentView bringSubviewToFront:self.bottomLine];
        self.bottomLine.frame = CGRectMake(CGRectGetWidth(self.bounds) - _bottomLineWidth, CGRectGetHeight(self.bounds) - _lineHeight, _bottomLineWidth, _lineHeight);
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self updateTopLine];
    [self updateBottomLine];
}

- (UIView *)topLine
{
    if ( !_topLine ) {
        CGRect frame = CGRectMake(0, 0, AWFullScreenWidth(), 0.3);
        _topLine = [[UIView alloc] initWithFrame:frame];
        [self.contentView addSubview:_topLine];
        [_topLine release];
    }
    
    return _topLine;
}

- (UIView *)bottomLine
{
    if ( !_bottomLine ) {
        CGRect frame = CGRectMake(0, 0, AWFullScreenWidth(), 0.3);
        _bottomLine = [[UIView alloc] initWithFrame:frame];
        [self.contentView addSubview:_bottomLine];
        [_bottomLine release];
    }
    
    return _bottomLine;
}

@end
