//
//  ThumbView.m
//  BayLe
//
//  Created by tangwei1 on 15/12/2.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import "ThumbView.h"
#import "Defines.h"
#import <objc/runtime.h>

@implementation ThumbView
{
    UIButton* _deleteButton;
    UIImageView* _imageView;
}
- (id)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] ) {
        
        _imageView = AWCreateImageView(nil);
        [self addSubview:_imageView];
        
        _deleteButton = AWCreateImageButton(@"camera_delete_image_icon", self, @selector(delete));
        [self addSubview:_deleteButton];
        
    }
    return self;
}

- (void)setAsset:(ALAsset *)asset
{
    if ( _asset != asset ) {
        [_asset release];
        _asset = [asset retain];
        
        _imageView.image = [UIImage imageWithCGImage:[_asset thumbnail]];
    }
}

- (void)delete
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kThumbViewDidTap2Delete" object:self];
    
    [[DataManager sharedInstance] removePhotoAsset:self.asset];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _deleteButton.center = CGPointMake(_deleteButton.width / 2, _deleteButton.height / 2);
    
    _imageView.frame = CGRectMake(_deleteButton.center.x,
                                  _deleteButton.center.y,
                                  self.width - _deleteButton.width / 2,
                                  self.height - _deleteButton.height / 2);
}

@end

@implementation ALAsset (Index)

static char kAssetIndexKey;

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

@end
