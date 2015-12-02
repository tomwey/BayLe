//
//  DataManager.m
//  BayLe
//
//  Created by tangwei1 on 15/12/1.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import "DataManager.h"
#import "Defines.h"

NSString * const PhotoAssetDidAddNotification = @"PhotoAssetDidAddNotification";
NSString * const PhotoAssetDidRemoveNotification = @"PhotoAssetDidRemoveNotification";

@interface DataManager ()

@property (nonatomic, retain) Location* currentLocation;

@property (nonatomic, retain) NSArray* currentTags;

@property (nonatomic, retain) NSMutableArray* photoAssets;

/** 返回当前已经添加的图片最新位置 */
@property (nonatomic, assign, readwrite) NSInteger currentThumbPosition;

/** 返回总共需要添加的图片数量 */
@property (nonatomic, assign, readwrite) NSUInteger totalThumbs;

@end

@implementation DataManager
{
    NSUInteger _totalPhotos;
}

AW_SINGLETON_IMPL(DataManager)

- (id)init
{
    if (self = [super init]) {
        self.totalThumbs = 10;
    }
    return self;
}

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

- (BOOL)addPhotoAsset:(ALAsset *)asset
{
    if ( [self.photoAssets count] >= self.totalThumbs ) {
        [AWModalAlert say:[NSString stringWithFormat:@"最多只能上传%d张图片", self.totalThumbs] message:@""];
        return NO;
    }
    
    self.currentThumbPosition += 1;
    
    [self.photoAssets addObject:asset];
    [[NSNotificationCenter defaultCenter] postNotificationName:PhotoAssetDidAddNotification object:asset];
    
    return YES;
}

- (void)removePhotoAsset:(ALAsset *)asset
{
    self.currentThumbPosition -= 1;
    [self.photoAssets removeObject:asset];
    [[NSNotificationCenter defaultCenter] postNotificationName:PhotoAssetDidRemoveNotification object:asset];
}

- (NSArray *)currentPhotoAssets
{
    return [NSArray arrayWithArray:self.photoAssets];
}

- (void)clearAllPhotoAssets
{
    self.totalThumbs = 10;
    self.currentThumbPosition = 0;
    
    [self.photoAssets removeAllObjects];
}

- (void)addAllPhotos
{
    self.totalThumbs -= [self.photoAssets count];
    self.currentThumbPosition = 0;
    
    [self.photoAssets removeAllObjects];
}

- (NSMutableArray *)photoAssets
{
    if ( !_photoAssets ) {
        _photoAssets = [[NSMutableArray alloc] init];
    }
    
    return _photoAssets;
}

@end
