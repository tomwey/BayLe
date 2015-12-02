//
//  AlbumCell.m
//  BayLe
//
//  Created by tangwei1 on 15/12/2.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import "AlbumCell.h"
#import "Defines.h"

@implementation AlbumCell

- (void)configData:(id)data
{
    ALAssetsGroup* group = (ALAssetsGroup *)data;
    CGImageRef posterImageRef = [group posterImage];
    UIImage* posterImage = [UIImage imageWithCGImage:posterImageRef];
    
    self.imageView.image = posterImage;
    self.textLabel.text = [group valueForProperty:ALAssetsGroupPropertyName];
//    self.detailTextLabel.text = [@(group.numberOfAssets) stringValue];
}

@end
