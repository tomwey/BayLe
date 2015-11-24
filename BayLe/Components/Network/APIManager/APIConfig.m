//
//  APIConfig.m
//  BayLe
//
//  Created by tangwei1 on 15/11/24.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import "APIConfig.h"

@implementation APIConfig

+ (instancetype)sharedInstance
{
    static APIConfig* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ( !instance ) {
            instance = [[APIConfig alloc] init];
        }
    });
    return instance;
}

- (void)dealloc
{
    self.productionServer = nil;
    self.stageServer = nil;
    
    [super dealloc];
}

- (NSString *)currentServer
{
    if ( self.debugMode ) {
        return [NSString stringWithString:self.stageServer];
    } else {
        return [NSString stringWithString:self.productionServer];
    }
}

@end
