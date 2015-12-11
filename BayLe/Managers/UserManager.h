//
//  UserManager.h
//  BayLe
//
//  Created by tangwei1 on 15/11/30.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;
@interface UserManager : NSObject

/** 返回最新的用户资料 */
@property (nonatomic, retain, readonly) User* currentUser;

+ (instancetype)sharedInstance;

/**
 * 是否已经登陆
 */
- (BOOL)isLogin;

/**
 * 用户登录
 */
- (void)login:(User *)aUser completion:(void (^)(id result, NSError* error))completion;

/**
 * 退出登录
 */
- (void)logout:(User *)aUser completion:(void (^)(id result, NSError* error))completion;

/**
 * 获取验证码
 */
- (void)fetchCode:(User *)aUser completion:(void (^)(id result, NSError* error))completion;

/**
 * 更新用户资料
 */
- (void)updateUser:(User *)aUser avatar:(UIImage *)anImage completion:(void (^)(id result, NSError* error))completion;

/**
 * 加载用户资料
 */
- (void)loadUserWithToken:(NSString *)token completion:(void (^)(id result, NSError* error))completion;

@end

#import "APIReformer.h"
@interface UserReformer : NSObject <APIReformer>


@end
