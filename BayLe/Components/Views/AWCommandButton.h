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

@property (nonatomic, retain) IBOutlet Command* command;

@end
