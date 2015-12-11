//
//  ValidationItem.m
//  BayLe
//
//  Created by tangwei1 on 15/12/11.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import "ValidationItem.h"

@implementation ValidationItem

- (id)initWithField:(NSString *)field format:(ValidationFormat *)format message:(NSString *)message
{
    if ( self = [super init] ) {
        self.field = field;
        self.format = format;
        self.message = message;
    }
    return self;
}

- (void)dealloc
{
    self.field = nil;
    self.format = nil;
    self.message = nil;
    
    [super dealloc];
}

@end

@implementation ValidationFormat

- (id)initWithName:(ValidationFormatName)name value:(id)value
{
    if ( self = [super init] ) {
        self.name = name;
        self.value = value;
    }
    return self;
}

- (void)dealloc
{
    self.value = nil;
    [super dealloc];
}

@end
