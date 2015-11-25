//
//  ItemCollectionCell.m
//  BayLe
//
//  Created by tangwei1 on 15/11/25.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import "ItemCollectionCell.h"
#import "Defines.h"

@interface ItemCollectionCell ()

@property (nonatomic, retain, readonly) UIImageView* iconImageView;
@property (nonatomic, retain, readonly) UILabel*     titleLabel;
@property (nonatomic, retain, readonly) UILabel*     priceLabel;
@property (nonatomic, retain, readonly) UILabel*     distanceLabel;

@property (nonatomic, retain, readonly) UIView*      containerView;

@end

@implementation ItemCollectionCell

@synthesize iconImageView = _iconImageView;
@synthesize titleLabel    = _titleLabel;
@synthesize priceLabel    = _priceLabel;
@synthesize distanceLabel = _distanceLabel;
@synthesize containerView = _containerView;

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] ) {
        NSLog(@"xxxxxxxxx");
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)setData:(id)data
{
    if ( _data == data ) {
        return;
    }
    
    [_data release];
    _data = [data retain];
    
    [self populateData];
}

- (UIView *)containerView
{
    if ( !_containerView ) {
        _containerView = [[[UIView alloc] init] autorelease];
        [self.contentView addSubview:_containerView];
        _containerView.backgroundColor = [UIColor whiteColor];
    }
    return _containerView;
}

- (void)populateData
{
    self.iconImageView.image = nil;
    [self.iconImageView setImageWithURL:[NSURL URLWithString:[_data objectForKey:@"thumb_image"]] placeholderImage:nil];
    
    self.titleLabel.text = [_data objectForKey:@"title"];
    
    self.priceLabel.text = [_data objectForKey:@"fee"];
    
    self.distanceLabel.text = @"300m";
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.containerView.frame = CGRectMake(10, 10, self.width - 10, self.height - 10);
    
    self.iconImageView.frame = CGRectMake(0, 0, self.containerView.width, self.containerView.width);
    
    if ( self.titleLabel.text ) {
        self.titleLabel.frame = CGRectMake(5,
                                           self.iconImageView.bottom,
                                           self.width, TITLE_HEIGHT_FOR_PER_ITEM);
//        [self.titleLabel sizeToFit];
    }
    
    if ( self.priceLabel.text ) {
        self.priceLabel.frame = CGRectMake(self.titleLabel.left, self.titleLabel.bottom,
                                           self.titleLabel.width, PRICE_HEIGHT_FOR_PER_ITEM);
    }
    
    self.distanceLabel.frame = CGRectMake(self.width - 120 - self.titleLabel.left, self.priceLabel.bottom - 20, 120, 20);
}

- (UIImageView *)iconImageView
{
    if ( !_iconImageView ) {
        _iconImageView = AWCreateImageView(nil);
        [self.containerView addSubview:_iconImageView];
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
        [self.containerView addSubview:_titleLabel];
//        _titleLabel.numberOfLines = 2;
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
        [self.containerView addSubview:_distanceLabel];
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
        [self.containerView addSubview:_priceLabel];
    }
    return _priceLabel;
}


@end
