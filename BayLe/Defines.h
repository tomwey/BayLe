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
#import "CustomTabBarController.h"
#import "AWCustomNavBar.h"
#import "UIViewAdditions.h"


#pragma mark ------------------------------- 跟项目相关的宏定义 -------------------------------

// App亮色
#define MAIN_COLOR AWColorFromRGB(251, 64, 78)

// 高德地图API Key
#define MAMAP_API_KEY @"14f062a0bc5bac1a8bfd247a8db0aac5"

#pragma mark ------------------------------- 下面是项目相关的库 -------------------------------

// Utils
#import "Utils.h"

// Models
#import "Models.h"

// Views
#import "Views.h"

// Controllers
#import "Controllers.h"

// 第三方库
#import <MAMapKit/MAMapKit.h>

#endif /* Defines_h */
