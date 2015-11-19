//
//  BaseViewController.h
//  BayLe
//
//  Created by tomwey on 11/19/15.
//  Copyright (c) 2015 tangwei1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (nonatomic, retain, readonly) UIView* contentView;

@property (nonatomic, assign) BOOL navBarHidden;

+ (UIViewController *)viewControllerWithClassName:(NSString *)className;

@end
