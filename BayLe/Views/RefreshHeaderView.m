//
//  RefreshHeaderView.m
//  BayLe
//
//  Created by tomwey on 11/29/15.
//  Copyright (c) 2015 tangwei1. All rights reserved.
//

#import "RefreshHeaderView.h"
#import "Defines.h"

@implementation RefreshHeaderView
{
    UIImageView* _loadingView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] ) {
        _loadingView = AWCreateImageView(nil);
        _loadingView.image = [UIImage imageNamed:@"loading_spinner_house_00000"];
        [_loadingView sizeToFit];
        [self addSubview:_loadingView];
        _loadingView.tintColor = MAIN_RED_COLOR;
        
        NSMutableArray* animationImages = [NSMutableArray array];
        for (int i=0; i<17; i++) {
            NSString* imageName = [NSString stringWithFormat:@"loading_spinner_house_%05d", i];
            UIImage* image = [UIImage imageNamed:imageName];
            [animationImages addObject:image];
        }
        
        _loadingView.animationImages = animationImages;
        _loadingView.animationDuration = AWRefreshAnimationDuration;
        _loadingView.animationRepeatCount = NSIntegerMax;
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _loadingView.center = CGPointMake(self.width / 2, self.height / 2);
}

- (AWRefreshMode)refreshMode
{
    return AWRefreshModePulldownRefresh;
}

- (void)releaseToRefresh
{
    NSLog(@"松开刷新...");
    _loadingView.transform = CGAffineTransformIdentity;
    [_loadingView startAnimating];
}

- (void)updateOffset:(CGFloat)dty
{
    NSLog(@"update: %f", dty);
    _loadingView.transform = CGAffineTransformMakeRotation(dty * 2);
}

- (void)backToNormalState
{
    NSLog(@"回到正常状态...");
    [_loadingView stopAnimating];
}

- (void)changeToRefresh
{
    NSLog(@"开始刷新...");
    [_loadingView startAnimating];
}

@end
