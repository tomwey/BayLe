//
//  User.m
//  BayLe
//
//  Created by tangwei1 on 15/12/3.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import "User.h"
#import "Models.h"
#import <objc/runtime.h>

@implementation User

- (void)dealloc
{
    self.mobile = nil;
    self.token = nil;
    self.nickname = nil;
    self.avatar = nil;
    
    [self removeAllValidationItems];
    
    [super dealloc];
}

@end

@implementation User (Validation)

@dynamic errors;

static char kValidationItemsKey;
static char kValidationItemsErrorsKey;

- (NSMutableDictionary *)internalErrors
{
    id errors = objc_getAssociatedObject(self, &kValidationItemsErrorsKey);
    if (!errors) {
        errors = [NSMutableDictionary dictionary];
        [self setInternalErrors:errors];
    }
    return errors;
}

- (void)setInternalErrors:(NSDictionary *)dict
{
    objc_setAssociatedObject(self, &kValidationItemsErrorsKey, dict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)validationItemsArray
{
    id obj = objc_getAssociatedObject(self, &kValidationItemsKey);
    if ( !obj ) {
        obj = [NSMutableArray array];
        [self setValidationItemsArray:obj];
    }
    return obj;
}

- (void)setValidationItemsArray:(NSMutableArray *)array
{
    objc_setAssociatedObject(self, &kValidationItemsKey, array, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDictionary *)errors
{
    return [NSDictionary dictionaryWithDictionary:[self internalErrors]];
}

/**
 * 添加一个验证规则
 */
- (void)addValidationItem:(ValidationItem *)item
{
    if ( item && [[self validationItemsArray] containsObject:item] == NO ) {
        [[self validationItemsArray] addObject:item];
    }
}

/**
 * 移除该对象上所有的验证规则，一般在该对象被释放时调用
 */
- (void)removeAllValidationItems
{
    [[self validationItemsArray] removeAllObjects];
    [self setValidationItemsArray:nil];
    
    [[self internalErrors] removeAllObjects];
    [self setInternalErrors:nil];
}

/**
 * 验证数据
 */
- (BOOL)validate
{
    NSArray* array = [self validationItemsArray];
    for (ValidationItem* item in array) {
        SEL getterMethod = NSSelectorFromString(item.field);
        if ( [self respondsToSelector:getterMethod] ) {
            id value = [self performSelector:getterMethod];
            switch (item.format.name) {
                case ValidationFormatNameNotNull:
                {
                    if ( [item.format.value boolValue] == YES &&  !value) {
                        [[self internalErrors] setObject:item.message forKey:item.field];
                        return NO;
                    }
                }
                
                case ValidationFormatNameLength:
                {
                    if ( [item.format.value integerValue] != [value length] ) {
                        [[self internalErrors] setObject:item.message forKey:item.field];
                        return NO;
                    }
                }
                    
                case ValidationFormatNameRegex:
                {
                    NSError* error = nil;
                    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:item.format.value
                                                                                           options:NSRegularExpressionCaseInsensitive
                                                                                             error:&error];
                    if ( error ) {
                        NSAssert(NO, @"不正确的正则表达式：%@", item.format.value);
                        return YES;
                    }
                    
                    if ( [[regex matchesInString:value options:NSMatchingReportCompletion range:NSMakeRange(0, [value length])] count] == 0 ) {
                        [[self internalErrors] setObject:item.message forKey:item.field];
                        return NO;
                    }
                }
                    
                default:
                    break;
            }
        }
    }
    return YES;
}

@end
