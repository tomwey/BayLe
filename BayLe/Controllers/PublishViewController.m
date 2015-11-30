//
//  PublishViewController.m
//  BayLe
//
//  Created by tangwei1 on 15/11/19.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import "PublishViewController.h"

@implementation PublishViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"发布";
}

- (BOOL)shouldCheckLogin
{
    return YES;
}

@end
