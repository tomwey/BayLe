//
//  UserManager.h
//  BayLe
//
//  Created by tangwei1 on 15/11/30.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserManager : NSObject

+ (instancetype)sharedInstance;

- (BOOL)isLogin;

@end
