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
    
    self.navBar.leftButton = AWCreateImageButton(@"cancel", self, @selector(back));
}

- (void)back
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
