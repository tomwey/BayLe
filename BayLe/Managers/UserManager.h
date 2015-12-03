//
//  UserManager.h
//  BayLe
//
//  Created by tangwei1 on 15/11/30.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;
@interface UserManager : NSObject

+ (instancetype)sharedInstance;

/**
 * 是否已经登陆
 */
- (BOOL)isLogin;

/**
 * 用户登录
 */
- (void)login:(User *)aUser completion:(void (^)(User* aUser, NSError* error))completion;

/**
 * 更新用户资料
 */
- (void)updateUser:(User *)aUser completion:(void (^)(User* aUser, NSError* error))completion;

/**
 * 加载用户资料
 */
- (void)loadUserWithToken:(NSString *)token completion:(void (^)(User* aUser, NSError* error))completion;

/**
 * 返回当前用户
 */
- (User *)currentUser;

@end
