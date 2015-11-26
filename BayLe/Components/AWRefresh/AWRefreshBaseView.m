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
}
@property (nonatomic, assign, readwrite) UIScrollView* scrollView;
@property (nonatomic, assign, readwrite) UIEdgeInsets scrollViewOriginContentInset;
@property (nonatomic, assign, readwrite) AWRefreshState state;

@end

#define msgSend(...) ((void (*)(void *, SEL, UIView *))objc_msgSend)(__VA_ARGS__)

const CGFloat AWRefreshAnimationDuration = 0.25;

static NSString * const AWRefreshContentOffset = @"AWRefreshContentOffset";
static NSString * const AWRefreshContentSize = @"AWRefreshContentSize";

@implementation AWRefreshBaseView

@synthesize state = _state;

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] ) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor  = [UIColor clearColor];
        
        // 设置默认状态
        self.state = AWRefreshStateNormal;
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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.state = AWRefreshStateNormal;
    });
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
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context
{
    if ( self.userInteractionEnabled == NO || self.alpha <= 0.0001 || self.hidden ) {
        return;
    }
    
    if ( self.state == AWRefreshStateRefreshing ) return;
    
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
            
            if (self.scrollView.isDragging) {
                // 普通 和 即将刷新 的临界点
                CGFloat normal2pullingOffsetY = happenOffsetY - CGRectGetHeight(self.frame);
                
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
            if ( self.state == AWRefreshStateRefreshing ) {
//                [self willEndRefreshing];
            }
        }
            break;
        case AWRefreshStatePulling:
        {
            [self releaseToRefresh];
        }
            break;
        case AWRefreshStateRefreshing:
        {
            [self invokeRefresh];
            
            // 调用钩子方法
            [self willBeginRefreshing];
            
            if ( self.refreshMode == AWRefreshModePulldownRefresh ) {
                [UIView animateWithDuration:AWRefreshAnimationDuration animations:^{
                    CGFloat top = self.scrollViewOriginContentInset.top + CGRectGetHeight(self.frame);
                    
                    UIEdgeInsets inset = self.scrollView.contentInset;
                    inset.top = top;
                    self.scrollView.contentInset = inset;
                    
                    CGPoint offset = self.scrollView.contentOffset;
                    offset.y = - top;
                    self.scrollView.contentOffset = offset;
                }];
            } else {
                CGFloat bottom = CGRectGetHeight(self.frame) + self.scrollViewOriginContentInset.bottom;
                CGFloat deltaH = [self heightForContentBreakView];
                if (deltaH < 0) { // 如果内容高度小于view的高度
                    bottom -= deltaH;
                }
                
                UIEdgeInsets inset = self.scrollView.contentInset;
                inset.bottom = bottom;
                self.scrollView.contentInset = inset;
            }
        }
            break;
            
        default:
            break;
    }
    
    _state = state;
}

- (void)didPullControl
{
    
}

- (void)willBeginRefreshing
{
    
}

- (void)didEndRefreshing
{
    
}

/** 子类重写此方法，返回正确的拖动刷新模式 */
- (AWRefreshMode)refreshMode
{
    [NSException raise:@"AWRefreshOverrideException" format:@"子类必须重写- (AWRefreshMode)refreshMode"];
    return AWRefreshModeUnKnown;
}

@end
