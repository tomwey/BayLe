//
//  DataManager.h
//  BayLe
//
//  Created by tangwei1 on 15/12/1.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import <Foundation/Foundation.h>

/*******************************************************
                    数据存储类
 *******************************************************/

@class Location;
@interface DataManager : NSObject

+ (id)sharedInstance;

- (void)saveLocation:(Location *)aLocation;
- (Location *)currentLocation;

- (void)saveTags:(NSArray *)tags;
- (NSArray *)currentTags;

@end
