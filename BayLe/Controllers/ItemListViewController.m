//
//  ItemListViewController.m
//  BayLe
//
//  Created by tangwei1 on 15/12/1.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import "ItemListViewController.h"
#import "Defines.h"

@interface ItemListViewController () <AWPageViewDataSource, AWPageViewDelegate>
{
    AWPageView* _pageView;
    PagerTabStripper* _tabStripper;
}

@end
@implementation ItemListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.contentView.backgroundColor = AWColorFromRGB(251, 251, 251);
    
    self.title = [[DataManager sharedInstance] currentLocation].placement;
    
    UIButton* leftBtn = AWCreateTextButton(CGRectMake(0, 0, 40, 30),
                                           @"返回",
                                           [UIColor whiteColor],
                                           self,
                                           @selector(back));
    [[leftBtn titleLabel] setFont:AWSystemFontWithSize(14, NO)];
    self.navBar.leftButton = leftBtn;
    
    // 添加类别
    [self setupCategories];
    
    // 添加水平翻页视图
    [self setupPageView];
}

#pragma mark --- Target Action Methods ---
- (void)tabStripperDidSelect:(PagerTabStripper *)stripper
{
    [_pageView showPageForIndex:stripper.selectedIndex animated:YES];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- AWPageView Delegate ---
- (void)pageView:(AWPageView *)pageView didShowPage:(AWPageViewCell *)page atIndex:(NSInteger)index
{
    NSLog(@"show index: %d", index);
    _tabStripper.selectedIndex = index;
}

#pragma mark --- AWPageView DataSource ---
- (NSUInteger)numberOfPages:(AWPageView *)pageView
{
    return [_tabStripper.titles count];
}

- (AWPageViewCell *)pageView:(AWPageView *)pageView cellAtIndex:(NSInteger)index
{
    AWPageViewCell* cell = [pageView dequeueReusablePageForIndex:index];
    
    if ( !cell ) {
        cell = [[[AWPageViewCell alloc] init] autorelease];
    }
    
    ItemListView* listView = (ItemListView *)[cell viewWithTag:991];
    if ( !listView ) {
        listView = [[[ItemListView alloc] init] autorelease];
        listView.tag = 991;
        [cell addSubview:listView];
        listView.frame = pageView.bounds;
    }
    
    NSArray* tags = [[DataManager sharedInstance] currentTags];
    
    listView.location = [[DataManager sharedInstance] currentLocation];
    listView.tagID = [[[tags objectAtIndex:index] objectForKey:@"id"] integerValue];
    
    return cell;
}

#pragma mark -- Private Methods --
- (void)setupPageView
{
    AWPageView* pageView = [[[AWPageView alloc] init] autorelease];
    [self.contentView addSubview:pageView];
    pageView.frame = CGRectMake(0, _tabStripper.bottom, AWFullScreenWidth(), self.contentView.height - _tabStripper.height);
    
    pageView.dataSource = self;
    pageView.delegate = self;
    
    _pageView = pageView;
}

- (void)setupCategories
{
    PagerTabStripper* tabStripper = [[[PagerTabStripper alloc] init] autorelease];
    [self.contentView addSubview:tabStripper];
    tabStripper.frame = CGRectMake(0, 0, AWFullScreenWidth(), 37);
    
    tabStripper.titleColor = MAIN_LIGHT_GRAY_COLOR;
    tabStripper.titleFont  = [UIFont systemFontOfSize:14];
    
    tabStripper.selectedIndicatorSize = 1.1;
    tabStripper.selectedTitleColor = tabStripper.selectedIndicatorColor = MAIN_RED_COLOR;
    
    tabStripper.backgroundColor = [UIColor whiteColor];//AWColorFromRGB(221, 221, 221);
    
    [tabStripper bindTarget:self forAction:@selector(tabStripperDidSelect:)];
    
    _tabStripper = tabStripper;
    
    _tabStripper.hidden = YES;
    
    NSArray* tags = [[DataManager sharedInstance] currentTags];
    NSMutableArray* titles = [NSMutableArray array];
    
    for (id obj in tags) {
        [titles addObject:[obj objectForKey:@"name"]];
    }
    
    _tabStripper.titles = titles;
    _tabStripper.hidden = NO;
}

@end
