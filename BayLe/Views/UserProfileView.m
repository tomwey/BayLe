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
    UILabel*     _balanceLabel; // 余额
    
    id  _target;
    SEL _action;
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
        
        _balanceLabel = AWCreateLabel(CGRectZero,
                                      nil,
                                      NSTextAlignmentCenter,
                                      _nicknameLabel.font,
                                      _nicknameLabel.textColor);
        [self addSubview:_balanceLabel];
        
        [self addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)] autorelease]];
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
        _balanceLabel.text = [NSString stringWithFormat:@"余额:￥%d", user.balance];
    } else {
        _nicknameLabel.text = @"立即登录";
        _balanceLabel.text = nil;
    }
    
    [_nicknameLabel sizeToFit];
    
    CGFloat width = MAX(_avatarView.width, _nicknameLabel.width);
    CGFloat height = _avatarView.height + _nicknameLabel.height + 5;
    
    self.frame = CGRectMake(0, 0, width, height);
    self.center = CGPointMake(self.superview.width / 2, self.superview.height / 2);
    
    _avatarView.center = CGPointMake(self.width / 2, _avatarView.height / 2);
    _nicknameLabel.center = CGPointMake(self.width / 2, self.height - _nicknameLabel.height / 2);
    
    _balanceLabel.frame = _nicknameLabel.frame;
    _balanceLabel.width = 200;
    _balanceLabel.center = _nicknameLabel.center;
    _balanceLabel.top = _nicknameLabel.bottom;
    _balanceLabel.font = AWCustomFont(CUSTOM_FONT_NAME, 14);
}

- (void)addTarget:(id)target action:(SEL)action
{
    _target = target;
    _action = action;
}

- (void)tap
{
    if ( [_target respondsToSelector:_action] ) {
        [_target performSelector:_action withObject:self];
    }
}

- (void)dealloc
{
    [_user release];
    
    [super dealloc];
}

@end
