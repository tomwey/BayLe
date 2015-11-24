//
//  LoadEmptyOrErrorHandle.h
//  BayLe
//
//  Created by tangwei1 on 15/11/24.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import <UIKit/UIKit.h>

/*************************************************
 UITableView中数据加载失败或者数据为空的处理类
 *************************************************/

@protocol ReloadDataProtocol;
@interface UITableView (LoadEmptyOrErrorHandle)

/** 设置点击屏幕的回调delegate */
@property (nonatomic, assign) id <ReloadDataProtocol> reloadCallback;

/** 显示吐司提示，支持多行显示 */
- (void)showToast:(NSString *)message;

/**
 * 显示纯文本提示
 * @param message 提示文字
 */
- (void)showMessage:(NSString *)message;

/**
 * 显示图片提示
 * 提示图片
 */
- (void)showImage:(NSString *)image;

@end

@protocol ReloadDataProtocol <NSObject>

@optional
/** 点击屏幕任意地方，重新加载数据 */
- (void)reloadDataForTableView;

@end