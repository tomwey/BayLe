//
//  UserManager.m
//  BayLe
//
//  Created by tangwei1 on 15/11/30.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import "UserManager.h"
#import "Defines.h"

@interface UserManager () <APIManagerDelegate>

@property (nonatomic, retain, readonly) APIManager* apiManager;

@property (nonatomic, copy) void (^loginCompletionBlock)(id result, NSError* error);
@property (nonatomic, copy) void (^fetchCodeCompletionBlock)(id result, NSError* error);
@property (nonatomic, copy) void (^updateUserCompletionBlock)(id result, NSError* error);
@property (nonatomic, copy) void (^loadUserCompletionBlock)(id result, NSError* error);

@property (nonatomic, retain, readwrite) User* currentUser;

@end

@implementation UserManager

@synthesize apiManager = _apiManager;

AW_SINGLETON_IMPL(UserManager)

/**
 * 是否已经登陆
 */
- (BOOL)isLogin
{
    return !![[NSUserDefaults standardUserDefaults] objectForKey:@"user.token"];
}

/**
 * 用户登录
 */
- (void)login:(User *)aUser completion:(void (^)(id result, NSError *error))completion
{
    self.loginCompletionBlock = completion;
    
    [self.apiManager cancelRequest];
    
    APIRequest* request = APIRequestCreate(API_USER_LOGIN, RequestMethodPost, @{ @"mobile" : aUser.mobile,
                                                                                 @"code" : aUser.code });
    [self.apiManager sendRequest:request];
}

- (void)logout:(User *)aUser completion:(void (^)(id result, NSError* error))completion
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user.token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)fetchCode:(User *)aUser completion:(void (^)(id result, NSError* error))completion
{
    self.fetchCodeCompletionBlock = completion;
    
    [self.apiManager cancelRequest];
    
    APIRequest* request = APIRequestCreate(API_FETCH_CODE, RequestMethodPost, @{ @"mobile" : aUser.mobile });
    [self.apiManager sendRequest:request];
}

/**
 * 更新用户资料
 */
- (void)updateUser:(User *)aUser avatar:(UIImage *)anImage completion:(void (^)(id result, NSError *))completion
{
    self.updateUserCompletionBlock = completion;
    
    [self.apiManager cancelRequest];
    
    APIRequest* request = APIRequestCreate(API_UPDATE_USER, RequestMethodPost, @{ @"token" : aUser.token,
                                                                                  @"nickname" : aUser.nickname
                                                                                  });
    if ( anImage ) {
        APIFileParam* fileParam = APIFileParamCreate(UIImageJPEGRepresentation(anImage, 1.0),
                                                     @"avatar",
                                                     @"image.jpg",
                                                     @"image/jpeg");
        [request addFileParam:fileParam];
    }
    
    [self.apiManager sendRequest:request];
}

/**
 * 加载用户资料
 */
- (void)loadUserWithToken:(NSString *)token completion:(void (^)(id result, NSError* error))completion
{
    self.loadUserCompletionBlock = completion;
    [self.apiManager cancelRequest];
    
    APIRequest* request = APIRequestCreate(API_LOAD_USER, RequestMethodGet, @{ @"token" : token });
    [self.apiManager sendRequest:request];
}

/** 网络请求成功回调 */
- (void)apiManagerDidSuccess:(APIManager *)manager
{
    self.currentUser = [manager fetchDataWithReformer:[[[UserReformer alloc] init] autorelease]];
    
    if ( [manager.apiRequest.uri isEqualToString:API_USER_LOGIN] ) {
        // 将token保存到本地
        [[NSUserDefaults standardUserDefaults] setObject:self.currentUser.token forKey:@"user.token"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if ( self.loginCompletionBlock ) {
            self.loginCompletionBlock(self.currentUser, nil);
        }
    } else if ( [manager.apiRequest.uri isEqualToString:API_FETCH_CODE] ) {
        if ( self.fetchCodeCompletionBlock ) {
            self.fetchCodeCompletionBlock([manager fetchDataWithReformer:nil], nil);
        }
    } else if ( [manager.apiRequest.uri isEqualToString:API_LOAD_USER] ) {
        if ( self.loadUserCompletionBlock ) {
            self.loadUserCompletionBlock(self.currentUser, nil);
        }
    } else if ( [manager.apiRequest.uri isEqualToString:API_UPDATE_USER] ) {
        if ( self.updateUserCompletionBlock ) {
            self.updateUserCompletionBlock([manager fetchDataWithReformer:nil], nil);
        }
    }
}

/** 网络请求失败回调 */
- (void)apiManagerDidFailure:(APIManager *)manager
{
    if ( [manager.apiRequest.uri isEqualToString:API_USER_LOGIN] ) {
        if ( self.loginCompletionBlock ) {
            self.loginCompletionBlock(nil, [NSError errorWithDomain:manager.apiError.message
                                                               code:manager.apiError.code
                                                           userInfo:nil]);
        }
    } else if ( [manager.apiRequest.uri isEqualToString:API_FETCH_CODE] ) {
        if ( self.fetchCodeCompletionBlock ) {
            self.fetchCodeCompletionBlock(nil, [NSError errorWithDomain:manager.apiError.message
                                                                   code:manager.apiError.code
                                                               userInfo:nil]);
        }
    } else if ( [manager.apiRequest.uri isEqualToString:API_LOAD_USER] ) {
        if ( self.loadUserCompletionBlock ) {
            self.loadUserCompletionBlock(nil, [NSError errorWithDomain:manager.apiError.message
                                                                  code:manager.apiError.code
                                                              userInfo:nil]);
        }
    } else if ( [manager.apiRequest.uri isEqualToString:API_UPDATE_USER] ) {
        if ( self.updateUserCompletionBlock ) {
            self.updateUserCompletionBlock(nil, [NSError errorWithDomain:manager.apiError.message
                                                                    code:manager.apiError.code
                                                                userInfo:nil]);
        }
    }
}

- (APIManager *)apiManager
{
    if ( !_apiManager ) {
        _apiManager = [[APIManager alloc] initWithDelegate:self];
    }
    
    return _apiManager;
}

@end

@implementation UserReformer

- (id)reformDataWithManager:(APIManager *)manager
{
    id result = manager.rawData;
    id userData = [result objectForKey:@"data"];
    
    User* user = [[[User alloc] init] autorelease];
    
    user.mobile = [userData objectForKey:@"mobile"];
    user.nickname = [userData objectForKey:@"nickname"];
    user.token = [userData objectForKey:@"token"];
    user.avatar = [userData objectForKey:@"avatar"];
    user.balance = [[userData objectForKey:@"balance"] integerValue];
    
    return user;
}

@end
