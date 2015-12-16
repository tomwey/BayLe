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
/** 
 * 点击了某个tabbar执行的回调
 * 
 * @param tabBar 当前tabBar
 * @param index 页面索引
 */
- (void)customTabBar:(CustomTabBar *)tabBar didSelectAtIndex:(NSInteger)index;

/**
 * 是否应该显示某个页面，一般用于需要用户登录才能打开的页面
 *
 * @param viewController 需要显示的页面
 */
- (BOOL)shouldShowViewController:(UIViewController *)viewController;

/**
 * 是否应该显示某个索引对应的页面，一般用于需要用户登录才能打开的页面
 *
 * @param index 需要显示的页面索引
 */
- (BOOL)shouldShowViewControllerForIndex:(NSInteger)index;

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

@interface UIViewController (CustomTabBarItem)

@property (nonatomic, retain) CustomTabBarItem* customTabBarItem;

@end

@interface UIViewController (CustomTabBar)

@property (nonatomic, retain, readonly) CustomTabBar* customTabBar;

@end
