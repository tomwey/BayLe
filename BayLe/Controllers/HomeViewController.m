//
//  HomeViewController.m
//  BayLe
//
//  Created by tangwei1 on 15/11/19.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import "HomeViewController.h"
#import "Defines.h"

@interface HomeViewController () <AWPageViewDataSource, AWPageViewDelegate>
{
    UILabel* _locationLabel;
    AWCaret* _caret;
    PagerTabStripper* _tabStripper;
    AWPageView* _pageView;
}
@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ( self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil] ) {
        self.navBarHidden = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置右边导航按钮
    [self setupRightButton];
    
    // 设置标题视图
    [self setupTitleView];
    
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

- (void)changeLocation
{
    
}

- (void)gotoSearch
{
    
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
    return 10;
}

- (AWPageViewCell *)pageView:(AWPageView *)pageView cellAtIndex:(NSInteger)index
{
    AWPageViewCell* cell = [pageView dequeueReusablePageForIndex:index];
    
    if ( !cell ) {
        cell = [[[AWPageViewCell alloc] init] autorelease];
    }
    
    UILabel* label = (UILabel *)[cell viewWithTag:10000];
    if ( !label ) {
        label = AWCreateLabel(CGRectMake(10, 10, 100, 30), nil, NSTextAlignmentLeft,
                              AWSystemFontWithSize(15, NO),
                              [UIColor blackColor]);
        [cell addSubview:label];
        label.tag = 10000;
    }
    
    label.text = [NSString stringWithFormat:@"%d", index+1];
    NSLog(@"显示index:%d", index);
    
    return cell;
}

#pragma mark --- Private Methods ---
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
    tabStripper.selectedTitleColor = tabStripper.selectedIndicatorColor = MAIN_RED_COLOR;
    
    tabStripper.titles = @[@"儿童", @"儿童读物",@"童玩具", @"儿童读物dddddsssssssss",@"儿童sssss", @"儿童读物",@"儿童具", @"儿童读",@"玩具", @"儿童读物"];
    
    tabStripper.backgroundColor = AWColorFromRGB(245, 245, 245);
    
    [tabStripper bindTarget:self forAction:@selector(tabStripperDidSelect:)];
    
    _tabStripper = tabStripper;
}

- (void)setupRightButton
{
    self.navBar.rightButton = AWCreateImageButton(nil, self, @selector(gotoSearch));
    self.navBar.rightButton.tintColor = [UIColor whiteColor];
    [self.navBar.rightButton setImage:
     [[UIImage imageNamed:@"tab_search_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [self.navBar.rightButton sizeToFit];
}

- (void)setupTitleView
{
    UIView* titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.navBar.width * 0.618, 44)];
    self.navBar.titleView = titleView;
    [titleView release];
    
    // 添加位置显示
    _locationLabel = AWCreateLabel(CGRectMake(0, 0, titleView.width, 37),
                                   nil,
                                   NSTextAlignmentCenter,
                                   AWSystemFontWithSize(14, YES),
                                   [UIColor whiteColor]);
    [titleView addSubview:_locationLabel];
    
    _locationLabel.text = @"绿地世纪城";
    
    // 添加倒三角形
    _caret = [[[AWCaret alloc] init] autorelease];
    [titleView addSubview:_caret];
    _caret.frame = CGRectMake(0, 0, 8, 4);
    _caret.center = CGPointMake(titleView.width / 2, _locationLabel.bottom - 5);
    
    // 添加位置切换按钮
    UIButton* changeLocationBtn = AWCreateImageButton(nil, self, @selector(changeLocation));
    changeLocationBtn.frame = CGRectMake(0, 0, MIN(titleView.width, [_locationLabel textSizeForConstrainedSize:titleView.contentSize].width), titleView.height);
    changeLocationBtn.center = CGPointMake(titleView.width / 2, titleView.height / 2);
    [titleView addSubview:changeLocationBtn];
}

@end
