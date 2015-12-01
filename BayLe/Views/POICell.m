//
//  POICell.m
//  BayLe
//
//  Created by tangwei1 on 15/12/1.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import "POICell.h"
#import "Defines.h"

@interface POICell ()

@property (nonatomic, retain, readonly) UILabel* titleLabel;
@property (nonatomic, retain, readonly) UILabel* subtitleLabel;

@end

@implementation POICell

@synthesize titleLabel = _titleLabel;
@synthesize subtitleLabel = _subtitleLabel;

- (UILabel *)titleLabel
{
    if ( !_titleLabel ) {
        _titleLabel = AWCreateLabel(CGRectZero, nil, NSTextAlignmentLeft, AWSystemFontWithSize(15, YES),
                                    [UIColor blackColor]);
        [self.contentView addSubview:_titleLabel];
    }
    
    return _titleLabel;
}

- (UILabel *)subtitleLabel
{
    if ( !_subtitleLabel ) {
        _subtitleLabel = AWCreateLabel(CGRectZero, nil, NSTextAlignmentLeft, AWSystemFontWithSize(14, NO),
                                       MAIN_LIGHT_GRAY_COLOR);
        [self.contentView addSubview:_subtitleLabel];
    }
    
    return _subtitleLabel;
}

- (void)configData:(id)data
{
    self.titleLabel.text = [data objectForKey:@"title"];
    self.subtitleLabel.text = [data objectForKey:@"address"];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.frame = CGRectMake(15, 5, self.width - 30, 28);
    
    self.subtitleLabel.frame = CGRectMake(self.titleLabel.left, self.titleLabel.bottom - 5, self.titleLabel.width, 28);
}

@end
