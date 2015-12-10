//
//  UserProfileView.m
//  BayLe
//
//  Created by tangwei1 on 15/12/10.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import "UserProfileView.h"
#import "Defines.h"

@implementation UserProfileView
{
    UIImageView* _avatarView;
    UILabel*     _nicknameLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] ) {
        _avatarView = AWCreateImageView(nil);
        [self addSubview:_avatarView];
        _avatarView.frame = CGRectMake(0, 0, AWFullScreenWidth() * 0.2, AWFullScreenWidth() * 0.2);
        _avatarView.backgroundColor = MAIN_CONTENT_BG_COLOR;
        
        _avatarView.layer.cornerRadius = _avatarView.height / 2;
        _avatarView.clipsToBounds = YES;
        
        _nicknameLabel = AWCreateLabel(CGRectZero,
                                       nil,
                                       NSTextAlignmentCenter,
                                       AWCustomFont(CUSTOM_FONT_NAME, 16),
                                       NAVBAR_HIGHLIGHT_TEXT_COLOR);
        [self addSubview:_nicknameLabel];
    }
    return self;
}

- (void)setUser:(User *)user
{
    [_user release];
    _user = [user retain];
    
    [_avatarView setImageWithURL:[NSURL URLWithString:user.avatar]];
    
    if ( [[UserManager sharedInstance] isLogin] ) {
        _nicknameLabel.text = user.nickname;
    } else {
        _nicknameLabel.text = @"立即登录";
    }
    
    [_nicknameLabel sizeToFit];
    
    CGFloat width = MAX(_avatarView.width, _nicknameLabel.width);
    CGFloat height = _avatarView.height + _nicknameLabel.height + 5;
    
    self.frame = CGRectMake(0, 0, width, height);
    self.center = CGPointMake(self.superview.width / 2, self.superview.height / 2);
    
    _avatarView.center = CGPointMake(self.width / 2, _avatarView.height / 2);
    _nicknameLabel.center = CGPointMake(self.width / 2, self.height - _nicknameLabel.height / 2);
}

- (void)dealloc
{
    [_user release];
    
    [super dealloc];
}

@end
