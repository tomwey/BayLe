//
//  SimpleItemView.m
//  BayLe
//
//  Created by tangwei1 on 15/11/25.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import "SimpleItemView.h"
#import "Defines.h"

@interface SimpleItemView ()

@property (nonatomic, retain, readonly) UIImageView* iconImageView;
@property (nonatomic, retain, readonly) UILabel*     titleLabel;
@property (nonatomic, retain, readonly) UILabel*     priceLabel;
@property (nonatomic, retain, readonly) UILabel*     distanceLabel;

@end

@implementation SimpleItemView

@synthesize iconImageView = _iconImageView;
@synthesize titleLabel    = _titleLabel;
@synthesize priceLabel    = _priceLabel;
@synthesize distanceLabel = _distanceLabel;

- (void)configData:(id)data
{
    self.backgroundColor = [UIColor whiteColor];
    
    self.iconImageView.image = nil;
    [self.iconImageView setImageWithURL:[NSURL URLWithString:[data objectForKey:@"thumb_image"]]];
    
    self.titleLabel.text = [data objectForKey:@"title"];
    self.priceLabel.text = [data objectForKey:@"fee"];
    
    // 解析距离
    self.distanceLabel.text = LBSDistanceStringBetweenTwoLocations([[LBSManager sharedInstance] currentCLLocation],
                                                                   LBSParseLocationForCoordinate([data objectForKey:@"location"]));
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.iconImageView.frame = CGRectMake(0, 0, self.width, self.width);
    
    if ( self.titleLabel.text ) {
        self.titleLabel.frame = CGRectMake(self.iconImageView.left + 5,
                                           self.iconImageView.bottom,
                                           self.width - 10, TITLE_HEIGHT_FOR_PER_ITEM);
    }
    
    if ( self.priceLabel.text ) {
        self.priceLabel.frame = CGRectMake(self.titleLabel.left, self.titleLabel.bottom - 5,
                                           self.titleLabel.width, PRICE_HEIGHT_FOR_PER_ITEM);
    }
    
    self.distanceLabel.frame = CGRectMake(self.priceLabel.right - 100, self.priceLabel.bottom - 20, 100, 20);
}

- (UIImageView *)iconImageView
{
    if ( !_iconImageView ) {
        _iconImageView = AWCreateImageView(nil);
        [self addSubview:_iconImageView];
        _iconImageView.backgroundColor = MAIN_LIGHT_GRAY_COLOR;
    }
    return _iconImageView;
}

- (UILabel *)titleLabel
{
    if ( !_titleLabel ) {
        _titleLabel = AWCreateLabel(CGRectZero,
                                    nil,
                                    NSTextAlignmentLeft,
                                    AWSystemFontWithSize(14, NO),
                                    MAIN_LIGHT_GRAY_COLOR);
        [self addSubview:_titleLabel];
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (UILabel *)distanceLabel
{
    if ( !_distanceLabel ) {
        _distanceLabel = AWCreateLabel(CGRectZero,
                                       nil,
                                       NSTextAlignmentRight,
                                       AWSystemFontWithSize(10, NO),
                                       MAIN_LIGHT_GRAY_COLOR);
        [self addSubview:_distanceLabel];
    }
    return _distanceLabel;
}

- (UILabel *)priceLabel
{
    if ( !_priceLabel ) {
        _priceLabel = AWCreateLabel(CGRectZero,
                                    nil,
                                    NSTextAlignmentLeft,
                                    AWSystemFontWithSize(15, NO),
                                    MAIN_RED_COLOR);
        [self addSubview:_priceLabel];
    }
    return _priceLabel;
}


@end
