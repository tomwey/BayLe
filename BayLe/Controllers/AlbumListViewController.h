//
//  PhotoListViewController.h
//  BayLe
//
//  Created by tangwei1 on 15/12/2.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import "BaseViewController.h"

@protocol AlbumListViewControllerDelegate <NSObject>

@optional
- (void)didPushPhotosToUse;

@end
@interface AlbumListViewController : BaseViewController

@property (nonatomic, assign) id delegate;

@end
