//
//  DataManager.m
//  BayLe
//
//  Created by tangwei1 on 15/12/1.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import "DataStoreManager.h"
#import "Defines.h"

@interface DataStoreManager ()

@property (nonatomic, retain) Location* currentLocation;

@property (nonatomic, retain) NSArray* currentTags;

@end

@implementation DataStoreManager

AW_SINGLETON_IMPL(DataStoreManager)

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
