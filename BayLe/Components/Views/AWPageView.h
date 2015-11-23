//
//  AWPageView.h
//  BayLe
//
//  Created by tangwei1 on 15/11/23.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import <UIKit/UIKit.h>

/*****************************************************************************
 
 *****************************************************************************/
@class AWPageView, AWPageViewCell;
@protocol AWPageViewDataSource <NSObject>

/**
 * 获取总页数
 */
- (NSUInteger)numberOfPages:(AWPageView *)pageView;

/**
 * 获取某个位置的视图
 */
- (AWPageViewCell *)pageView:(AWPageView *)pageView cellAtIndex:(NSInteger)index;

@end

@protocol AWPageViewDelegate;
@interface AWPageView : UIView

/** 设置数据源 */
@property (nonatomic, assign) id <AWPageViewDataSource> dataSource;

/** 设置delegate */
@property (nonatomic, assign) id <AWPageViewDelegate>   delegate;

/**
 * 显示某个位置的视图
 */
- (void)showPageForIndex:(NSInteger)index animated:(BOOL)animated;

/**
 * 获取重用的页面
 */
- (AWPageViewCell *)dequeueReusablePageForIndex:(NSInteger)index;

/** 
 * 刷新数据
 */
- (void)reloadData;

/**
 * 返回某个位置可见的页面
 */
- (AWPageViewCell *)viewAtIndex:(NSInteger)index;

/**
 * 返回可见的页面
 */
- (NSArray *)visiblePages;

@end

@protocol AWPageViewDelegate <NSObject>

@optional

- (void)pageView:(AWPageView *)pageView didShowPage:(AWPageViewCell *)page atIndex:(NSInteger)index;

- (void)pageView:(AWPageView *)pageView didScrollDelta:(CGFloat)dt;

@end

@interface AWPageViewCell : UIView

@property (nonatomic, assign) NSInteger index;

@end
