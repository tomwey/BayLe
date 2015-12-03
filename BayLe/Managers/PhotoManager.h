//
//  PhotoManager.h
//  BayLe
//
//  Created by tangwei1 on 15/12/3.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

FOUNDATION_EXTERN NSString * const PhotoAssetDidAddNotification;
FOUNDATION_EXTERN NSString * const PhotoAssetDidRemoveNotification;

@interface PhotoManager : NSObject

+ (id)sharedInstance;

/**
 * 加载相册
 */
- (void)loadAlbumList:(void (^)(NSArray* groups, NSError* error))completion;

/**
 * 加载某一个相册下的照片
 */
- (void)loadPhotosForAlbum:(ALAssetsGroup *)group completion:(void (^)(NSArray* photos, NSError* error))completion;

// 保存图片
- (BOOL)addPhotoAsset:(ALAsset *)asset;
- (void)removePhotoAsset:(ALAsset *)asset;

- (NSArray *)currentPhotoAssets;
- (NSArray *)allPhotoAssets;

- (void)clearAllPhotoAssets;

- (void)pushPhotosToUse;

/** 返回总共需要添加的图片数量 */
@property (nonatomic, assign, readonly) NSUInteger totalThumbs;

@end

@interface ALAsset (CustomProperty)

/** 设置当前索引 */
@property (nonatomic, assign) NSUInteger index;

/** 设置当前资源是否被选中 */
@property (nonatomic, assign) BOOL selected;

@end
