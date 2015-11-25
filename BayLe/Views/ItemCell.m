//
//  ItemCell.m
//  BayLe
//
//  Created by tangwei1 on 15/11/25.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import "ItemCell.h"
#import "Defines.h"

@interface ItemCell ()

@property (nonatomic, retain, readonly) UIImageView* iconImageView;
@property (nonatomic, retain, readonly) UILabel*     titleLabel;
@property (nonatomic, retain, readonly) UILabel*     priceLabel;
@property (nonatomic, retain, readonly) UILabel*     distanceLabel;

@end

@implementation ItemCell

@synthesize iconImageView = _iconImageView;
@synthesize titleLabel    = _titleLabel;
@synthesize priceLabel    = _priceLabel;
@synthesize distanceLabel = _distanceLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier] ) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
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
    
    self.iconImageView.frame = CGRectMake(10, self.height / 2 - 68 / 2, 68, 68);
    
    if ( self.titleLabel.text ) {
        self.titleLabel.frame = CGRectMake(self.iconImageView.right + 5,
                                           self.iconImageView.top,
                                           AWFullScreenWidth() - self.iconImageView.right - 5 - self.iconImageView.left, 40);
        [self.titleLabel sizeToFit];
    }
    
    if ( self.priceLabel.text ) {
        self.priceLabel.frame = CGRectMake(self.titleLabel.left, self.iconImageView.bottom - 20,
                                           AWFullScreenWidth() - self.iconImageView.right - 5,
                                           20);
    }
    
    self.distanceLabel.frame = CGRectMake(AWFullScreenWidth() - 200 - self.iconImageView.left, self.priceLabel.top, 200, 20);
}

- (UIImageView *)iconImageView
{
    if ( !_iconImageView ) {
        _iconImageView = AWCreateImageView(nil);
        [self.contentView addSubview:_iconImageView];
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
                                    [UIColor blackColor]);
        [self.contentView addSubview:_titleLabel];
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
        [self.contentView addSubview:_distanceLabel];
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
        [self.contentView addSubview:_priceLabel];
    }
    return _priceLabel;
}

@end
