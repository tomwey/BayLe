//
//  Command.h
//  Wallpapers10000+
//
//  Created by tangwei1 on 15/7/15.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Command : NSObject

- (id)initWithUserData:(id)userData;

+ (id)commandWithUserData:(id)userDta;
+ (id)commandWithName:(NSString *)commandName;

- (void)execute;

@property (nonatomic, retain) id userData;

@end
