//
//  SelectLocationViewController.m
//  BayLe
//
//  Created by tangwei1 on 15/12/1.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import "SelectLocationViewController.h"
#import "Defines.h"

@interface SelectLocationViewController () <UITableViewDelegate>

@property (nonatomic, retain) AWTableViewDataSource* dataSource;

@end

@implementation SelectLocationViewController
{
    UITextField* _searchField;
    UITableView* _tableView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ( self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil] ) {
        self.shouldSearching = YES;
    }
    return self;
}

- (void)dealloc
{
    self.dataSource = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"搜索";
    
//    self.shouldSearching = YES;
    
    self.dataSource = AWTableViewDataSourceCreate(nil, @"POICell", @"poi.cell");
    
    // 设置导航条按钮
    UIButton* closeBtn = AWCreateTextButton(CGRectMake(0, 0, 40, 30), @"取消", [UIColor whiteColor], self, @selector(close));
    [[closeBtn titleLabel] setFont:[UIFont systemFontOfSize:14]];
    self.navBar.rightButton = closeBtn;
    
    // 添加搜索框
    [self initSearchBar];
    
    // 添加表视图
    [self initTableView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_searchField becomeFirstResponder];
}

- (void)initTableView
{
    _tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0,
                                                               _searchField.bottom + 6,
                                                               self.contentView.width,
                                                                self.contentView.height - _searchField.bottom - 6)
                                              style:UITableViewStylePlain] autorelease];
    [self.contentView addSubview:_tableView];
    
    [_tableView removeBlankCells];
    
    _tableView.hidden = YES;
    
    _tableView.rowHeight = 58;
    
    _tableView.delegate = self;
    _tableView.dataSource = self.dataSource;
}

- (void)initSearchBar
{
    _searchField = [[UITextField alloc] initWithFrame:CGRectMake(15, 5, AWFullScreenWidth() - 30, 33)];
    [self.contentView addSubview:_searchField];
    [_searchField release];
    
    _searchField.font = AWSystemFontWithSize(14, NO);
    _searchField.textColor = [UIColor darkGrayColor];
    
    _searchField.placeholder = @"输入位置";
    
    _searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [_searchField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    UIView* line = AWCreateLine(CGSizeMake(AWFullScreenWidth(), .6), AWColorFromRGB(241, 241, 241));
    [self.contentView addSubview:line];
    line.y = _searchField.bottom + 5;
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [_searchField resignFirstResponder];
    
    NSDictionary* adInfo = [self.dataSource.dataSource objectAtIndex:indexPath.row];
    
    Location* location = [Location locationWithCity:[[LBSManager sharedInstance] currentLocation].city
                                          placement:[adInfo objectForKey:@"title"]];
    location.coordinate = CLLocationCoordinate2DMake([[[adInfo objectForKey:@"location"] objectForKey:@"lat"] doubleValue],
                                                     [[[adInfo objectForKey:@"location"] objectForKey:@"lng"] doubleValue]);
    
    if ( self.shouldSearching ) {
        [[DataManager sharedInstance] saveLocation:location];
        [self gotoItemList];
    } else {
        if ( [self.delegate respondsToSelector:@selector(didSelectLocation:)] ) {
            [self.delegate didSelectLocation:location];
        }
        [self close];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_searchField resignFirstResponder];
}

#pragma mark - Target Action
- (void)textFieldDidChange:(UITextField *)textField
{
    if ( textField.text.length == 0 ) {
        _tableView.hidden = YES;
    } else if ( [[textField.text trim] length] == 0 ) {
        _tableView.hidden = YES;
    } else {
        __block SelectLocationViewController* me = self;
        
        [[LBSManager sharedInstance] POISearch:textField.text completion:^(NSArray *locations, NSError *aError) {
            [me updateTableView:locations];
        }];
    }
}

- (void)close
{
    UIViewController* me = self.navigationController;
    if ( !me ) {
        me = self;
    }
    
    [me dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private Methods
- (void)gotoItemList
{
    ItemListViewController* ilvc = [[[ItemListViewController alloc] init] autorelease];
    [self.navigationController pushViewController:ilvc animated:YES];
}

- (void)updateTableView:(NSArray *)locations
{
    if ( [locations count] > 0 ) {
        _tableView.hidden = NO;
        self.dataSource.dataSource = locations;
        [_tableView reloadData];
    } else {
        _tableView.hidden = YES;
    }
}

@end
