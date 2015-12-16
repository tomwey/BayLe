//
//  LoginViewController.m
//  BayLe
//
//  Created by tangwei1 on 15/11/30.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import "LoginViewController.h"
#import "Defines.h"

@interface LoginViewController ()

@property (nonatomic, retain) User* user;

@end

@implementation LoginViewController
{
    UIButton* _fetchCodeBtn;
    UIButton* _loginBtn;
    
    UITextField* _currentField;
    
    NSInteger _totalSeconds;
    NSTimer*  _timer;
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
    
    self.user = [[[User alloc] init] autorelease];
}

- (void)dealloc
{
    self.user = nil;
    
    [_timer invalidate];
    _timer = nil;
    
    [super dealloc];
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
    
    [mobileInput addTarget:self forAction:@selector(mobileTextDidChange:)];
    
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
    
    [self setEnableFetchCodeBtn:NO];
    
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
    
    [codeInput addTarget:self forAction:@selector(codeTextDidChange:)];
    
    // 添加登录按钮
    UIButton* loginBtn = AWCreateTextButton(CGRectMake(15, formBg.bottom + 15, AWFullScreenWidth() - 30, 50),
                                            @"验证并登录",
                                            [UIColor whiteColor],
                                            self,
                                            @selector(login));
    [self.contentView addSubview:loginBtn];
    loginBtn.backgroundColor = MAIN_RED_COLOR;
    
    _loginBtn = loginBtn;
    
    [self setEnableLoginBtn:NO];
}

- (void)login
{
    if ( [self mobileIsValid:self.user.mobile] == NO ) {
        [AWToast showText:@"不正确的手机号"];
        return;
    }
    
    if ( [self codeIsValid:self.user.code] == NO ) {
        [AWToast showText:@"不正确的验证码"];
        return;
    }
    
    [_currentField resignFirstResponder];
//    [self endUpdateTime];
    
    [MBProgressHUD showHUDAddedTo:self.contentView animated:YES];
    __block LoginViewController* me = self;
    [[UserManager sharedInstance] login:self.user completion:^(User *aUser, NSError *error) {
        [MBProgressHUD hideHUDForView:self.contentView animated:YES];
        
        if ( error ) {
            [AWToast showText:error.domain];
        } else {
            UIViewController* controller = [[[UpdateProfileViewController alloc] init] autorelease];
            [me.navigationController pushViewController:controller animated:YES];
        }
        
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_currentField resignFirstResponder];
}

- (BOOL)mobileIsValid:(NSString *)mobile
{
    NSString *phoneRegex = @"\\A1[3|4|5|8|7][0-9]\\d{8}\\z";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    BOOL matches = [test evaluateWithObject:mobile];
    
    return matches;
}

- (BOOL)codeIsValid:(NSString *)code
{
    NSString *phoneRegex = @"\\d{4}";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    BOOL matches = [test evaluateWithObject:code];
    
    return matches;
}

- (void)mobileTextDidChange:(FormTextInput *)sender
{
    _currentField = sender.textField;
    
    self.user.mobile = sender.textField.text;
    [self setEnableFetchCodeBtn:([self mobileIsValid:self.user.mobile] && ![_timer isValid])];
}

- (void)codeTextDidChange:(FormTextInput *)sender
{
    _currentField = sender.textField;
    
    self.user.code = sender.textField.text;
    [self setEnableLoginBtn:([self mobileIsValid:self.user.mobile] && [self codeIsValid:self.user.code])];
}

- (void)setEnableFetchCodeBtn:(BOOL)enabled
{
    _fetchCodeBtn.userInteractionEnabled = enabled;
    if ( enabled ) {
        [_fetchCodeBtn setTitleColor:MAIN_RED_COLOR forState:UIControlStateNormal];
    } else {
        [_fetchCodeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
}

- (void)setEnableLoginBtn:(BOOL)enabled
{
    _loginBtn.userInteractionEnabled = enabled;
    if (enabled) {
        _loginBtn.backgroundColor = MAIN_RED_COLOR;
    } else {
        _loginBtn.backgroundColor = [UIColor grayColor];
    }
}

- (void)fetchCode
{
    if ( ![self mobileIsValid:self.user.mobile] ) {
        [AWToast showText:@"不正确的手机号"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.contentView animated:YES];
    
    _fetchCodeBtn.userInteractionEnabled = NO;
    _totalSeconds = 59;
    [self updateTime];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    
    [_currentField resignFirstResponder];
    
    __block LoginViewController* me = self;
    
    [[UserManager sharedInstance] fetchCode:self.user completion:^(id result, NSError *error) {
        [MBProgressHUD hideHUDForView:self.contentView animated:YES];
        if ( !error ) {
            [AWToast showText:@"验证码已经发送到手机"];
        } else {
            [AWToast showText:@"验证码发送失败"];
        }
        
    }];
}

- (void)updateTime
{
    [_fetchCodeBtn setTitle:[NSString stringWithFormat:@"%d", _totalSeconds] forState:UIControlStateNormal];
    if ( _totalSeconds == 0 ) {
        [self endUpdateTime];
    }
    
    _totalSeconds --;
}

- (void)endUpdateTime
{
    [_timer invalidate];
    _timer = nil;
    
    _fetchCodeBtn.userInteractionEnabled = YES;
    [_fetchCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    
    [self setEnableFetchCodeBtn:([self mobileIsValid:self.user.mobile] && ![_timer isValid])];
}

- (void)back
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
