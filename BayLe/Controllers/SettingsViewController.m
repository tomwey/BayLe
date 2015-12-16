//
//  SettingsViewController.m
//  EAT
//
//  Created by tangwei1 on 15/5/12.
//  Copyright (c) 2015年 KeKeStudio. All rights reserved.
//

#import "SettingsViewController.h"
#import "Defines.h"

@interface SettingsViewController () <UITableViewDataSource, UITableViewDelegate>
{
    UITableView* _tableView;
}

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    
//    self.view.backgroundColor = RGB(235, 235, 235);
    
    self.navBar.leftButton = AWCreateTextButton(CGRectMake(0, 0, 40, 40),
                                                @"返回",
                                                NAVBAR_HIGHLIGHT_TEXT_COLOR,
                                                self,
                                                @selector(back));
    
    UITableView* tableView = [[UITableView alloc] initWithFrame:self.contentView.bounds
                                                          style:UITableViewStylePlain];
    [self.contentView addSubview:tableView];
    tableView.backgroundColor = [UIColor clearColor];
    [tableView release];
    
    tableView.height += self.customTabBar.height;
    
    tableView.dataSource = self;
    tableView.delegate   = self;
    
    tableView.rowHeight = 55;
    
    _tableView = tableView;
    
    [tableView removeCompatibility];
    
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, 174)];
    tableView.tableHeaderView = headerView;
    [headerView release];
    
    tableView.tableFooterView = [[[UIView alloc] init] autorelease];
    
    tableView.contentInset = UIEdgeInsetsMake(0, 0, self.customTabBar.height, 0);
    
    UIImageView* iconView = AWCreateImageView(@"logo.png");
//    iconView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"logo.png" ofType:nil]];
    iconView.frame = CGRectMake(CGRectGetWidth(self.view.bounds) / 2 - 33, 29, 66, 66);
    [headerView addSubview:iconView];
    
    iconView.layer.cornerRadius = 8;
    iconView.clipsToBounds = YES;
    
    UILabel* appNameLabel = AWCreateLabel(CGRectMake(0, CGRectGetMaxY(iconView.frame) + 5,
                                                   CGRectGetWidth(self.view.bounds),
                                                   20),
                                          nil,
                                          NSTextAlignmentCenter,
                                        [UIFont systemFontOfSize:16],
                                        AWColorFromRGB(4, 4, 4));
    appNameLabel.text = @"贝乐";
    [headerView addSubview:appNameLabel];
    
    UILabel* versionLabel = AWCreateLabel(CGRectMake(0, CGRectGetMaxY(appNameLabel.frame) + 5,
                                                   CGRectGetWidth(self.view.bounds),
                                                   20),
                                          nil,
                                          NSTextAlignmentCenter,
                                        [UIFont systemFontOfSize:15],
                                        AWColorFromRGB(132, 132, 132));
    
    versionLabel.text = [NSString stringWithFormat:@"当前版本：%@",
                         [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    [headerView addSubview:versionLabel];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 3;
    }
    else if (section==1){
        return 1;
    }
    else{
        return 0;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return 0.1f;
    return 20.0f;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section==0) {
        return 58;
    }
    else{
        return 58;
    }
}

static NSString* titles[] = { @"意见反馈", @"用户使用协议", @"去评分" };
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellId = @"cellId";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if ( !cell ) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        if ( [cell respondsToSelector:@selector(setLayoutMargins:)] ) {
            cell.layoutMargins= UIEdgeInsetsZero;
        }
    }
    
    
    if (indexPath.section==0) {
        cell.textLabel.text = titles[indexPath.row];
        cell.textLabel.textColor = AWColorFromRGB(63, 63, 63);
        cell.textLabel.font = nil;
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if (indexPath.section==1){
        cell.textLabel.text = @"退出登录";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor redColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else{
    
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section==0) {
        if ( indexPath.row == 0 ) {
            // 意见反馈
            FeedbackViewController* fvc = [[[FeedbackViewController alloc] init] autorelease];
            [self.navigationController pushViewController:fvc animated:YES];
        } else if ( indexPath.row == 1 ) {
            // 用户协议
            AgreementViewController *viewController = [[AgreementViewController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
            [viewController release];
            [self presentViewController:nav animated:YES completion:^{
                
            }];
            [nav release];
        } else if ( indexPath.row == 2 ) {
            // 评价
            AWAppRateus(APP_ID);
        }
        else{
        
        }
    }
    else if ( indexPath.section == 1 ) {
        // 退出登录
        [AWModalAlert ask:@"您确定吗？"
                message:nil
                 result:^(BOOL yesOrNo) {
                     if ( yesOrNo ) {
                         [[UserManager sharedInstance] logout:nil completion:^(id result, NSError *error) {
                             if ( !error ) {
                                 
                             }
                         }];
                         [self back];
                     }
                 }];
    }
    else{
    
    }
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
