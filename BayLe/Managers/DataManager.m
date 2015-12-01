//
//  DataManager.m
//  BayLe
//
//  Created by tangwei1 on 15/12/1.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import "DataManager.h"
#import "Defines.h"

@interface DataManager ()

@property (nonatomic, retain) Location* currentLocation;

@property (nonatomic, retain) NSArray* currentTags;

@end

@implementation DataManager

AW_SINGLETON_IMPL(DataManager)

- (void)saveLocation:(Location *)aLocation
{
    self.currentLocation = aLocation;
}

- (Location *)currentLocation
{
    return _currentLocation;
}

- (void)saveTags:(NSArray *)tags
{
    self.currentTags = tags;
}

- (NSArray *)currentTags
{
    return _currentTags;
}

@end
