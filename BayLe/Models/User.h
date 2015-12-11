//
//  User.h
//  BayLe
//
//  Created by tangwei1 on 15/12/3.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, copy) NSString* mobile;
@property (nonatomic, copy) NSString* token;
@property (nonatomic, copy) NSString* nickname;
@property (nonatomic, copy) NSString* avatar;

@end

@class ValidationItem;
@interface User (Validation)

/**
 * 添加一个验证规则
 */
- (void)addValidationItem:(ValidationItem *)item;

/**
 * 移除该对象上所有的验证规则，一般在该对象被释放时调用
 */
- (void)removeAllValidationItems;

/** 返回验证失败的错误消息，
 数组里面的每一个元素是一个字典对象，
 字典对象的key为被验证对象的字段名，
 value为错误消息字段 */
@property (nonatomic, retain, readonly) NSArray* errors;

/**
 * 验证数据
 */
- (BOOL)validate;

@end