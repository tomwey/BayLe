//
//  ItemListView.m
//  BayLe
//
//  Created by tangwei1 on 15/11/24.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import "ItemListView.h"

@interface ItemListView ()

@property (nonatomic, retain) UITableView* tableView;

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
