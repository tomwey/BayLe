//
//  Command.m
//  Wallpapers10000+
//
//  Created by tangwei1 on 15/7/15.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import "Command.h"

@implementation Command

- (void)dealloc
{
    self.userData = nil;
    [super dealloc];
}

- (id)initWithUserData:(id)userData
{
    if ( self = [super init] ) {
        self.userData = userData;
    }
    return self;
}

+ (id)commandWithUserData:(id)userDta
{
    return [[[[self class] alloc] initWithUserData: userDta] autorelease];
}

+ (id)commandWithName:(NSString *)commandName
{
    return [[[NSClassFromString(commandName) alloc] init] autorelease];
}

- (void)execute
{
    [NSException raise:@"Override Exception" format:@"必须重写此方法"];
}

@end
