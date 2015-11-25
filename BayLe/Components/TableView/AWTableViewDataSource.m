//
//  AWTableViewDataSource.m
//  BayLe
//
//  Created by tangwei1 on 15/11/25.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import "AWTableViewDataSource.h"

@implementation AWTableViewDataSource

- (instancetype)initWithArray:(NSArray *)dataSource cellClass:(NSString *)className identifier:(NSString *)identifier
{
    if ( self = [super init] ) {
        self.dataSource = dataSource;
        self.cellClass = className;
        self.identifier = identifier;
        
    }
    return self;
}

+ (instancetype)dataSourceWithArray:(NSArray *)dataSource cellClass:(NSString *)className identifier:(NSString *)identifier
{
    return [[[self alloc] initWithArray:dataSource cellClass:className identifier:identifier] autorelease];
}

- (void)dealloc
{
    self.dataSource = nil;
    self.cellClass  = nil;
    self.identifier = nil;
    
    [super dealloc];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:self.identifier];
    if ( cell == nil ) {
        cell = [[[NSClassFromString(self.cellClass) alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.identifier] autorelease];
    }
    
    id data = [self.dataSource objectAtIndex:indexPath.row];
    
    // 绑定数据到cell
    if ( [self.dataBind respondsToSelector:@selector(bindData:toCell:)] ) {
        [self.dataBind bindData:data toCell:cell];
    }
    
    [cell sizeToFit];
    
    return cell;
}

@end
