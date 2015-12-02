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

FOUNDATION_EXTERN NSString * const PhotoAssetDidAddNotification;
FOUNDATION_EXTERN NSString * const PhotoAssetDidRemoveNotification;

@class Location, ALAsset;
@interface DataManager : NSObject

+ (id)sharedInstance;

- (void)saveLocation:(Location *)aLocation;
- (Location *)currentLocation;

- (void)saveTags:(NSArray *)tags;
- (NSArray *)currentTags;

// 保存图片
- (BOOL)addPhotoAsset:(ALAsset *)asset;
- (void)removePhotoAsset:(ALAsset *)asset;

- (NSArray *)currentPhotoAssets;
- (void)clearAllPhotoAssets;

- (void)addAllPhotos;

/** 返回当前已经添加的图片最新位置 */
@property (nonatomic, assign, readonly) NSInteger currentThumbPosition;

/** 返回总共需要添加的图片数量 */
@property (nonatomic, assign, readonly) NSUInteger totalThumbs;

@end
