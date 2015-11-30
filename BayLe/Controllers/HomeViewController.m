//
//  HomeViewController.m
//  BayLe
//
//  Created by tangwei1 on 15/11/19.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import "HomeViewController.h"
#import "Defines.h"

@interface HomeViewController () <AWPageViewDataSource, AWPageViewDelegate, APIManagerDelegate>
{
    UILabel* _locationLabel;
    AWCaret* _caret;
    
    UILabel* _cityLabel;
    
    PagerTabStripper* _tabStripper;
    AWPageView*       _pageView;
}

@property (nonatomic, retain) APIManager* tagsAPIManager;

@property (nonatomic, copy) NSArray* tags;

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
    
    self.contentView.backgroundColor = AWColorFromRGB(251, 251, 251);
    
    // 设置右边导航按钮
    [self setupRightButton];
    
    // 设置标题视图
    [self setupTitleView];
    
    // 添加导航条左边位置显示
    _cityLabel = AWCreateLabel(CGRectZero, nil, NSTextAlignmentLeft, _locationLabel.font, _locationLabel.textColor);
    [self.navBar addSubview:_cityLabel];
    _cityLabel.text = @"城市";
    [_cityLabel sizeToFit];
    _cityLabel.center = CGPointMake(15 + _cityLabel.width / 2, self.navBar.height - 22);
    
    // 添加类别
    [self setupCategories];
    
    // 添加水平翻页视图
    [self setupPageView];
    
    [[LBSManager sharedInstance] startUpdatingLocation:^(Location *aLocation, NSError *error) {
        _cityLabel.text = aLocation.city;
        [_cityLabel sizeToFit];
        _cityLabel.center = CGPointMake(15 + _cityLabel.width / 2, self.navBar.height - 22);
        
        _locationLabel.text = aLocation.placement;
        
        // 加载数据
        [self loadData];
    }];
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
    
//    ItemListView* listView = (ItemListView *)[page viewWithTag:991];
//    [listView startLoadingItems];
}

- (void)pageView:(AWPageView *)pageView didScrollDelta:(CGFloat)dt
{
//    NSLog(@"Delta: %f", dt);
//    [_tabStripper scrollTo:dt];
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
    
    listView.tagID = [[[self.tags objectAtIndex:index] objectForKey:@"id"] integerValue];
    
    return cell;
}

#pragma mark --- APIManager Delegate ---
/** 网络请求成功回调 */
- (void)apiManagerDidSuccess:(APIManager *)manager
{
    NSLog(@"result: %@", [manager fetchDataWithReformer:nil]);
    self.tags = [manager fetchDataWithReformer:[[[APIDictionaryReformer alloc] init] autorelease]];
    NSMutableArray* titles = [NSMutableArray array];
    for (id obj in self.tags) {
        [titles addObject:[obj objectForKey:@"name"]];
    }
    
    _tabStripper.titles = titles;
    _tabStripper.hidden = NO;
    
    [_pageView reloadData];
}

/** 网络请求失败回调 */
- (void)apiManagerDidFailure:(APIManager *)manager
{
    NSLog(@"error: %@", manager.apiError);
}

#pragma mark --- Private Methods ---
- (void)loadData
{
    if ( [self.tagsAPIManager isLoading] ) {
        return;
    }
    
    if ( !self.tagsAPIManager ) {
        self.tagsAPIManager = [APIManager apiManagerWithDelegate:self];
    }
    
    [self.tagsAPIManager cancelRequest];
    
    [self.tagsAPIManager sendRequest:APIRequestCreate(API_TAGS, RequestMethodGet, nil)];
}

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
                                   AWSystemFontWithSize(15, YES),
                                   [UIColor whiteColor]);
    [titleView addSubview:_locationLabel];
    
    _locationLabel.text = @"定位中...";
    
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
