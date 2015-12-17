//
//  SearchViewController.m
//  BayLe
//
//  Created by tangwei1 on 15/12/1.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import "SearchViewController.h"
#import "Defines.h"

@implementation SearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"搜索";
    
    UIButton* leftBtn = AWCreateImageButton(nil, self, @selector(back));
    UIImage* image = [[UIImage imageNamed:@"cancel"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [leftBtn setImage:image forState:UIControlStateNormal];
    leftBtn.tintColor = NAVBAR_HIGHLIGHT_TEXT_COLOR;
    self.navBar.leftButton = leftBtn;
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
