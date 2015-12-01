//
//  PublishViewController.m
//  BayLe
//
//  Created by tangwei1 on 15/11/19.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import "PublishViewController.h"
#import "Defines.h"

@interface PublishViewController () <UITextFieldDelegate, UITextViewDelegate, UIScrollViewDelegate>

@property (nonatomic, assign) CGFloat topMargin;

@property (nonatomic, retain) NSMutableDictionary* itemData;

@end

#define SECTION_PADDING 10

@implementation PublishViewController
{
    UIView* _sectionView1;
    UIView* _sectionView2;
    UIView* _sectionView3;
    
    UIScrollView* _scrollView;
    
    UITextField* _currentField;
    UITextView*  _currentTextView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"发布";
    
    self.itemData = [NSMutableDictionary dictionary];
    
    UIButton* rightBtn = AWCreateTextButton(CGRectMake(0, 0, 40, 33), @"提交", [UIColor whiteColor], self, @selector(commit));
    [[rightBtn titleLabel] setFont:AWSystemFontWithSize(14, NO)];
    self.navBar.rightButton = rightBtn;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.contentView.bounds];
    [self.contentView addSubview:_scrollView];
    [_scrollView release];
    
    _scrollView.delegate = self;
    
    self.contentView.backgroundColor = MAIN_CONTENT_BG_COLOR;
    
    [self initSection1];
    
    [self initSection2];
    
    [self initSection3];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)noti
{
    CGPoint point = [_currentField.superview convertPoint:_currentField.frame.origin toView:AWAppWindow()];
    CGFloat dt = point.y - [[[noti userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height - _currentField.height + 16;
    if ( dt > 0 ) {
        [UIView animateWithDuration:[[[noti userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]
                         animations:
         ^{
             _scrollView.contentInset = UIEdgeInsetsMake(0, 0, dt, 0);
             _scrollView.contentOffset = CGPointMake(0, dt);
        }];
    }
    
}

- (void)keyboardWillHide:(NSNotification *)noti
{
    [UIView animateWithDuration:[[[noti userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]
                     animations:^{
        _scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _scrollView.contentOffset = CGPointMake(0, 0);
    }];
}

#pragma mark - UIScrollView delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_currentTextView resignFirstResponder];
}

#pragma mark - UITextField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _currentField = textField;
}

- (void)textFieldDidChange:(UITextField *)textFiled
{
    if ( textFiled.tag == 1001 ) {
        if ( textFiled.text.length > 50 ) {
            [AWModalAlert say:@"最多不超过50个字" message:@""];
            return;
        }
        
        [self.itemData setObject:textFiled.text forKey:@"title"];
    } else if ( textFiled.tag == 1002 ) {
        
    } else if ( textFiled.tag == 1003 ) {
        
    }
    
}

- (void)textFieldTapReturn:(UITextField *)textFiled
{
    [textFiled resignFirstResponder];
}

#pragma mark - UITextView delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    _currentTextView = textView;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if ( textView.text.length >= 200 ) {
        [AWModalAlert say:@"最多不超过200个字" message:@""];
        return;
    }
    
    [self.itemData setObject:textView.text forKey:@"intro"];
}

#pragma mark - Target Action methods
- (void)commit
{
    
}

- (void)changeCategory
{
    
}

- (void)changeLocation
{
    
}

- (void)addPhoto:(UIButton *)sender
{
    
}

#pragma mark - Override methods
- (BOOL)shouldCheckLogin
{
    return YES;
}

#pragma mark - Private Methods
- (void)hideKeyboard
{
    [_currentTextView resignFirstResponder];
    [_currentField resignFirstResponder];
}

- (UITextField *)createTextFieldWithFrame:(CGRect)frame
                                      tag:(int)tag
                              placeholder:(NSString *)placeholder
                                   inView:(UIView *)containerView
{
    UITextField* textField = [[UITextField alloc] initWithFrame:frame];
    [containerView addSubview:textField];
    [textField release];
    
//    textField.delegate = self;
    textField.returnKeyType = UIReturnKeyDone;
    
    textField.tag = tag;
    
    textField.placeholder = placeholder;
    
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [textField addTarget:self action:@selector(textFieldTapReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [textField addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
    
    return textField;
}

- (void)initSection1
{
    _sectionView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, 100)];
    [_scrollView addSubview:_sectionView1];
    _sectionView1.backgroundColor = [UIColor whiteColor];
    [_sectionView1 release];
    
    // 添加标题
    UITextField* titleField = [self createTextFieldWithFrame:CGRectMake(15, 5, _sectionView1.width - 30, 37)
                                                         tag:1001
                                                 placeholder:@"标题"
                                                      inView:_sectionView1];
    
    // 加线
    UIView* line = AWCreateLine(CGSizeMake(_sectionView1.width - 15, .6), AWColorFromRGB(207, 207, 207));
    [_sectionView1 addSubview:line];
    line.y = titleField.bottom + 5;
    line.x = 15;
    
    // 添加描述
    UITextView* introTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, titleField.bottom + 10, titleField.width,
                                                                             88)];
    [_sectionView1 addSubview:introTextView];
    [introTextView release];
    
    introTextView.delegate = self;
    
    introTextView.font = titleField.font;
    
    CGRect frame = introTextView.frame;
    frame.size.height = 30;
    UILabel* placeholder = AWCreateLabel(frame,
                                         @"描述一下您的宝贝",
                                         NSTextAlignmentLeft,
                                         titleField.font, line.backgroundColor);
    [_sectionView1 addSubview:placeholder];
    
    // 添加图片
    UIButton* addPhoto = AWCreateTextButton(CGRectMake(titleField.left, introTextView.bottom + 5, 60, 60), @"添加图片",
                                            MAIN_LIGHT_GRAY_COLOR,
                                            self,
                                            @selector(addPhoto:));
    [[addPhoto titleLabel] setFont:AWSystemFontWithSize(14, NO)];
    [_sectionView1 addSubview:addPhoto];
    
    addPhoto.backgroundColor = MAIN_CONTENT_BG_COLOR;
    
    _sectionView1.height = addPhoto.bottom + 5;
    
    _scrollView.contentSize = CGSizeMake(_scrollView.width, _sectionView1.height);
}

- (void)initSection2
{
    _sectionView2 = [[UIView alloc] initWithFrame:CGRectMake(0, _sectionView1.bottom + SECTION_PADDING, self.contentView.width, 100)];
    [_scrollView addSubview:_sectionView2];
    _sectionView2.backgroundColor = [UIColor whiteColor];
    [_sectionView2 release];
    
    // 租金
    UILabel* priceLabel = AWCreateLabel(CGRectMake(15, 5, 36, 30),
                                        @"租金",
                                        NSTextAlignmentLeft,
                                        AWSystemFontWithSize(14, NO), [UIColor blackColor]);
    [_sectionView2 addSubview:priceLabel];
    
    UITextField* priceField = [self createTextFieldWithFrame:CGRectMake(priceLabel.right + 10, priceLabel.top,
                                                                        _sectionView2.width - priceLabel.right - 20,
                                                                        priceLabel.height)
                                                         tag:1002
                                                 placeholder:@"输入租金"
                                                      inView:_sectionView2];
    
    // 加线
    UIView* line = AWCreateLine(CGSizeMake(_sectionView2.width - 15, .6), AWColorFromRGB(207, 207, 207));
    [_sectionView2 addSubview:line];
    line.y = priceField.bottom + 5;
    line.x = 15;
    
    // 押金
    CGRect frame = priceLabel.frame;
    frame.origin.y = line.bottom + 5;
    
    UILabel* depositLabel = AWCreateLabel(frame,
                                          @"押金",
                                          NSTextAlignmentLeft,
                                          AWSystemFontWithSize(14, NO), [UIColor blackColor]);
    [_sectionView2 addSubview:depositLabel];
    
    UITextField* depositField = [self createTextFieldWithFrame:CGRectMake(depositLabel.right + 10,
                                                                          depositLabel.top,
                                                                          _sectionView2.width - depositLabel.right - 20,
                                                                          depositLabel.height)
                                                           tag:1003
                                                   placeholder:@"输入押金"
                                                        inView:_sectionView2];
    
    // 加线
    line = AWCreateLine(CGSizeMake(_sectionView2.width - 15, .6), AWColorFromRGB(207, 207, 207));
    [_sectionView2 addSubview:line];
    line.y = depositField.bottom + 5;
    line.x = 15;
    
    // 分类
    frame.origin.y = line.bottom + 5;
    UILabel* categoryLabel = AWCreateLabel(frame,
                                           @"分类",
                                           NSTextAlignmentLeft,
                                           AWSystemFontWithSize(14, NO), [UIColor blackColor]);
    [_sectionView2 addSubview:categoryLabel];
    
    CGRect frame2 = categoryLabel.frame;
    frame2.origin.x = categoryLabel.right + 10;
    frame2.size.width = depositField.width;
    
    UILabel* selectTip = AWCreateLabel(frame2,
                                       @"请选择分类",
                                       NSTextAlignmentLeft,
                                       AWSystemFontWithSize(14, NO), [UIColor blackColor]);
    [_sectionView2 addSubview:selectTip];
    
    UIImageView* arrowView = AWCreateImageView(@"cell_more_icon.png");
    [_sectionView2 addSubview:arrowView];
    arrowView.center = CGPointMake(_sectionView2.width - 15 - arrowView.width / 2, categoryLabel.midY);
    
    // 添加点击按钮
    CGRect frame3 = selectTip.frame;
    frame3.origin.x = 0;
    frame3.size.width = _sectionView2.width;
    
    UIButton* categoryBtn = AWCreateImageButton(nil, self, @selector(changeCategory));
    categoryBtn.frame = frame3;
    [_sectionView2 addSubview:categoryBtn];
    
    // 更新高度
    _sectionView2.height = categoryLabel.bottom + 5;
    
    _scrollView.contentSize = CGSizeMake(_scrollView.width, _sectionView2.height);
}

- (void)initSection3
{
    _sectionView3 = [[UIView alloc] initWithFrame:CGRectMake(0, _sectionView2.bottom + SECTION_PADDING, self.contentView.width, 100)];
    [_scrollView addSubview:_sectionView3];
    _sectionView3.backgroundColor = [UIColor whiteColor];
    [_sectionView3 release];
    
    // 地址
    UILabel* adLabel = AWCreateLabel(CGRectMake(15, 5, 36, 30),
                                     @"地址",
                                     NSTextAlignmentLeft,
                                     AWSystemFontWithSize(14, NO), [UIColor blackColor]);
    [_sectionView3 addSubview:adLabel];
    
    CGRect frame = adLabel.frame;
    frame.origin.x = adLabel.right + 10;
    frame.size.width = _sectionView3.width - adLabel.right - 20;
    
    UILabel* locationLabel = AWCreateLabel(frame,
                                           @"绿地世纪城",
                                           NSTextAlignmentLeft,
                                           AWSystemFontWithSize(14, NO), [UIColor blackColor]);
    [_sectionView3 addSubview:locationLabel];
    
    UIImageView* arrowView = AWCreateImageView(@"cell_more_icon.png");
    [_sectionView3 addSubview:arrowView];
    arrowView.center = CGPointMake(_sectionView3.width - 15 - arrowView.width / 2, adLabel.midY);
    
    // 添加按钮
    CGRect frame3 = adLabel.frame;
    frame3.origin.x = 0;
    frame3.size.width = _sectionView3.width;
    
    UIButton* changeAdInfo = AWCreateImageButton(nil, self, @selector(changeLocation));
    changeAdInfo.frame = frame3;
    [_sectionView3 addSubview:changeAdInfo];
    
    _sectionView3.height = locationLabel.bottom + 5;
    
    _scrollView.contentSize = CGSizeMake(_scrollView.width, _sectionView3.bottom + SECTION_PADDING);
}

@end
