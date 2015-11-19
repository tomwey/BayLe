//
//  AWTableViewCell.h
//  Wallpapers10000+
//
//  Created by tangwei1 on 15/7/17.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AWTableViewCell : UITableViewCell

/** 设置分隔线的颜色 */
@property (nonatomic, retain) UIColor* lineColor;

/** 是否允许显示上边分隔线 */
@property (nonatomic, assign) BOOL allowShowTopLine;

/** 是否允许显示下边分割线 */
@property (nonatomic, assign) BOOL allowShowBottomLine;

/** 上边分割线的宽度 */
@property (nonatomic, assign) CGFloat topLineWidth;

/** 下边分割线的宽度 */
@property (nonatomic, assign) CGFloat bottomLineWidth;

@end
