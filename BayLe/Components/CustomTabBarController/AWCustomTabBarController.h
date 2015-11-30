//
//  CustomTabBarController.h
//  BayLe
//
//  Created by tangwei1 on 15/11/19.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

/*******************************************************
 -------------------- 自定义TabBar控制器 -----------------
 注意：本控件最多只支持5个TabBar item，如果超过5个，请使用系统
 控件UITabBarController
 *******************************************************/

#import <UIKit/UIKit.h>

typedef UIImageView CustomTabBar;

@class CustomTabBarItem;

@protocol CustomTabBarDelegate <NSObject>

@optional
- (void)customTabBar:(CustomTabBar *)tabBar didSelectAtIndex:(NSInteger)index;

@end

@interface AWCustomTabBarController : UITabBarController

@property (nonatomic, retain) UIImage* tabBarBackgroundImage;
@property (nonatomic, retain, readonly) CustomTabBar* customTabBar;

@property (nonatomic, assign) id <CustomTabBarDelegate> customTabBarDelegate;

/**
 * tabBar item的tintColor
 */
@property (nonatomic, retain) UIColor* itemTintColor;

/**
 * 选中的标签颜色
 */
@property (nonatomic, retain) UIColor* selectedItemTintColor;

@end

@interface UIViewController (CustomTabBarItem)

@property (nonatomic, retain) CustomTabBarItem* customTabBarItem;

@end

/** 自定义TabBar Item */
@interface CustomTabBarItem : NSObject

@property (nonatomic, retain) UIImage* image;
@property (nonatomic, retain) UIImage* selectedImage;

@property (nonatomic, copy) NSString* title;

- (id)initWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage;

@end

/**
 * 快速创建一个自动释放的CustomTabBarItem对象
 */
static inline CustomTabBarItem* AWCreateCustomTabBarItem(NSString* title, UIImage* anImage, UIImage* selectedImage)
{
    return [[[CustomTabBarItem alloc] initWithTitle:title image:anImage selectedImage:selectedImage] autorelease];
};
