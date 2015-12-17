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

// 公共库
#import "AWMacros.h"
#import "AWUIUtils.h"
#import "AWCustomTabBarController.h"
#import "AWCustomNavBar.h"
#import "UIViewAdditions.h"
#import "UILabel+TextSize.h"
#import "AWCaret.h"
#import "AWPageView.h"
#import "APIManager.h"
#import "APIDictionaryReformer.h"
#import "AWTableViewDataSource.h"
#import "AWMultipleColumnTableViewDataSource.h"
#import "UITableView+LoadEmptyOrErrorHandle.h"
#import "UIImageView+AFNetworking.h"
#import "UITableView+RemoveBlankCells.h"
#import "UITableView+CompatibilityHandle.h"
#import "UIScrollView+AWRefresh.h"
#import "UIButton+CustomTitleLabel.h"
#import "AWModalAlert.h"
#import "NSStringAdditions.h"
#import "AWToast.h"
#import "MBProgressHUD.h"

#pragma mark ------------------------------- 跟项目相关的宏定义 -------------------------------

// 首页产品列表相关的宏定义
#define COLS_PER_ROW_FOR_HOME_ITEM_LIST 2
#define SPACING_FOR_PER_ITEM            10
#define TITLE_HEIGHT_FOR_PER_ITEM       25
#define PRICE_HEIGHT_FOR_PER_ITEM       20

#define THUMB_CONTAINER_HEIGHT          64

// 自定义字体
//"PingFangTC-Medium",
//"PingFangTC-Regular",
//"PingFangTC-Light",
//"PingFangTC-Ultralight",
//"PingFangTC-Semibold",
//"PingFangTC-Thin"
//"CircularAir-Book",
//"CircularAir-Light"

//"Campton-LightDEMO",
//"Campton-BoldDEMO"

#define CUSTOM_BOLD_FONT_NAME @"Campton-BoldDEMO"
#define CUSTOM_FONT_NAME @"Campton-LightDEMO" //@"CircularAir-Book"

// App亮色
#define MAIN_RED_COLOR AWColorFromRGB(251, 64, 78)

#define MAIN_GRAY_COLOR AWColorFromRGB(69, 73, 76)

#define IS_LIGHT_CONTENT_STATUS_BAR 1

#if IS_LIGHT_CONTENT_STATUS_BAR

#define NAVBAR_BG_COLOR             MAIN_RED_COLOR
#define NAVBAR_TEXT_COLOR           [UIColor whiteColor]
#define NAVBAR_HIGHLIGHT_TEXT_COLOR NAVBAR_TEXT_COLOR

#else

#define NAVBAR_BG_COLOR             [UIColor whiteColor]
#define NAVBAR_TEXT_COLOR           MAIN_GRAY_COLOR
#define NAVBAR_HIGHLIGHT_TEXT_COLOR MAIN_RED_COLOR

#endif

#define APP_ID @""

// 浅灰色
#define MAIN_LIGHT_GRAY_COLOR [UIColor lightGrayColor]

// 背景颜色
#define MAIN_CONTENT_BG_COLOR AWColorFromRGB(235, 236, 237)

// 主要的文字颜色
#define MAIN_TITLE_TEXT_COLOR MAIN_GRAY_COLOR

// 此主要的文字颜色
#define MAIN_SUBTITLE_TEXT_COLOR AWColorFromRGB(111, 117, 117)

// 最大的图片上传数
#define UPLOAD_MAX_COUNT 10

// 高德地图API Key
#define MAMAP_API_KEY @"14f062a0bc5bac1a8bfd247a8db0aac5"

/** 服务器API接口 **/
#define API_TAGS        @"/v1/tags.json"
#define API_LOAD_ITEMS  @"/v1/items/nearby.json"
#define API_CREATE_ITEM @"/v1/items/create.json"

#define API_USER_LOGIN  @"/v1/account/login"
#define API_FETCH_CODE  @"/v1/auth_codes/fetch"
#define API_LOAD_USER   @"/v1/user/me"
#define API_UPDATE_USER @"/v1/user/update_profile"

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
