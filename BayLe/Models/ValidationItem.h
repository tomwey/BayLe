//
//  ValidationItem.h
//  BayLe
//
//  Created by tangwei1 on 15/12/11.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ValidationFormatName) {
    ValidationFormatNameNotNull = 1, // 不允许为空，对应的值为YES或NO
    ValidationFormatNameLength,      // 长度限制，  对应的值为整数
    ValidationFormatNameRegex,       // 正则匹配，  对应的值为正则表达式字符串
};

@class ValidationFormat;
@interface ValidationItem : NSObject

/** 需要验证的某个对象的属性名称 */
@property (nonatomic, copy) NSString* field;

/** 验证规则 */
@property (nonatomic, retain) ValidationFormat* format;

/** 错误消息 */
@property (nonatomic, copy) NSString* message;

- (id)initWithField:(NSString *)field format:(ValidationFormat *)format message:(NSString *)message;

- (BOOL)validate;

@end

/**
 * 创建一个自动释放的验证对象
 * 
 * @param field 需要验证的对象属性
 * @param format 验证规则
 * @param message 验证失败的错误消息提示
 * @return 验证对象
 */
static inline ValidationItem* ValidationItemCreate(NSString* field, ValidationFormat* format, NSString* message) {
    return [[[ValidationItem alloc] initWithField:field format:format message:message] autorelease];
};

@interface ValidationFormat : NSObject

@property (nonatomic, assign) ValidationFormatName name;

/** 设置验证规则对应的值，该值的类型只能是BOOL, NSString, int三种数据类型 */
@property (nonatomic, retain) id value;

- (id)initWithName:(ValidationFormatName)name value:(id)value;

@end

static inline ValidationFormat* ValidationFormatCreate(ValidationFormatName name, id value) {
    return [[[ValidationFormat alloc] initWithName:name value:value] autorelease];
};


