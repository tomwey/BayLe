//
//  ItemCell.m
//  BayLe
//
//  Created by tangwei1 on 15/12/17.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import "ItemCell.h"
#import "Defines.h"

@interface ItemCell ()

@property (nonatomic, retain, readonly) UIImageView* thumbView;

@property (nonatomic, retain, readonly) UILabel* titleLabel;

@property (nonatomic, retain, readonly) UILabel* feeLabel;

@property (nonatomic, retain, readonly) UILabel* placementLabel;
@property (nonatomic, retain, readonly) UILabel* locationLabel;

@property (nonatomic, retain, readonly) UILabel* nicknameLabel;

@property (nonatomic, retain, readonly) UIImageView* avatarView;

@end

#define LEFT_MARGIN           15 // 左间距
#define TOP_MARGIN            8  // 顶部间距
#define AVATAR_HEIGHT         50 // 头像高度
#define TITLE_LABEL_HEIGHT    32 // 标题显示高度
#define LOCATION_LABEL_HEIGHT 25 // 位置显示高度

#define HEIGHT_FACTOR         0.618 // 图片高度与宽度的比例

@implementation ItemCell
{
    UIView* _containerView;
    UIView* _line;
}

@synthesize thumbView = _thumbView,
titleLabel = _titleLabel,
feeLabel = _feeLabel,
avatarView = _avatarView,
placementLabel = _placementLabel,
locationLabel = _locationLabel,
nicknameLabel = _nicknameLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier] ) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _containerView = [[[UIView alloc] init] autorelease];
        [self.contentView addSubview:_containerView];
        _containerView.backgroundColor = [UIColor whiteColor];
        
        _containerView.layer.shadowColor = [[UIColor blackColor] CGColor];
        _containerView.layer.shadowOffset = CGSizeMake(0, 1);
        _containerView.layer.shadowOpacity = .3;
        _containerView.layer.shadowRadius = 1.0;
        
        [self removeBackground];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = self.width - LEFT_MARGIN * 2;
    
    CGFloat imageHeight = width * HEIGHT_FACTOR;
    
    _containerView.frame = CGRectMake(LEFT_MARGIN,
                                      TOP_MARGIN,
                                      width,
                                      TOP_MARGIN + AVATAR_HEIGHT + TOP_MARGIN + imageHeight + TITLE_LABEL_HEIGHT + LOCATION_LABEL_HEIGHT);
    
    self.nicknameLabel.frame = CGRectMake(0, 0, _containerView.width - self.avatarView.width - 30, 37);
    self.nicknameLabel.center = CGPointMake(self.avatarView.right + TOP_MARGIN + self.nicknameLabel.width / 2, self.avatarView.center.y);
    
    self.feeLabel.center = CGPointMake(_containerView.width - TOP_MARGIN - self.feeLabel.width / 2, self.avatarView.center.y);
    
    self.thumbView.frame = CGRectMake(0, self.avatarView.bottom + TOP_MARGIN, width, imageHeight);
    
    self.titleLabel.frame = CGRectMake(self.avatarView.left, self.thumbView.bottom,
                                       _containerView.width - self.avatarView.left * 2,
                                       TITLE_LABEL_HEIGHT);
    
    self.placementLabel.frame = self.titleLabel.frame;
    self.placementLabel.height = LOCATION_LABEL_HEIGHT;
    self.placementLabel.top = self.titleLabel.bottom;
    
    self.locationLabel.frame = self.placementLabel.frame;
    self.locationLabel.width = 120;
    self.locationLabel.left = _containerView.width - self.placementLabel.left - self.locationLabel.width;
}

- (void)configData:(id)data
{
    self.thumbView.image = nil;
    [self.thumbView setImageWithURL:[NSURL URLWithString:[data objectForKey:@"thumb_image"]]];
    
    self.avatarView.image = nil;
    [self.avatarView setImageWithURL:[NSURL URLWithString:@""]];
    
    self.nicknameLabel.text = @"tomwey";
    
    self.titleLabel.text = [data objectForKey:@"title"];
    
    NSString* fee = [data objectForKey:@"fee"];
    fee = [fee substringToIndex:[fee length] - 3];
    self.feeLabel.text = [NSString stringWithFormat:@"￥%@", fee];
    [self.feeLabel sizeToFit];
    
    self.placementLabel.text = [data objectForKey:@"placement"];
    
    self.locationLabel.text =
    LBSDistanceStringBetweenTwoLocations([[LBSManager sharedInstance] currentCLLocation],
                                        LBSParseLocationForCoordinate([data objectForKey:@"location"]));
    
//    [self.contentView bringSubviewToFront:_line];
}

+ (CGFloat)cellRowHeight
{
    CGFloat imageHeight = ( AWFullScreenWidth() - LEFT_MARGIN * 2 ) * HEIGHT_FACTOR;
    return imageHeight + TITLE_LABEL_HEIGHT + LOCATION_LABEL_HEIGHT + AVATAR_HEIGHT + TOP_MARGIN * 2 + TOP_MARGIN;
}

- (UIImageView *)thumbView
{
    if ( !_thumbView ) {
        _thumbView = AWCreateImageView(nil);
        [_containerView addSubview:_thumbView];
        _thumbView.backgroundColor = MAIN_SUBTITLE_TEXT_COLOR;
    }
    
    return _thumbView;
}

- (UIImageView *)avatarView
{
    if ( !_avatarView ) {
        _avatarView = AWCreateImageView(nil);
        [_containerView addSubview:_avatarView];
        _avatarView.backgroundColor = MAIN_SUBTITLE_TEXT_COLOR;
        
        _avatarView.frame = CGRectMake(0, 0, AVATAR_HEIGHT, AVATAR_HEIGHT);
        _avatarView.position = CGPointMake(TOP_MARGIN, TOP_MARGIN);
        
        _avatarView.layer.cornerRadius = _avatarView.height / 2;
        _avatarView.clipsToBounds = YES;
    }
    
    return _avatarView;
}

- (UILabel *)titleLabel
{
    if ( !_titleLabel ) {
        _titleLabel = AWCreateLabel(CGRectZero,
                                    nil,
                                    NSTextAlignmentLeft,
                                    AWCustomFont(CUSTOM_FONT_NAME,
                                                 15),
                                    MAIN_TITLE_TEXT_COLOR);
        [_containerView addSubview:_titleLabel];
    }
    
    return _titleLabel;
}

- (UILabel *)nicknameLabel
{
    if ( !_nicknameLabel ) {
        _nicknameLabel = AWCreateLabel(CGRectZero,
                                    nil,
                                    NSTextAlignmentLeft,
                                    AWCustomFont(CUSTOM_FONT_NAME,
                                                 15),
                                    MAIN_TITLE_TEXT_COLOR);
        [_containerView addSubview:_nicknameLabel];
    }
    
    return _nicknameLabel;
}

- (UILabel *)feeLabel
{
    if ( !_feeLabel ) {
        _feeLabel = AWCreateLabel(CGRectZero,
                                  nil,
                                  NSTextAlignmentCenter,
                                  AWCustomFont(CUSTOM_FONT_NAME, 16),
                                  MAIN_RED_COLOR);
        [_containerView addSubview:_feeLabel];
    }
    
    return _feeLabel;
}

- (UILabel *)placementLabel
{
    if ( !_placementLabel ) {
        _placementLabel = AWCreateLabel(CGRectZero,
                                    nil,
                                    NSTextAlignmentLeft,
                                    AWCustomFont(CUSTOM_FONT_NAME,
                                                 13),
                                    MAIN_SUBTITLE_TEXT_COLOR);
        [_containerView addSubview:_placementLabel];
    }
    
    return _placementLabel;
}

- (UILabel *)locationLabel
{
    if ( !_locationLabel ) {
        _locationLabel = AWCreateLabel(CGRectZero,
                                    nil,
                                    NSTextAlignmentRight,
                                    AWCustomFont(CUSTOM_FONT_NAME,
                                                 13),
                                    MAIN_SUBTITLE_TEXT_COLOR);
        [_containerView addSubview:_locationLabel];
        
    }
    
    return _locationLabel;
}

@end
