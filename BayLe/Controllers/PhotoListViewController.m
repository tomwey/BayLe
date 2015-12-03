//
//  PhotoListViewController.m
//  BayLe
//
//  Created by tangwei1 on 15/12/2.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import "PhotoListViewController.h"
#import "Defines.h"

@interface PhotoListViewController ()

@property (nonatomic, retain) AWMultipleColumnTableViewDataSource *dataSource;

@end
@implementation PhotoListViewController

- (void)dealloc
{
    self.assetsGroup = nil;
    self.dataSource  = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    
    UIButton* leftBtn = AWCreateTextButton(CGRectMake(0, 0, 40, 33), @"返回",
                                           [UIColor whiteColor],
                                           self,
                                           @selector(back));
    [[leftBtn titleLabel] setFont:AWSystemFontWithSize(14, NO)];
    self.navBar.leftButton = leftBtn;
    
    [self initTableView];
    
    [self loadPhotoData];
}

- (void)initTableView
{
    self.dataSource = AWMultipleColumnTableViewDataSourceCreate(nil, nil, @"id.cell");
    UITableView* tableView = AWCreateTableView(self.contentView.bounds,
                                               UITableViewStylePlain,
                                               self.contentView,
                                               self.dataSource);
    
    self.dataSource.numberOfItemsPerRow = 4;
    self.dataSource.itemClass = @"PhotoView";
    self.dataSource.offsetY = 5;
    self.dataSource.itemSpacing = 5;
    self.dataSource.tableView = tableView;
    
    tableView.height = self.contentView.height - THUMB_CONTAINER_HEIGHT;
    
    CGFloat itemWidth = ( self.contentView.width - ( self.dataSource.numberOfItemsPerRow + 1 ) * self.dataSource.itemSpacing ) / self.dataSource.numberOfItemsPerRow;
    
    self.dataSource.itemSize = CGSizeMake(itemWidth, itemWidth);
    
    tableView.rowHeight = itemWidth + self.dataSource.itemSpacing;
}

- (void)loadPhotoData
{
    [[PhotoManager sharedInstance] loadPhotosForAlbum:self.assetsGroup completion:^(NSArray *assets, NSError *error) {
        if ( !error ) {
            self.dataSource.dataSource = assets;
            
            [self.dataSource notifyDataChanged];
        }
    }];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
