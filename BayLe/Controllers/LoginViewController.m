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
{
    UIButton* _fetchCodeBtn;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"快捷登录";
    
    UIButton* leftBtn = AWCreateImageButton(nil, self, @selector(back));
    UIImage* image = [[UIImage imageNamed:@"cancel"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [leftBtn setImage:image forState:UIControlStateNormal];
    leftBtn.tintColor = NAVBAR_HIGHLIGHT_TEXT_COLOR;
    self.navBar.leftButton = leftBtn;
    
    [self initLoginForm];
}

- (void)initLoginForm
{
    // 表单背景
    UIView* formBg = [[[UIView alloc] init] autorelease];
    [self.contentView addSubview:formBg];
    
    formBg.backgroundColor = [UIColor whiteColor];
    
    formBg.frame = CGRectMake(0, 0, AWFullScreenWidth(), 116);
    
    // 手机
    FormTextInput* mobileInput = [[[FormTextInput alloc] init] autorelease];
    [formBg addSubview:mobileInput];
    mobileInput.label = @"手机号";
    mobileInput.placeholder = @"请输入手机号";
    mobileInput.frame = CGRectMake(15, 0, (AWFullScreenWidth() - 15) * 0.618, 58);
    mobileInput.textField.keyboardType = UIKeyboardTypeNumberPad;
    
    // 添加垂直分割线
    UIView* verticalLine = AWCreateLine(CGSizeMake(0.6, mobileInput.height), AWColorFromRGB(224, 224, 224));
    [formBg addSubview:verticalLine];
    verticalLine.position = CGPointMake(mobileInput.right, mobileInput.top);
    
    // 添加获取验证码按钮
    UIButton* codeButton = AWCreateTextButton(CGRectMake(verticalLine.right, verticalLine.top, AWFullScreenWidth() - 15 - mobileInput.width,
                                                         mobileInput.height),
                                              @"获取验证码",
                                              [UIColor lightGrayColor],
                                              self,
                                              @selector(fetchCode));
    [formBg addSubview:codeButton];
    _fetchCodeBtn = codeButton;
    
    _fetchCodeBtn.userInteractionEnabled = NO;
    
    // 添加分割线
    UIView* line = AWCreateLine(CGSizeMake(formBg.width - mobileInput.left, .6), AWColorFromRGB(224, 224, 224));
    [formBg addSubview:line];
    line.position = CGPointMake(mobileInput.left, mobileInput.bottom);
    
    // 验证码
    FormTextInput* codeInput = [[[FormTextInput alloc] init] autorelease];
    [formBg addSubview:codeInput];
    codeInput.label = @"验证码";
    codeInput.placeholder = @"请输入4位手机验证码";
    codeInput.frame = CGRectMake(mobileInput.left, mobileInput.bottom, AWFullScreenWidth() - mobileInput.left * 2, mobileInput.height);
    codeInput.textField.keyboardType = UIKeyboardTypeNumberPad;
    
    // 添加登录按钮
    UIButton* loginBtn = AWCreateTextButton(CGRectMake(15, formBg.bottom + 15, AWFullScreenWidth() - 30, 50),
                                            @"验证并登录",
                                            [UIColor whiteColor],
                                            self,
                                            @selector(login));
    [self.contentView addSubview:loginBtn];
    loginBtn.backgroundColor = MAIN_RED_COLOR;
}

- (void)login
{
    User* user = [[[User alloc] init] autorelease];
    if ( ![user validate] ) {
        return;
    }
    
    
}

- (void)fetchCode
{
    
}

- (void)back
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
