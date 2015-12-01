//
//  TextInputComponent.h
//  EAT
//
//  Created by tangwei1 on 15/5/12.
//  Copyright (c) 2015年 KeKeStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, TextInputComponentType) {
    TextInputComponentTypeSingle, // 单行
    TextInputComponentTypeMultiple, // 多行文本
};

@interface TextInputComponent : UIView

/**
 * 限制输入的字数
 *
 * 默认值为-1，表示不限制
 */
@property (nonatomic, assign) NSInteger textLength;

@property (nonatomic, copy) NSString* placeholder;

@property (nonatomic, retain) UIFont* font;

@property (nonatomic, retain) UIColor* textColor;

@property (nonatomic, assign) UIKeyboardType keyboardType;

@property (nonatomic, copy) NSString* text;

/**
 * 组件输入框类型
 * 
 * 默认为 TextInputComponentTypeSingle 单行输入文本
 */
@property (nonatomic, assign) TextInputComponentType componentType;

/**
 * 判断组件输入内容与默认值是否相等，进而来判断内容是否修改
 */
@property (nonatomic, assign, readonly) BOOL textChanged;

- (void)hideKeyboard;

@end
