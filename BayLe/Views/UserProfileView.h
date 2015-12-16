//
//  UserProfileView.h
//  BayLe
//
//  Created by tangwei1 on 15/12/10.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;
@interface UserProfileView : UIView

@property (nonatomic, retain) User* user;

- (void)addTarget:(id)target action:(SEL)action;

@end
