//
//  UserManager.m
//  BayLe
//
//  Created by tangwei1 on 15/11/30.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import "UserManager.h"
#import "Defines.h"

@implementation UserManager

AW_SINGLETON_IMPL(UserManager)

/**
 * 是否已经登陆
 */
- (BOOL)isLogin
{
    return NO;//[[NSUserDefaults standardUserDefaults] boolForKey:@"user.login.v1"];
}

/**
 * 用户登录
 */
- (void)login:(User *)aUser completion:(void (^)(User *, NSError *))completion
{
    
}

/**
 * 更新用户资料
 */
- (void)updateUser:(User *)aUser completion:(void (^)(User *, NSError *))completion
{
    
}

/**
 * 加载用户资料
 */
- (void)loadUserWithToken:(NSString *)token completion:(void (^)(User* aUser, NSError* error))completion
{
    
}

/**
 * 返回当前用户
 */
- (User *)currentUser
{
    User* user = [[[User alloc] init] autorelease];
    user.token = @"2816208c52bfe3f43321";
    return user;
}

@end
