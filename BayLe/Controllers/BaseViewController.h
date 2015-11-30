//
//  BaseViewController.h
//  BayLe
//
//  Created by tomwey on 11/19/15.
//  Copyright (c) 2015 tangwei1. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AWCustomNavBar;
@interface BaseViewController : UIViewController

@property (nonatomic, retain, readonly) UIView* contentView;

@property (nonatomic, assign) BOOL navBarHidden;

@property (nonatomic, retain, readonly) AWCustomNavBar* navBar;

+ (UIViewController *)viewControllerWithClassName:(NSString *)className;

/** 是否需要进行用户登录检查 */
- (BOOL)shouldCheckLogin;

@end
