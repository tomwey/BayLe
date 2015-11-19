//
//  CommandButton.h
//  Wallpapers10000+
//
//  Created by tangwei1 on 15/7/15.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Command.h"

@interface AWCommandButton : UIButton

/** 设置一个命令对象 */
@property (nonatomic, retain) IBOutlet Command* command;

@end

/**
 * 创建一个带命令的图片按钮
 * @param imageName 图片名字
 * @param aCommand 命令对象
 * @return 返回一个图片大小的命令按钮
 */
AWCommandButton* AWCreateImageCommandButton(NSString* imageName, Command* aCommand);

/**
 * 创建一个带命令的图片按钮
 * @param imageName 图片名字
 * @param size 图片按钮的大小
 * @param aCommand 命令对象
 * @return 返回一个指定大小的图片按钮
 */
AWCommandButton* AWCreateImageCommandButtonWithSize(NSString* imageName, CGSize size, Command* aCommand);

/**
 * 创建一个带命令的文字按钮
 * @param frame 按钮位置大小
 * @param title 标题
 * @param titleColor 标题颜色
 * @param aCommand 命令对象
 * @return 返回一个指定大小的文字按钮
 */
AWCommandButton* AWCreateTextCommandButton(CGRect frame, NSString* title, UIColor* titleColor, Command* aCommand);

/**
 * 创建带图片的UIBarButtonItem
 * @param imageName 图片名字
 * @param aCommand 要执行的命令对象
 * @return
 */
UIBarButtonItem* AWCreateImageBarButtonItemWithCommand(NSString* imageName, Command* aCommand);

/**
 * 创建带图片的并且指定大小的UIBarButtonItem
 * @param imageName 图片名字
 * @param size 大小
 * @param aCommand 要执行的命令对象
 * @return
 */
UIBarButtonItem* AWCreateImageBarButtonItemWithCommandWithSize(NSString* imageName, CGSize size, Command* aCommand);
