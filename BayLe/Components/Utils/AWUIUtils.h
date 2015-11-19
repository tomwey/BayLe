//
//  AWUIUtils.h
//  BayLe
//
//  Created by tangwei1 on 15/11/19.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 返回当前设备运行的iOS版本
 */
float AWOSVersion();

/**
 * 返回当前设备运行的iOS版本字符串
 */
NSString* AWOSVersionString();

/**
 * 获取设备名
 */
NSString* AWDeviceName();

/**
 * 获取设备分辨率字符串
 * 例如：1536x2048
 */
NSString* AWDeviceSizeString();

/**
 * 检查当前设备运行的iOS版本是否小于给定的版本
 */
BOOL AWOSVersionIsLower(float version);

/**
 * 判断设备是否是iPad
 */
BOOL AWIsPad();

/**
 * 判断键盘是否显示
 * ##### 已经移到 UIWindowAdditions.h 文件里面去实现
 */
//BOOL AWIsKeyboardVisible();

/**
 * 返回全屏大小
 *
 * 包括状态条的大小
 */
CGRect AWFullScreenBounds();

/**
 * 全屏宽
 */
CGFloat AWFullScreenWidth();

/**
 * 全屏高
 * 包括状态条的高度
 */
CGFloat AWFullScreenHeight();

/**
 * 获取一个矩形的中心点
 */
CGPoint AWCenterOfRect(CGRect aRect);

/**
 * 获取当前app的window
 */

UIWindow* AWAppWindow();

/**
 * 获取app当前版本号
 */
NSString* AWAppVersion();

/**
 * 获取系统字体
 * @param fontSize 字体大小
 * @param isBold 是否加粗
 */
UIFont* AWSystemFontWithSize(CGFloat fontSize, BOOL isBold);

/**
 * 获取自定义字体
 * 注意：需要添加字体文件到工程中，并且在info.plist配置字体文件名字
 * @param fontName 字体名字
 * @param fontSize 字体大小
 */
UIFont* AWCustomFont(NSString* fontName, CGFloat fontSize);

/**
 * 获取RGB颜色
 */
UIColor* AWColorFromRGB(NSUInteger R, NSUInteger G, NSUInteger B);

/**
 * 获取RGBA颜色
 */
UIColor* AWColorFromRGBA(NSUInteger R, NSUInteger G, NSUInteger B, CGFloat A);

/**
 * 从十六进制字符串获取颜色
 * @param hexString 十六进制颜色字符串，例如：#12a13e
 */
UIColor* AWColorFromHex(NSString* hexString);

/**
 * 将图片保存到相册
 * @param anImage 要保存的图片
 * @param groupName 自定义的相册名字
 * @param completionBlock 保存成功的回调块
 * @return
 */
typedef void (^SaveImageCompletionBlock)(BOOL succeed, NSError* error);
void AWSaveImageToPhotosAlbum(UIImage* anImage, NSString* groupName, SaveImageCompletionBlock completionBlock);

/**
 * 设置所有Touch是否打开
 */
void AWSetAllTouchesDisabled(BOOL yesOrNo);

/**
 * 缩放图片
 * @param srcImage 需要缩放的原图片
 * @param newSize 缩放大小
 * @return 返回缩放后的图片
 */
UIImage* AWSimpleResizeImage(UIImage* srcImage, CGSize newSize);

/**
 * 评论app
 * @param appId Apple ID
 */
void AWAppRateus(NSString* appId);

/**
 * 创建按钮
 */
//UIButton* AWCreateImageButton(NSString* imageName, id target, SEL action);
//CommandButton* AWCreateImageCommandButton(NSString* imageName, Command* aCommand);
//
//UIButton* AWCreateImageButtonWithSize(NSString* imageName, CGSize size, id target, SEL action);
//CommandButton* AWCreateImageCommandButtonWithSize(NSString* imageName, CGSize size, Command* aCommand);
//
//UIButton* AWCreateBackgroundImageAndTitleButton(NSString* backgroundImageName, NSString* title, id target, SEL action);
//
//UIButton* AWCreateTextButton(CGRect frame, NSString* title, UIColor* titleColor, id target, SEL action);
//CommandButton* AWCreateTextCommandButton(CGRect frame, NSString* title, UIColor* titleColor, Command* aCommand);

/**
 * 创建UIBarButtonItem
 */
//UIBarButtonItem* AWCreateImageBarButtonItem(NSString* imageName, id target, SEL action);
//UIBarButtonItem* AWCreateImageBarButtonItemWithCommand(NSString* imageName, Command* aCommand);
//
//UIBarButtonItem* AWCreateImageBarButtonItemWithSize(NSString* imageName, CGSize size, id target, SEL action);
//UIBarButtonItem* AWCreateImageBarButtonItemWithCommandWithSize(NSString* imageName, CGSize size, Command* aCommand);

/**
 * 创建UIImageView
 * @param imageName 图片名称
 * @return 返回一个大小为图片大小的图像视图对象
 */
UIImageView* AWCreateImageView(NSString* imageName);

/**
 * 创建UIImageView
 * @param imageName 图片名称
 * @param frame 图片视图位置大小
 */
UIImageView* AWCreateImageViewWithFrame(NSString* imageName, CGRect frame);

/**
 * 创建UILabel
 * @param frame 位置大小
 * @param text 文本内容
 * @param alignment 文本对齐方式 NSTextAlignment
 * @param font 字体
 * @param textColor 字体颜色
 * @return 返回一个没有背景颜色的UILabel对象
 */
UILabel* AWCreateLabel(CGRect frame, NSString* text, NSTextAlignment alignment, UIFont* font, UIColor* textColor);

/**
 * 创建一个表视图
 * @param frame 表的位置大小
 * @param style 表的样式 UITableViewStyle
 * @param superView 添加表视图的容器
 * @param dataSource 表数据源对象
 */
UITableView* AWCreateTableView(CGRect frame, UITableViewStyle style, UIView* superView, id <UITableViewDataSource> dataSource);

/**
 * 创建一根线
 * @param size 线的大小
 * @param color 线的颜色
 */
UIView* AWCreateLine(CGSize size, UIColor* color);

/**
 * 在视图中创建一根线
 * @param size 线的大小
 * @param color 线的颜色
 * @param containerView 线的父视图
 */
UIView* AWCreateLineInView(CGSize size, UIColor* color, UIView* containerView);
