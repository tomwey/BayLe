//
//  User.m
//  BayLe
//
//  Created by tangwei1 on 15/12/3.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import "User.h"

@implementation User

- (void)dealloc
{
    self.mobile = nil;
    self.token = nil;
    self.nickname = nil;
    self.avatar = nil;
    
    [super dealloc];
}

@end
