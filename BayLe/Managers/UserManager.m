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

- (BOOL)isLogin
{
    return YES;//[[NSUserDefaults standardUserDefaults] boolForKey:@"user.login.v1"];
}

@end
