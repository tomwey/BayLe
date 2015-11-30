//
//  FavoritesViewController.m
//  BayLe
//
//  Created by tangwei1 on 15/11/19.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import "FavoritesViewController.h"

@implementation FavoritesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"心愿单";
}

- (BOOL)shouldCheckLogin
{
    return YES;
}

@end
