//
//  ItemListView.m
//  BayLe
//
//  Created by tangwei1 on 15/11/24.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import "ItemListView.h"
#import "Defines.h"

@interface ItemListView () <APIManagerDelegate>

@property (nonatomic, retain) UITableView* tableView;
@property (nonatomic, retain) APIManager*  itemsAPIManager;

@end

@implementation ItemListView

- (id)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] ) {
        self.tableView = [[[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain] autorelease];
        [self addSubview:self.tableView];
        self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

- (void)dealloc
{
    self.tableView.dataSource = nil;
    self.tableView = nil;
    
    self.itemsAPIManager = nil;
    
//    [_catalog release];
    
    [super dealloc];
}

- (void)setTagID:(NSInteger)tagID
{
    if (_tagID == tagID) {
        return;
    }
    
    _tagID = tagID;
    
    // TODO：加载数据
    [self loadData];
}

- (void)loadData
{
    if ( !self.itemsAPIManager ) {
        self.itemsAPIManager = [APIManager apiManagerWithDelegate:self];
    }
    
    [self.itemsAPIManager sendRequest:APIRequestCreate(API_LOAD_ITEMS, RequestMethodGet, @{@"location": @"120.123455,34.098763",
                                                                                           @"tag_id": @(_tagID)
                                                                                           })];
}

/** 网络请求成功回调 */
- (void)apiManagerDidSuccess:(APIManager *)manager
{
    NSLog(@"result: %@", [manager fetchDataWithReformer:nil]);
}

/** 网络请求失败回调 */
- (void)apiManagerDidFailure:(APIManager *)manager
{
    NSLog(@"Error: %@", manager.apiError);
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
