//
//  SelectLocationViewController.h
//  BayLe
//
//  Created by tangwei1 on 15/12/1.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import "BaseViewController.h"

@class Location;
@protocol SelectLocationViewControllerDelegate <NSObject>

@optional
- (void)didSelectLocation:(Location *)aLocation;

@end

@interface SelectLocationViewController : BaseViewController

/** 设置是否是搜索功能，默认为YES */
@property (nonatomic, assign) BOOL shouldSearching;

@property (nonatomic, assign) id delegate;

@end
