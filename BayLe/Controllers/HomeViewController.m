//
//  HomeViewController.m
//  BayLe
//
//  Created by tangwei1 on 15/11/19.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import "HomeViewController.h"
#import "Defines.h"
#import <CoreLocation/CLLocation.h>

@interface HomeViewController () <CLLocationManagerDelegate>
{
    UILabel* _locationLabel;
    AWCaret* _caret;
}
@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ( self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil] ) {
        self.navBarHidden = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置右边导航按钮
    [self setupRightButton];
    
    // 设置标题视图
    [self setupTitleView];
    
    // 添加类别
    [self setupCategories];
}

#pragma mark --- Target Action Methods ---
- (void)tabStripperDidSelect:(PagerTabStripper *)stripper
{
    
}

- (void)changeLocation
{
    
}

- (void)gotoSearch
{
    
}

#pragma mark --- Private Methods ---
- (void)setupCategories
{
    PagerTabStripper* tabStripper = [[[PagerTabStripper alloc] init] autorelease];
    [self.contentView addSubview:tabStripper];
    tabStripper.frame = CGRectMake(0, 0, AWFullScreenWidth(), 37);
    
    tabStripper.titleColor = MAIN_LIGHT_GRAY_COLOR;
    tabStripper.selectedTitleColor = tabStripper.selectedIndicatorColor = MAIN_RED_COLOR;
    
    tabStripper.titles = @[@"儿童玩具", @"儿童读物", @"儿童玩具", @"儿童读物"];
    
    tabStripper.backgroundColor = AWColorFromRGB(245, 245, 245);
    
    [tabStripper bindTarget:self forAction:@selector(tabStripperDidSelect:)];
}

- (void)setupRightButton
{
    self.navBar.rightButton = AWCreateImageButton(nil, self, @selector(gotoSearch));
    self.navBar.rightButton.tintColor = [UIColor whiteColor];
    [self.navBar.rightButton setImage:
     [[UIImage imageNamed:@"tab_search_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [self.navBar.rightButton sizeToFit];
}

- (void)setupTitleView
{
    UIView* titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.navBar.width * 0.618, 44)];
    self.navBar.titleView = titleView;
    [titleView release];
    
    // 添加位置显示
    _locationLabel = AWCreateLabel(CGRectMake(0, 0, titleView.width, 37),
                                   nil,
                                   NSTextAlignmentCenter,
                                   AWSystemFontWithSize(14, YES),
                                   [UIColor whiteColor]);
    [titleView addSubview:_locationLabel];
    
    _locationLabel.text = @"绿地世纪城";
    
    // 添加倒三角形
    _caret = [[[AWCaret alloc] init] autorelease];
    [titleView addSubview:_caret];
    _caret.frame = CGRectMake(0, 0, 8, 4);
    _caret.center = CGPointMake(titleView.width / 2, _locationLabel.bottom - 5);
    
    // 添加位置切换按钮
    UIButton* changeLocationBtn = AWCreateImageButton(nil, self, @selector(changeLocation));
    changeLocationBtn.frame = CGRectMake(0, 0, MIN(titleView.width, [_locationLabel textSizeForConstrainedSize:titleView.contentSize].width), titleView.height);
    changeLocationBtn.center = CGPointMake(titleView.width / 2, titleView.height / 2);
    [titleView addSubview:changeLocationBtn];
}

@end
