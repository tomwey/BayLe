//
//  ItemListView.m
//  BayLe
//
//  Created by tangwei1 on 15/11/24.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import "ItemListView.h"
#import "Defines.h"

@interface ItemListView () <APIManagerDelegate, ReloadDelegate, CellDataBind, UITableViewDelegate>

@property (nonatomic, retain) UITableView* tableView;
@property (nonatomic, retain) APIManager*  itemsAPIManager;

@property (nonatomic, retain) AWTableViewDataSource* tableViewDataSource;

@end

#define ItemCellReuseIdentifier @"item.cell.identifier"
#define CellClassName @"ItemCell"

@implementation ItemListView

- (id)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] ) {
        
        self.tableView = [[[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain] autorelease];
        [self addSubview:self.tableView];
        self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self.tableView registerClass:NSClassFromString(CellClassName) forCellReuseIdentifier:ItemCellReuseIdentifier];
        
        self.tableView.backgroundColor = AWColorFromRGB(245, 245, 245);
        
        self.tableView.rowHeight = 80;
        
        [self.tableView removeBlankCells];
        [self.tableView removeCompatibility];
    }
    return self;
}

- (void)dealloc
{
    self.tableView.dataSource = nil;
    self.tableView = nil;
    
    self.itemsAPIManager = nil;
    
    self.tableViewDataSource = nil;
    
    [super dealloc];
}

- (void)setTagID:(NSInteger)tagID
{
    if (_tagID == tagID) {
        return;
    }
    
    _tagID = tagID;
    
    // 加载数据
    [self loadDataIfNeeded];
}

- (void)loadDataIfNeeded
{
    [self.tableView removeErrorOrEmptyTips];
    
    if ( !self.itemsAPIManager ) {
        self.itemsAPIManager = [APIManager apiManagerWithDelegate:self];
    }
    
    [self.itemsAPIManager sendRequest:APIRequestCreate(API_LOAD_ITEMS, RequestMethodGet, @{@"location": @"120.123455,34.098763",
                                                                                           @"tag_id": @(_tagID)
                                                                                           })];
}

- (void)bindData:(id)data toCell:(UITableViewCell *)cell
{
    ItemCell* itemCell = (ItemCell *)cell;
    itemCell.data = data;
}

/** 网络请求成功回调 */
- (void)apiManagerDidSuccess:(APIManager *)manager
{
    NSLog(@"result: %@", [manager fetchDataWithReformer:nil]);
    id data = [manager fetchDataWithReformer:[[[APIDictionaryReformer alloc] init] autorelease]];
    if ( [data count] == 0 ) {
        [self.tableView showErrorOrEmptyMessage:@"喔，没有数据哦，快去创建吧！！！" reloadDelegate:nil];
    } else {
        self.tableViewDataSource = AWTableViewDataSourceCreate(data, CellClassName, ItemCellReuseIdentifier);
        self.tableViewDataSource.dataBind = self;
        self.tableView.dataSource = self.tableViewDataSource;
        [self.tableView reloadData];
    }
}

/** 网络请求失败回调 */
- (void)apiManagerDidFailure:(APIManager *)manager
{
    NSLog(@"Error: %@", manager.apiError);
    [self.tableView showErrorOrEmptyMessage:@"喔唷，出错了！\n点击屏幕刷新" reloadDelegate:self];
}

- (void)reloadDataForErrorOrEmpty
{
    [self loadDataIfNeeded];
}

//- (void)setCatalog:(NSString *)catalog
//{
//    if ( _catalog == catalog ) {
//        return;
//    }
//    
//    [_catalog release];
//    _catalog = [catalog copy];
//    
//    // TODO: 加载数据
//}

@end
