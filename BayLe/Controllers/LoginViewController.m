//
//  LoginViewController.m
//  BayLe
//
//  Created by tangwei1 on 15/11/30.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import "LoginViewController.h"
#import "Defines.h"

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"快捷登录";
    
    UIButton* leftBtn = AWCreateImageButton(nil, self, @selector(back));
    UIImage* image = [[UIImage imageNamed:@"cancel"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [leftBtn setImage:image forState:UIControlStateNormal];
    leftBtn.tintColor = NAVBAR_HIGHLIGHT_TEXT_COLOR;
    self.navBar.leftButton = leftBtn;
    
}

- (void)back
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
