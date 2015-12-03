//
//  Location.m
//  BayLe
//
//  Created by tangwei1 on 15/12/3.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import "Location.h"

@implementation Location

- (id)initWithCity:(NSString *)city placement:(NSString *)placement
{
    if ( self = [super init] ) {
        self.city = city;
        self.placement = placement;
    }
    return self;
}

+ (id)locationWithCity:(NSString *)city placement:(NSString *)placement
{
    return [[[Location alloc] initWithCity:city placement:placement] autorelease];
}

- (void)dealloc
{
    self.city = nil;
    self.placement = nil;
    
    [super dealloc];
}

@end

@implementation Location (Wrapper)

- (NSString *)locationString
{
    return [NSString stringWithFormat:@"%.06lf,%.06lf", self.coordinate.longitude, self.coordinate.latitude];
}

@end
