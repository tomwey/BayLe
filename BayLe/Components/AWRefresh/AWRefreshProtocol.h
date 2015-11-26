//
//  AWRefreshProtocol.h
//  BayLe
//
//  Created by tangwei1 on 15/11/26.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#ifndef AWRefreshProtocol_h
#define AWRefreshProtocol_h

// 定义控件的状态
typedef NS_ENUM(NSInteger, AWRefreshState) {
    AWRefreshStateNormal = 1,     // 正常状态
    AWRefreshStatePulling,        // 正在拖动状态
    AWRefreshStateWillRefreshing, // 即将开始刷新的状态
    AWRefreshStateRefreshing,     // 正在刷新状态
};

@protocol AWRefreshProtocol <NSObject>

/** 开始刷新 */
- (void)beginRefreshing;

/** 完成刷新 */
- (void)endRefreshing;

/** 设置开始刷新的回调 */
@property (nonatomic, copy) void (^beginRefreshingCallback)();

/** 设置开始刷新的回调Target - Action */
@property (nonatomic, assign) id beginRefreshingTarget;
@property (nonatomic, assign) SEL beginRefreshingAction;

/** 设置控件状态 */
- (void)setState:(AWRefreshState)state;
- (AWRefreshState)state;

@end

#endif /* AWRefreshProtocol_h */
