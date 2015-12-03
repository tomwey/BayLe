//
//  PhotoView.m
//  BayLe
//
//  Created by tangwei1 on 15/12/2.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import "PhotoView.h"
#import "Defines.h"
#import <objc/runtime.h>

@interface PhotoView ()

@property (nonatomic, retain, readonly) UIImageView* iconImageView;
@property (nonatomic, retain, readonly) UIImageView* selectedImageView;

@property (nonatomic, retain) ALAsset* asset;

@property (nonatomic, assign) BOOL selected;

@end

@implementation PhotoView

@synthesize iconImageView = _iconImageView;
@synthesize selectedImageView = _selectedImageView;

- (id)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] ) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(photoDidRemove:)
                                                     name:PhotoAssetDidRemoveNotification
                                                   object:nil];
    }
    return self;
}

- (void)configData:(id)data
{
    self.asset = data;
    
    self.asset.selected = [[[PhotoManager sharedInstance] currentPhotoAssets] containsObject:self.asset];
    
    self.iconImageView.image = [UIImage imageWithCGImage:[self.asset thumbnail]];
    
    self.selected = self.asset.selected;
}

- (void)photoDidRemove:(NSNotification *)noti
{
    if ( [self.asset isEqual:noti.object] ) {
        self.selected = NO;
    }
}

- (UIImageView *)iconImageView
{
    if ( !_iconImageView ) {
        _iconImageView = AWCreateImageView(nil);
        [self addSubview:_iconImageView];
        
        [self addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)] autorelease]];
    }
    return _iconImageView;
}

- (UIImageView *)selectedImageView
{
    if ( !_selectedImageView ) {
        _selectedImageView = AWCreateImageView(@"camera_unselected_image_icon");
        [_selectedImageView sizeToFit];
        [self addSubview:_selectedImageView];
        
        [self bringSubviewToFront:_selectedImageView];
    }
    
    return _selectedImageView;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.asset = nil;
    
    [super dealloc];
}

- (void)tap
{
    if ( self.selected ) {
        [[PhotoManager sharedInstance] removePhotoAsset:self.asset];
        self.selected = NO;
    } else {
        self.selected = [[PhotoManager sharedInstance] addPhotoAsset:self.asset];
    }
    
    self.asset.selected = self.selected;
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    
    if ( _selected ) {
        self.selectedImageView.image = [UIImage imageNamed:@"camera_selected_image_icon"];
    } else {
        self.selectedImageView.image = [UIImage imageNamed:@"camera_unselected_image_icon"];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.iconImageView.frame = self.bounds;
    self.selectedImageView.center = CGPointMake(self.width / 2, self.height / 2);
}

@end

@implementation ALAsset (OverrideMethod)

// 重写isEqual方法
- (BOOL)isEqual:(id)object
{
    if ( ![object isKindOfClass:[ALAsset class]] ) {
        return NO;
    }
    
    if ( object == self ) {
        return YES;
    }
    
    return [[object description] isEqualToString:[self description]];
}

@end