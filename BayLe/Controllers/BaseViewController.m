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

@property (nonatomic, retain) UIView* loginContainer;

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
    
    if ( [self shouldCheckLogin] ) {
        self.loginContainer = [[[UIView alloc] initWithFrame:_contentView.bounds] autorelease];
        self.loginContainer.backgroundColor = [UIColor clearColor];
        [_contentView addSubview:self.loginContainer];
        
        self.loginContainer.hidden = YES;
        
        UIButton* loginBtn = AWCreateTextButton(CGRectMake(0, 0, 100, 37), @"登录", [UIColor whiteColor], self, @selector(login));
        loginBtn.backgroundColor = MAIN_RED_COLOR;
        [self.loginContainer addSubview:loginBtn];
        loginBtn.center = CGPointMake(self.loginContainer.width / 2, self.loginContainer.height / 2);
    }
    
}

- (void)login
{
    UIViewController* lvc = [BaseViewController viewControllerWithClassName:@"LoginViewController"];
    [[AWAppWindow() rootViewController] presentViewController:lvc animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ( [self shouldCheckLogin] && [[UserManager sharedInstance] isLogin] == NO ) {
        // 显示用户登录提示按钮
        self.loginContainer.hidden = NO;
        [self.contentView bringSubviewToFront:self.loginContainer];
        self.loginContainer.userInteractionEnabled = YES;
    } else {
        // 移除用户登录提示
        self.loginContainer.hidden = YES;
        self.loginContainer.userInteractionEnabled = NO;
    }
}

- (BOOL)shouldCheckLogin
{
    return NO;
}

- (void)setTitle:(NSString *)title
{
    self.navBar.title = title;
    self.navBar.titleLabel.textColor = NAVBAR_TEXT_COLOR;
}

+ (UIViewController *)viewControllerWithClassName:(NSString *)className
{
    UIViewController* controller = [[[NSClassFromString(className) alloc] init] autorelease];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:controller];
    return [nav autorelease];
}

@end
