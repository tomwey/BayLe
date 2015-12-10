//
//  UserViewController.m
//  BayLe
//
//  Created by tangwei1 on 15/11/19.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import "UserViewController.h"
#import "Defines.h"

@interface UserViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSArray* dataSource;

@end
@implementation UserViewController

- (void)viewDidLoad
{
    self.navBarHidden = YES;
    
    [super viewDidLoad];
    
    self.dataSource = @[@[@"我的乐币记录"],@[@"我发布的", @"我出租的", @"我租借的"],@[@"设置"]];
    
    UITableView* tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    [tableView release];
    
    tableView.dataSource = self;
    tableView.delegate   = self;
    
    [self createTableHeader:tableView];
    
    tableView.backgroundColor = [UIColor clearColor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell.id"];
    if ( !cell ) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell.id"] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.font = AWCustomFont(CUSTOM_FONT_NAME, 16);
    cell.textLabel.textColor = MAIN_TITLE_TEXT_COLOR;
    cell.textLabel.text = self.dataSource[indexPath.section][indexPath.row];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataSource count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

- (void)createTableHeader:(UITableView *)tableView
{
    UIView* headerView = [[[UIView alloc] init] autorelease];
    headerView.backgroundColor = NAVBAR_HIGHLIGHT_TEXT_COLOR;
    
    UIImageView* bgView = AWCreateImageView(nil);
    bgView.backgroundColor = MAIN_RED_COLOR;
    bgView.frame = CGRectMake(0, 0, AWFullScreenWidth(), AWFullScreenWidth() * 0.618);
    
    [headerView addSubview:bgView];
    
    UserProfileView* upv = [[[UserProfileView alloc] init] autorelease];
    [bgView addSubview:upv];
    [upv setUser:nil];
    
    headerView.frame = CGRectMake(0, 0, AWFullScreenWidth(), bgView.height + 50);
    
    // 添加充值、提现按钮
    UIButton* payButton = AWCreateTextButton(CGRectMake(0, 0, AWFullScreenWidth() / 2.5, 44),
                                             @"充值",
                                             MAIN_TITLE_TEXT_COLOR,
                                             self,
                                             @selector(pay));
    [headerView addSubview:payButton];
    [[payButton titleLabel] setFont:AWCustomFont(CUSTOM_FONT_NAME, 16)];
    payButton.center = CGPointMake(AWFullScreenWidth() * 0.25, headerView.height - 25);
    
    // 添加分割线
    UIView* line = AWCreateLine(CGSizeMake(0.6, ( headerView.height - bgView.height ) * 0.618), MAIN_CONTENT_BG_COLOR);
    [headerView addSubview:line];
    line.center = CGPointMake(AWFullScreenWidth() * 0.5, payButton.center.y);
    
    // 添加提现按钮
    UIButton* getButton = AWCreateTextButton(payButton.bounds,
                                             @"提现",
                                             MAIN_TITLE_TEXT_COLOR,
                                             self,
                                             @selector(fetchMoney));
    [headerView addSubview:getButton];
    getButton.center = CGPointMake(AWFullScreenWidth() * 0.75, payButton.midY);
    [[getButton titleLabel] setFont:[[payButton titleLabel] font]];
    tableView.tableHeaderView = headerView;
}

- (void)pay
{
    
}

- (void)fetchMoney
{
    
}

@end
