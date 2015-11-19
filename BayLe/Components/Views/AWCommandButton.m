//
//  CommandButton.m
//  Wallpapers10000+
//
//  Created by tangwei1 on 15/7/15.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import "AWCommandButton.h"

@interface CommandTarget : NSObject

+ (id)sharedInstance;

- (void)btnClicked:(AWCommandButton*)sender;

@end

@implementation CommandTarget

+ (id)sharedInstance
{
    static CommandTarget* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ( !instance ) {
            instance = [[CommandTarget alloc] init];
        }
    });
    return instance;
}

- (void)btnClicked:(AWCommandButton*)sender
{
    [sender.command execute];
}

@end

@implementation AWCommandButton

- (void)dealloc
{
    self.command = nil;
    [super dealloc];
}

@end

AWCommandButton* AWCreateImageCommandButton(NSString* imageName, Command* aCommand)
{
    return AWCreateImageCommandButtonWithSize(imageName, CGSizeZero, aCommand);
}

AWCommandButton* AWCreateImageCommandButtonWithSize(NSString* imageName, CGSize size, Command* aCommand)
{
    AWCommandButton* button = [AWCommandButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button sizeToFit];
    
    button.exclusiveTouch = YES;
    
    button.command = aCommand;
    
    CGRect bounds = CGRectMake(0, 0, size.width, size.height);
    if ( CGRectContainsRect(bounds, button.bounds) ) {
        button.bounds = bounds;
    }
    
    [button addTarget:[CommandTarget sharedInstance]
               action:@selector(btnClicked:)
     forControlEvents:UIControlEventTouchUpInside];
    
    return button;

}

AWCommandButton* AWCreateTextCommandButton(CGRect frame, NSString* title, UIColor* titleColor, Command* aCommand)
{
    AWCommandButton* button = [AWCommandButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];

    button.frame = frame;

    button.exclusiveTouch = YES;

    [button addTarget:[CommandTarget sharedInstance]
               action:@selector(btnClicked:)
     forControlEvents:UIControlEventTouchUpInside];

    return button;
}

UIBarButtonItem* AWCreateImageBarButtonItemWithCommandWithSize(NSString* imageName, CGSize size, Command* aCommand)
{
    return [[[UIBarButtonItem alloc] initWithCustomView:AWCreateImageCommandButtonWithSize(imageName, size, aCommand)] autorelease];
}

UIBarButtonItem* AWCreateImageBarButtonItemWithCommand(NSString* imageName, Command* aCommand)
{
    return [[[UIBarButtonItem alloc] initWithCustomView:AWCreateImageCommandButton(imageName, aCommand)] autorelease];
}
