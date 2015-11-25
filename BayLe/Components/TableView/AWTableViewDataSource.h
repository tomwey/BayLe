//
//  AWTableViewDataSource.h
//  BayLe
//
//  Created by tangwei1 on 15/11/25.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 每行Cell数据绑定协议 */
@protocol CellDataBind <NSObject>

- (void)bindData:(id)data toCell:(UITableViewCell *)cell;

@end

/*********************************************************************
 此UITableView数据源适配器只适用于普通的表视图，并且只有一个分区的表
 如果要支持其他情况，请继承该类，添加相应的功能支持
 *********************************************************************/
@interface AWTableViewDataSource : NSObject <UITableViewDataSource>

/** 设置数据源 */
@property (nonatomic, retain) NSArray* dataSource;

/** 设置UITableViewCell自定义类，如果不设置，默认为UITableViewCell */
@property (nonatomic, copy) NSString* cellClass;

/** 设置cell重用标识 */
@property (nonatomic, copy) NSString* identifier;

/** 设置每行cell数据绑定协议 */
@property (nonatomic, assign) id <CellDataBind> dataBind;

- (instancetype)initWithArray:(NSArray *)dataSource cellClass:(NSString *)cellClassName identifier:(NSString *)identifier;
+ (instancetype)dataSourceWithArray:(NSArray *)dataSource cellClass:(NSString *)cellClassName identifier:(NSString *)identifier;

@end

/** 创建一个自动释放的表视图数据源适配器 */
static inline AWTableViewDataSource* AWTableViewDataSourceCreate(NSArray* dataSource, NSString* cellClass, NSString* identifier)
{
    return [AWTableViewDataSource dataSourceWithArray:dataSource cellClass:cellClass identifier:identifier];
};
