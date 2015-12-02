//
//  Defines.h
//  BayLe
//
//  Created by tangwei1 on 15/11/19.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#ifndef Defines_h
#define Defines_h

#pragma mark ------------------------------- 导入共用组件库    -------------------------------

// 共用宏
#import "AWMacros.h"
#import "AWUIUtils.h"
#import "AWCustomTabBarController.h"
#import "AWCustomNavBar.h"
#import "UIViewAdditions.h"
#import "UILabelTextSize.h"
#import "AWCaret.h"
#import "AWPageView.h"
#import "APIManager.h"
#import "APIDictionaryReformer.h"
#import "AWTableViewDataSource.h"
#import "AWMultipleColumnTableViewDataSource.h"
#import "LoadEmptyOrErrorHandle.h"
#import "UIImageView+AFNetworking.h"
#import "RemoveBlankCells.h"
#import "CompatibilityHandle.h"
#import "UIScrollView+AWRefresh.h"
#import "AWModalAlert.h"
#import "NSStringAdditions.h"

#pragma mark ------------------------------- 跟项目相关的宏定义 -------------------------------

// 首页产品列表相关的宏定义
#define COLS_PER_ROW_FOR_HOME_ITEM_LIST 2
#define SPACING_FOR_PER_ITEM            10
#define TITLE_HEIGHT_FOR_PER_ITEM       25
#define PRICE_HEIGHT_FOR_PER_ITEM       20

#define THUMB_CONTAINER_HEIGHT 64

// App亮色
#define MAIN_RED_COLOR AWColorFromRGB(251, 64, 78)
// 浅灰色
#define MAIN_LIGHT_GRAY_COLOR [UIColor lightGrayColor]

// 背景颜色
#define MAIN_CONTENT_BG_COLOR AWColorFromRGB(247, 247, 247)

// 高德地图API Key
#define MAMAP_API_KEY @"14f062a0bc5bac1a8bfd247a8db0aac5"

/** 服务器API接口 **/
#define API_TAGS @"/v1/tags.json"
#define API_LOAD_ITEMS @"/v1/items/nearby.json"

#pragma mark ------------------------------- 下面是项目相关的库 -------------------------------

// Utils
#import "Utils.h"

// Models
#import "Models.h"

// Managers
#import "Manager.h"

// Views
#import "Views.h"

// Controllers
#import "Controllers.h"

// 第三方库
#import <MAMapKit/MAMapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AssetsLibrary/AssetsLibrary.h>

#endif /* Defines_h */
