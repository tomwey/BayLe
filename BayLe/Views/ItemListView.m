//
//  ItemListView.m
//  BayLe
//
//  Created by tangwei1 on 15/11/24.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import "ItemListView.h"
#import "Defines.h"

@interface ItemListView () <APIManagerDelegate, ReloadDelegate>

@property (nonatomic, retain) UITableView* tableView;
@property (nonatomic, retain) APIManager*  itemsAPIManager;

@property (nonatomic, retain) AWTableViewDataSource* tableViewDataSource;

@property (nonatomic, retain) NSMutableArray* dataSource;

@property (nonatomic, assign) NSUInteger currentPage; // 当前页

@end

#define ItemCellReuseIdentifier @"item.cell.identifier"
#define ItemCellClassName @"UITableViewCell"

@implementation ItemListView

- (id)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] ) {
        
        self.tableView = [[[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain] autorelease];
        [self addSubview:self.tableView];
        self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        self.tableView.backgroundColor = [UIColor clearColor];
        
        // 计算每列的宽度
        CGFloat itemWidth =
        ( AWFullScreenWidth() - ( COLS_PER_ROW_FOR_HOME_ITEM_LIST + 1 ) * SPACING_FOR_PER_ITEM ) / COLS_PER_ROW_FOR_HOME_ITEM_LIST;
        CGFloat itemHeight = itemWidth + TITLE_HEIGHT_FOR_PER_ITEM + PRICE_HEIGHT_FOR_PER_ITEM;
        
        self.tableView.rowHeight = itemHeight + SPACING_FOR_PER_ITEM;
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, SPACING_FOR_PER_ITEM, 0);
        
        // 去除空白的cell
        [self.tableView removeBlankCells];
        [self.tableView removeCompatibility];
        
        [self.tableView resetForGridLayout];
        
        self.tableView.showsVerticalScrollIndicator = NO;
        
        self.currentPage = 1;
        
//        UIRefreshControl* refreshControl = [[[UIRefreshControl alloc] init] autorelease];
//        [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
//        [self.tableView addSubview:refreshControl];
//        
//        refreshControl.tintColor = MAIN_RED_COLOR;
        
        self.dataSource = [NSMutableArray array];
        
        self.tableViewDataSource = AWTableViewDataSourceCreate(self.dataSource, @"ItemCell", ItemCellReuseIdentifier);//AWMultipleColumnTableViewDataSourceCreate(self.dataSource, nil, ItemCellReuseIdentifier);
        
//        self.tableViewDataSource.numberOfItemsPerRow = COLS_PER_ROW_FOR_HOME_ITEM_LIST;
//        self.tableViewDataSource.itemClass = @"SimpleItemView";
//        self.tableViewDataSource.offsetY = SPACING_FOR_PER_ITEM;
//        self.tableViewDataSource.itemSpacing = SPACING_FOR_PER_ITEM;
//        self.tableViewDataSource.itemSize = CGSizeMake(0, self.tableView.rowHeight - SPACING_FOR_PER_ITEM);
        self.tableView.dataSource = self.tableViewDataSource;
        
        self.tableView.rowHeight = [ItemCell cellRowHeight];
        
        self.tableViewDataSource.tableView = self.tableView;
//        self.tableView.dataSource = self.tableViewDataSource;
        
        RefreshHeaderView* header = [[[RefreshHeaderView alloc] init] autorelease];
        __block ItemListView* me = self;
        [self.tableView addHeaderRefreshView:header withCallback:^{
            [me refreshData];
        }];
        
        LoadMoreFooterView* footer = [[[LoadMoreFooterView alloc] init] autorelease];
        [self.tableView addFooterLoadMoreView:footer withCallback:^{
            [me loadNextPage];
        }];
        
    }
    return self;
}

- (void)dealloc
{
    [self.tableView removeHeaderRefreshView];
    
    self.dataSource = nil;
    
    self.tableView = nil;
    self.itemsAPIManager = nil;
    self.tableViewDataSource = nil;
    self.location = nil;
    
    [super dealloc];
}

- (void)setTagID:(NSInteger)tagID
{
    if (_tagID == tagID) {
        return;
    }
    
    _tagID = tagID;
    
    // 加载数据
//    [self loadDataIfNeeded];
    [self.tableView headerRefreshViewBeginRefreshing];
}

- (void)startLoadingItems
{
    [self.tableView headerRefreshViewBeginRefreshing];
}

- (void)refreshData
{
    self.currentPage = 1;
    [self.dataSource removeAllObjects];
    self.tableView.footerLoadMoreViewHidden = NO;
    
    [self loadDataIfNeeded];
}

- (void)loadDataIfNeeded
{
    [self.tableView removeErrorOrEmptyTips];
    
    if ( !self.itemsAPIManager ) {
        self.itemsAPIManager = [APIManager apiManagerWithDelegate:self];
    }
    
    [self.itemsAPIManager cancelRequest];
    
    Location* currentLocation = self.location;
    if ( !currentLocation ) {
        currentLocation = [[LBSManager sharedInstance] currentLocation];
    }
    
    if ( !currentLocation ) {
        [self.tableView headerRefreshViewEndRefreshing];
        return;
    }
    
    [self.itemsAPIManager sendRequest:APIRequestCreate(API_LOAD_ITEMS, RequestMethodGet, @{@"location" : [currentLocation locationString],
                                                                                           @"tag_id" : @(_tagID),
                                                                                           @"page" : @(self.currentPage),
//                                                                                           @"size" : @(5),
                                                                                           })];
}

- (void)loadNextPage
{
    self.currentPage ++;
    
    [self loadDataIfNeeded];
}

/** 网络请求成功回调 */
- (void)apiManagerDidSuccess:(APIManager *)manager
{
    [self.tableView headerRefreshViewEndRefreshing];
    
    [self.tableView footerLoadMoreViewEndLoading];
    
//    NSLog(@"result: %@", [manager fetchDataWithReformer:nil]);
    id data = [manager fetchDataWithReformer:[[[APIDictionaryReformer alloc] init] autorelease]];
    
    if ( [data count] == 0 ) {
        if ( self.currentPage == 1 ) {
            [self.tableView showErrorOrEmptyMessage:@"喔，没有数据哦，快去创建吧！！！" reloadDelegate:self];
        } else {
            self.tableView.footerLoadMoreViewHidden = YES;
            [AWToast showText:@"没有更多数据了"];
        }
    } else {
        [self.dataSource addObjectsFromArray:data];
        [self.tableView reloadData];
    }
}

/** 网络请求失败回调 */
- (void)apiManagerDidFailure:(APIManager *)manager
{
    NSLog(@"Error: %@", manager.apiError);
    if ( self.currentPage == 1 ) {
        [self.tableView showErrorOrEmptyMessage:@"喔唷，出错了！\n点击屏幕刷新" reloadDelegate:self];
    } else {
        [AWToast showText:@"上拉加载失败，请稍后再试!"];
    }
}

- (void)reloadDataForErrorOrEmpty
{
    [self.tableView headerRefreshViewBeginRefreshing];
}

@end
