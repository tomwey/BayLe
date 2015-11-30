//
//  AWRefreshBaseView.m
//  BayLe
//
//  Created by tangwei1 on 15/11/26.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import "AWRefreshBaseView.h"
#import <objc/message.h>

@interface AWRefreshBaseView ()
{
//    AWRefreshState _state;
    CGFloat _lastOffsetY;
}
@property (nonatomic, assign, readwrite) UIScrollView* scrollView;
@property (nonatomic, assign, readwrite) UIEdgeInsets scrollViewOriginContentInset;
@property (nonatomic, assign, readwrite) AWRefreshState state;

@end

#define msgSend(...) ((void (*)(void *, SEL, UIView *))objc_msgSend)(__VA_ARGS__)

const CGFloat AWRefreshAnimationDuration = 0.25;

static NSString * const AWRefreshContentOffset = @"contentOffset";
static NSString * const AWRefreshContentSize = @"contentSize";

@implementation AWRefreshBaseView

@synthesize state = _state;

- (instancetype)initWithFrame:(CGRect)frame
{
    frame.size.height = 64.0;
    if ( self = [super initWithFrame:frame] ) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor  = [UIColor clearColor];
        
        // 设置默认状态
        _state = AWRefreshStateNormal;
        
        _lastOffsetY = 0.0;
    }
    return self;
}

- (void)dealloc
{
    self.beginRefreshingCallback = nil;
    [super dealloc];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    [self.superview removeObserver:self forKeyPath:AWRefreshContentOffset context:nil];
    
    // 上拉加载更多还需要观察contentSize改变
    if ( self.refreshMode == AWRefreshModePullupLoadMore ) {
        [self.superview removeObserver:self forKeyPath:AWRefreshContentSize context:nil];
    }
    
    if ( newSuperview ) {
        [newSuperview addObserver:self forKeyPath:AWRefreshContentOffset options:NSKeyValueObservingOptionNew context:nil];
        
        self.scrollView = (UIScrollView *)newSuperview;
        
        self.scrollViewOriginContentInset = self.scrollView.contentInset;
        
        CGRect frame = self.frame;
        frame.size.width = CGRectGetWidth(newSuperview.frame);
        frame.origin.x = 0;
        
        if ( self.refreshMode == AWRefreshModePullupLoadMore ) {
            [newSuperview addObserver:self forKeyPath:AWRefreshContentSize options:NSKeyValueObservingOptionNew context:nil];
            
            // 内容的高度
            CGFloat contentHeight = self.scrollView.contentSize.height;
            // 表格的高度
            CGFloat scrollHeight = CGRectGetHeight(self.scrollView.frame) - self.scrollViewOriginContentInset.top - self.scrollViewOriginContentInset.bottom;
            // 设置位置和尺寸
            frame.origin.y = MAX(contentHeight, scrollHeight);
        }
        self.frame = frame;
    }
    
}

/** 开始刷新 */
- (void)beginRefreshing
{
    if ( self.state == AWRefreshStateRefreshing ) {
        [self invokeRefresh];
    } else {
        self.state = AWRefreshStateRefreshing;
//        if ( self.window ) {
//            self.state = AWRefreshStateRefreshing;
//        } else {
//            _state = AWRefreshStateRefreshing;
////            [super setNeedsDisplay];
//        }
    }
}

/** 完成刷新 */
- (void)endRefreshing
{
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(AWRefreshAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    self.state = AWRefreshStateNormal;
//    [self handleState];
//    });
}

- (BOOL)isRefreshing
{
    return self.state == AWRefreshStateRefreshing;
}

- (void)invokeRefresh
{
    // 真正回调刷新
    if ( self.beginRefreshingCallback ) {
        self.beginRefreshingCallback();
    } else if ( [self.beginRefreshingTarget respondsToSelector:self.beginRefreshingAction] ) {
        msgSend(self.beginRefreshingTarget, self.beginRefreshingAction, self);
    }
}

#pragma mark 获得scrollView的内容 超出 view 的高度
- (CGFloat)heightForContentBreakView
{
    CGFloat h = self.scrollView.frame.size.height - self.scrollViewOriginContentInset.bottom - self.scrollViewOriginContentInset.top;
    return self.scrollView.contentSize.height - h;
}

- (CGFloat)happenOffsetY
{
    CGFloat deltaH = [self heightForContentBreakView];
    if (deltaH > 0) {
        return deltaH - self.scrollViewOriginContentInset.top;
    } else {
        return - self.scrollViewOriginContentInset.top;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ( self.userInteractionEnabled == NO || self.alpha <= 0.0001 || self.hidden ) {
        return;
    }
    
//    NSLog(@"offsetY: %f", self.scrollView.contentOffset.y);
    
//    CGFloat deltaY = self.scrollView.contentOffset.y - _lastOffsetY;
    
    if ( self.state == AWRefreshStateRefreshing ) {
        CGFloat currentOffsetY = self.scrollView.contentOffset.y;
//        NSLog(@"offsetY: %f", currentOffsetY);
        
        CGFloat dt = currentOffsetY + CGRectGetHeight(self.frame);
//        NSLog(@"dt: %f", dt);
        if ( dt >= 0 ) {
//            [UIView animateWithDuration:AWRefreshAnimationDuration animations:^{
//                self.scrollView.contentInset = UIEdgeInsetsMake(CGRectGetHeight(self.frame) - dt, 0, 0, 0);
//            }];
        }
        
        return;
    }
    
    if ( self.refreshMode == AWRefreshModePullupLoadMore ) {
        // 加载更多
        if ( [keyPath isEqualToString:AWRefreshContentSize] ) {
            CGRect frame = self.frame;
            
            // 内容的高度
            CGFloat contentHeight = self.scrollView.contentSize.height;
            // 表格的高度
            CGFloat scrollHeight = CGRectGetHeight(self.scrollView.frame) - self.scrollViewOriginContentInset.top - self.scrollViewOriginContentInset.bottom;
            // 设置位置和尺寸
            frame.origin.y = MAX(contentHeight, scrollHeight);
            
            self.frame = frame;
        } else if ( [AWRefreshContentOffset isEqualToString:keyPath] ) {
            // 当前的contentOffset
            CGFloat currentOffsetY = self.scrollView.contentOffset.y;
            // 尾部控件刚好出现的offsetY
            CGFloat happenOffsetY = [self happenOffsetY];
            
            // 如果是向下滚动到看不见尾部控件，直接返回
            if (currentOffsetY <= happenOffsetY) return;
            
            if (self.scrollView.isDragging) {
                // 普通 和 即将刷新 的临界点
                CGFloat normal2pullingOffsetY = happenOffsetY + CGRectGetHeight(self.frame);
                
                if (self.state == AWRefreshStateNormal && currentOffsetY > normal2pullingOffsetY) {
                    // 转为即将刷新状态
                    self.state = AWRefreshStatePulling;
                } else if (self.state == AWRefreshStatePulling && currentOffsetY <= normal2pullingOffsetY) {
                    // 转为普通状态
                    self.state = AWRefreshStateNormal;
                }
            } else if (self.state == AWRefreshStatePulling) {// 即将刷新 && 手松开
                // 开始刷新
                self.state = AWRefreshStateRefreshing;
            }
        }
    } else {
        // 下拉刷新
        if ( [keyPath isEqualToString:AWRefreshContentOffset] ) {
            // 当前的contentOffset
            CGFloat currentOffsetY = self.scrollView.contentOffset.y;

            // 头部控件刚好出现的offsetY
            CGFloat happenOffsetY = - self.scrollViewOriginContentInset.top;
            
            // 如果是向上滚动到看不见头部控件，直接返回
            if (currentOffsetY >= happenOffsetY) return;
            
            // 普通 和 即将刷新 的临界点
            if (self.scrollView.isDragging) {
                CGFloat normal2pullingOffsetY = happenOffsetY - CGRectGetHeight(self.frame);
                
                [self updateOffset:currentOffsetY / normal2pullingOffsetY];
                
                if (self.state == AWRefreshStateNormal && currentOffsetY < normal2pullingOffsetY) {
                    // 转为即将刷新状态
                    self.state = AWRefreshStatePulling;
                } else if (self.state == AWRefreshStatePulling && currentOffsetY >= normal2pullingOffsetY) {
                    // 转为普通状态
                    self.state = AWRefreshStateNormal;
                }
            } else if (self.state == AWRefreshStatePulling) {// 即将刷新 && 手松开
                // 开始刷新
                self.state = AWRefreshStateRefreshing;
            }
        }
    }
}

/////////////////////////////////////////////////////////////////
#pragma mark - 下面的方法需要子类重写
/////////////////////////////////////////////////////////////////
/** 设置控件状态，子类需重写下面的方法，来实现相应的功能 */
- (void)setState:(AWRefreshState)state
{
    // 保存当前的contentInset
    if ( self.state != AWRefreshStateRefreshing ) {
        self.scrollViewOriginContentInset = self.scrollView.contentInset;
    }
    
    // 状态一样不处理
    if ( self.state == state ) {
        return;
    }
    
    switch (state) {
        case AWRefreshStateNormal:
        {
            [self backToNormalState];
            if ( self.state == AWRefreshStateRefreshing ) {
                
                _state = AWRefreshStatePulling;
                [UIView animateWithDuration:AWRefreshAnimationDuration animations:^{
                    UIEdgeInsets inset = self.scrollView.contentInset;
                    inset.top -= CGRectGetHeight(self.frame);
                    self.scrollView.contentInset = inset;
                } completion:^(BOOL finished) {
                    self.state = AWRefreshStateNormal;
                }];
            } else {
//                NSLog(@"默认状态");
                // self.state == AWRefreshStatePulling;
//                NSLog(@"即将回到正常状态");
//                _state = state;
            }
        }
            break;
        case AWRefreshStatePulling:
        {
//            NSLog(@"松开即将刷新");
            [self releaseToRefresh];
//            _state = state;
        }
            break;
        case AWRefreshStateRefreshing:
        {
//            NSLog(@"开始刷新状态");
            [self invokeRefresh];
            
            _state = state;
            
            // 调用钩子方法
            [self changeToRefresh];
            
//            __block UIEdgeInsets contentInset = self.scrollView.contentInset;
            
//            self.scrollView.contentInset = UIEdgeInsetsMake(- self.scrollView.contentOffset.y, 0, 0, 0);
            
//            NSLog(@"top: %f", self.scrollView.contentInset.top);
            
//            if ( self.refreshMode == AWRefreshModePulldownRefresh ) {
                [UIView animateWithDuration:AWRefreshAnimationDuration animations:^{
                    CGFloat top = self.scrollViewOriginContentInset.top + CGRectGetHeight(self.frame);
                    self.scrollView.contentInset = UIEdgeInsetsMake(top, 0, 0, 0);

                    CGPoint offset = self.scrollView.contentOffset;
                    offset.y = - top;
                    self.scrollView.contentOffset = offset;
                }];
//            } else {
//                CGFloat bottom = CGRectGetHeight(self.frame) + self.scrollViewOriginContentInset.bottom;
//                CGFloat deltaH = [self heightForContentBreakView];
//                if (deltaH < 0) { // 如果内容高度小于view的高度
//                    bottom -= deltaH;
//                }
//                
//                UIEdgeInsets inset = self.scrollView.contentInset;
//                inset.bottom = bottom;
//                self.scrollView.contentInset = inset;
//            }
        }
            break;
            
        default:
            break;
    }
    
    _state = state;
}

- (void)releaseToRefresh
{
    
}

- (void)changeToRefresh
{
    
}

- (void)didEndRefreshing
{
    
}

- (void)updateOffset:(CGFloat)dty
{
    
}

- (void)backToNormalState
{
    
}

/** 子类重写此方法，返回正确的拖动刷新模式 */
- (AWRefreshMode)refreshMode
{
    [NSException raise:@"AWRefreshOverrideException" format:@"子类必须重写- (AWRefreshMode)refreshMode"];
    return AWRefreshModeUnKnown;
}

@end
