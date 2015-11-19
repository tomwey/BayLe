//
//  CustomNavBar.h
//  Wallpapers10000+
//
//  Created by tangwei1 on 15/11/16.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AWCustomNavBar : UIView

/** 设置导航条背景颜色 */
@property (nonatomic, retain) UIColor* backgroundColor;

/** 设置导航条背景图片 */
@property (nonatomic, retain) UIImage* backgroundImage;

@property (nonatomic, copy) NSString*  title;

@property (nonatomic, retain, readonly) UILabel* titleLabel;

@property (nonatomic, retain) UIView*   titleView;

@property (nonatomic, retain) UIButton* leftButton;
@property (nonatomic, retain) UIButton* rightButton;

@property (nonatomic, retain, readonly) UIImageView* contentView;

@end
