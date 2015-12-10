//
//  BaseViewController.m
//  BayLe
//
//  Created by tomwey on 11/19/15.
//  Copyright (c) 2015 tangwei1. All rights reserved.
//

#import "BaseViewController.h"
#import "Defines.h"

@interface BaseViewController ()

@property (nonatomic, retain, readwrite) AWCustomNavBar* navBar;

@end

@implementation BaseViewController
{
    UIView* _contentView;
}

@synthesize contentView = _contentView;
@synthesize navBar = _navBar;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    self.view.backgroundColor =
    self.contentView.backgroundColor = MAIN_CONTENT_BG_COLOR;
    
    // 添加自定义导航条
    if ( !self.navBarHidden ) {
        self.navBar = [[[AWCustomNavBar alloc] init] autorelease];
        [self.view addSubview:self.navBar];
        self.navBar.backgroundColor = NAVBAR_BG_COLOR;
    }
    
    // 添加内容视图
    CGFloat tabBarHeight = [(AWCustomTabBarController *)self.tabBarController customTabBar].height;
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navBar.bottom,
                                                            self.view.width,
                                                            AWFullScreenHeight() -
                                                            self.navBar.height -
                                                            tabBarHeight)];
    [self.view addSubview:_contentView];
    [_contentView release];
    
}

- (void)setTitle:(NSString *)title
{
    self.navBar.title = title;
    self.navBar.titleLabel.textColor = NAVBAR_TEXT_COLOR;
}

- (NSString *)title { return self.navBar.title; }

+ (UIViewController *)viewControllerWithClassName:(NSString *)className
{
    UIViewController* controller = [[[NSClassFromString(className) alloc] init] autorelease];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:controller];
    return [nav autorelease];
}

@end
