//
//  PhotoManager.m
//  BayLe
//
//  Created by tangwei1 on 15/12/3.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import "PhotoManager.h"
#import <objc/runtime.h>
#import "Defines.h"

NSString * const PhotoAssetDidAddNotification = @"PhotoAssetDidAddNotification";
NSString * const PhotoAssetDidRemoveNotification = @"PhotoAssetDidRemoveNotification";

@interface PhotoManager ()

@property (nonatomic, retain, readonly) ALAssetsLibrary* assetsLibrary;

@property (nonatomic, retain) NSMutableArray* photoAssets;

@property (nonatomic, retain) NSMutableArray* totalPhotoAssets;

/** 返回总共需要添加的图片数量 */
@property (nonatomic, assign, readwrite) NSUInteger totalThumbs;

@end

@implementation PhotoManager

@synthesize assetsLibrary = _assetsLibrary;

AW_SINGLETON_IMPL(PhotoManager)

- (id)init
{
    if (self = [super init]) {
        self.totalThumbs = UPLOAD_MAX_COUNT;
    }
    return self;
}

/**
 * 加载相册
 */
- (void)loadAlbumList:(void (^)(NSArray* groups, NSError* error))completion
{
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
        if ( [error code] == ALAssetsLibraryAccessGloballyDeniedError ||
            [error code] == ALAssetsLibraryAccessUserDeniedError ) {
            if ( completion ) {
                completion(nil, error);
            }
        }
        
        NSLog(@"error: %@", error);
    };
    
    NSMutableArray* groups = [NSMutableArray array];
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup* group, BOOL *stop) {
        ALAssetsFilter* onlyPhotosFilter = [ALAssetsFilter allPhotos];
        [group setAssetsFilter:onlyPhotosFilter];
        
        if ( [group numberOfAssets] > 0 ) {
            [groups addObject:group];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ( completion ) {
                    completion(groups, nil);
                }
            });
        }
    };
    
    NSUInteger groupTypes = ALAssetsGroupAlbum | ALAssetsGroupSavedPhotos | ALAssetsGroupEvent | ALAssetsGroupFaces;
    [self.assetsLibrary enumerateGroupsWithTypes:groupTypes usingBlock:listGroupBlock failureBlock:failureBlock];
}

/**
 * 加载某一个相册下的照片
 */
- (void)loadPhotosForAlbum:(ALAssetsGroup *)group completion:(void (^)(NSArray* photos, NSError* error))completion
{
    NSMutableArray* assets = [NSMutableArray array];
    ALAssetsGroupEnumerationResultsBlock resultsBlock = ^(ALAsset* result, NSUInteger index, BOOL *stop) {
        if ( result ) {
            [assets addObject:result];
        }
    };
    [group setAssetsFilter:[ALAssetsFilter allPhotos]];
    [group enumerateAssetsUsingBlock:resultsBlock];
    
    if ( completion ) {
        completion(assets, nil);
    }
}

- (BOOL)addPhotoAsset:(ALAsset *)asset
{
    if ( [self.photoAssets count] >= self.totalThumbs ) {
        [AWModalAlert say:[NSString stringWithFormat:@"最多只能上传%d张图片", self.totalThumbs] message:@""];
        return NO;
    }
    
    [self.photoAssets addObject:asset];
    [[NSNotificationCenter defaultCenter] postNotificationName:PhotoAssetDidAddNotification object:asset];
    
    return YES;
}

- (void)removePhotoAsset:(ALAsset *)asset
{
    if ( [self.photoAssets count] == 0 ) {
        [self.totalPhotoAssets removeObject:asset];
        self.totalThumbs = UPLOAD_MAX_COUNT - [self.totalPhotoAssets count]; // 重新计算需要添加的图片数量
    } else {
        [self.photoAssets removeObject:asset];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PhotoAssetDidRemoveNotification object:asset];
}

- (NSArray *)currentPhotoAssets
{
    return [NSArray arrayWithArray:self.photoAssets];
}

- (NSArray *)allPhotoAssets
{
    return [NSArray arrayWithArray:self.totalPhotoAssets];
}

- (void)clearAllPhotoAssets
{
    self.totalThumbs = UPLOAD_MAX_COUNT;
    
    [self.totalPhotoAssets removeAllObjects];
    [self.photoAssets removeAllObjects];
}

- (void)pushPhotosToUse
{
    self.totalThumbs -= [self.photoAssets count];
    
    if ( !self.totalPhotoAssets ) {
        self.totalPhotoAssets = [NSMutableArray array];
    }
    
    [self.totalPhotoAssets addObjectsFromArray:[NSArray arrayWithArray:self.photoAssets]];
    
    for (ALAsset* asset in self.totalPhotoAssets) {
        asset.selected = NO;
    }
    
    [self.photoAssets removeAllObjects];
}

- (NSMutableArray *)photoAssets
{
    if ( !_photoAssets ) {
        _photoAssets = [[NSMutableArray alloc] init];
    }
    
    return _photoAssets;
}

- (ALAssetsLibrary *)assetsLibrary
{
    if ( !_assetsLibrary ) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    return _assetsLibrary;
}

@end









//////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 添加ALAsset扩展
//////////////////////////////////////////////////////////////////////////////////////
@implementation ALAsset (CustomProperty)

static char kAssetIndexKey;
static char kSelectedValueKey;

- (void)setIndex:(NSUInteger)index
{
    objc_setAssociatedObject(self, &kAssetIndexKey, @(index), OBJC_ASSOCIATION_ASSIGN);
}

- (NSUInteger)index
{
    id obj = objc_getAssociatedObject(self, &kAssetIndexKey);
    if ( !obj ) {
        return 0;
    }
    
    return [obj integerValue];
}

- (void)setSelected:(BOOL)selected
{
    objc_setAssociatedObject(self, &kSelectedValueKey, @(selected), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)selected
{
    id val = objc_getAssociatedObject(self, &kSelectedValueKey);
    if ( !val ) {
        return NO;
    }
    
    return [val boolValue];
}

@end
