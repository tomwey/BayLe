//
//  CatalogViewController.m
//  BayLe
//
//  Created by tomwey on 12/1/15.
//  Copyright (c) 2015 tangwei1. All rights reserved.
//

#import "CatalogViewController.h"
#import "Defines.h"

@interface CatalogViewController () <UITableViewDelegate>

@property (nonatomic, retain) AWTableViewDataSource* dataSource;

@end

@implementation CatalogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"类别";
    
    self.dataSource = AWTableViewDataSourceCreate(nil, @"CatalogCell", @"tag.cell");
    
    // 设置导航条按钮
    UIButton* closeBtn = AWCreateTextButton(CGRectMake(0, 0, 40, 30), @"取消", [UIColor whiteColor], self, @selector(close));
    [[closeBtn titleLabel] setFont:[UIFont systemFontOfSize:14]];
    self.navBar.rightButton = closeBtn;
    
    [self initTableView];
}

- (void)initTableView
{
    UITableView* tableView = AWCreateTableView(
                                               CGRectMake(0, 0, self.contentView.width, self.contentView.height),
                                               UITableViewStylePlain,
                                               self.contentView,
                                               self.dataSource);
    
    tableView.delegate = self;
    
    NSArray* tags = [[DataManager sharedInstance] currentTags];
    self.dataSource.dataSource = tags;
    
    [tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id catalog = [[[DataManager sharedInstance] currentTags] objectAtIndex:indexPath.row];
    
    if ( [self.delegate respondsToSelector:@selector(didSelectCatalog:)] ) {
        [self.delegate didSelectCatalog:catalog];
    }
    
    [self close];
}

- (void)dealloc
{
    self.dataSource = nil;
    [super dealloc];
}

- (void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
