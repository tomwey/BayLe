//
//  ItemListView.h
//  BayLe
//
//  Created by tangwei1 on 15/11/24.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Location;
@interface ItemListView : UIView

@property (nonatomic, assign) NSInteger tagID;

@property (nonatomic, retain) Location* location;

- (void)startLoadingItems;

@end
