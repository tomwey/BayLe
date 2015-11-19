//
//  UITableViewAdditions.h
//  Wallpapers10000+
//
//  Created by tangwei1 on 15/8/6.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (EmptyAdditions)

/**
 * 当表为空数据时，显示一句文字提示
 */
@property (nonatomic, copy) NSString* blankMessage;

/**
 * 当表为空数据时，显示一张图片提示
 */
@property (nonatomic, retain) UIImage* blankImage;

/**
 * 返回空提示UILabel
 * 可能为nil
 */
@property (nonatomic, retain, readonly) UILabel* blankLabel;

/**
 * 返回空提示UIImageView
 * 可能为nil
 */
@property (nonatomic, retain, readonly) UIImageView* blankImageView;

@end
