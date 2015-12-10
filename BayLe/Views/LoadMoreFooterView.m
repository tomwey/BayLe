//
//  LoadMoreFooterView.m
//  BayLe
//
//  Created by tangwei1 on 15/12/10.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import "LoadMoreFooterView.h"
#import "Defines.h"

@implementation LoadMoreFooterView
{
    UILabel* _refreshLabel;
    UIActivityIndicatorView* _spinner;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] ) {
        _refreshLabel = AWCreateLabel(CGRectZero,
                                      nil,
                                      NSTextAlignmentCenter,
                                      AWSystemFontWithSize(15, YES),
                                      [UIColor blackColor]);
        [self addSubview:_refreshLabel];
        
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:_spinner];
        [_spinner release];
        
        _spinner.hidesWhenStopped = YES;
    }
    return self;
}

- (void)originState
{
    _refreshLabel.text = @"上拉加载更多";
}

- (void)backToNormalState
{
    _refreshLabel.text = @"上拉加载更多";
    
    [_spinner stopAnimating];
}

- (void)releaseToRefresh
{
    _refreshLabel.text = @"松开加载更多";
    
    [_spinner stopAnimating];
}

- (void)changeToRefresh
{
    _refreshLabel.text = @"加载中...";
    
    CGSize size = [_refreshLabel textSizeForConstrainedSize:CGSizeMake(AWFullScreenWidth(), 1000)];
    
    _spinner.center = CGPointMake(self.width / 2 - size.width / 2 - 5 - _spinner.width / 2, _refreshLabel.center.y);
    
    [_spinner startAnimating];
}

- (AWRefreshMode)refreshMode
{
    return AWRefreshModePullUpLoadMore;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _refreshLabel.frame = self.bounds;
}

@end
