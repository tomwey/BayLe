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

- (void)setupCategories
{
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, AWFullScreenWidth(), 37)];
    [self.contentView addSubview:scrollView];
    [scrollView release];
    
    NSArray* strings = @[@"儿童玩具", @"儿童读物"];
    for (int i=0; i<2; i++) {
        UILabel* label = AWCreateLabel(CGRectMake(AWFullScreenWidth() / 2 * i, 0, AWFullScreenWidth() / 2, 37), nil,
                                       NSTextAlignmentCenter,
                                       [UIFont systemFontOfSize:14],
                                       MAIN_LIGHT_GRAY_COLOR);
        [scrollView addSubview:label];
        
        label.text = strings[i];
        
        UIView* indicator = [[UIView alloc] initWithFrame:CGRectMake(label.left, 35, label.width, 2)];
        indicator.backgroundColor = [UIColor clearColor];
        [scrollView addSubview:indicator];
        [indicator release];
        
        if ( i == 0 ) {
            label.textColor = indicator.backgroundColor = MAIN_RED_COLOR;
        }
    }
    
    scrollView.backgroundColor = AWColorFromRGB(245, 245, 245);
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

- (void)changeLocation
{
    
}

- (void)gotoSearch
{
    
}

@end
