//
//  AppDelegate.m
//  BayLe
//
//  Created by tangwei1 on 15/11/19.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import "AppDelegate.h"
#import "Defines.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [MAMapServices sharedServices].apiKey = MAMAP_API_KEY;
    
    // API配置
    [[APIConfig sharedInstance] setStageServer:@"http://lease-goods-stage.afterwind.cn/api/"];
    [[APIConfig sharedInstance] setProductionServer:@"http://lease-goods.afterwind.cn/api"];
    [[APIConfig sharedInstance] setDebugMode:YES];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self initRootUIs];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)initRootUIs
{
    AWCustomTabBarController* tabBarController = [[[AWCustomTabBarController alloc] init] autorelease];
    
    tabBarController.itemTintColor = MAIN_LIGHT_GRAY_COLOR;
    tabBarController.selectedItemTintColor = MAIN_RED_COLOR;
    
    NSArray* controllerNames = @[@"Home", @"Favorites",@"Publish", @"Messages", @"User"];
    NSArray* images = @[@"discovery", @"wishlists", @"publish", @"inbox", @"more"];
    NSMutableArray* controllers = [NSMutableArray arrayWithCapacity:[controllerNames count]];
    for (int i=0; i<[controllerNames count]; i++) {
        UIViewController* controller = [[[NSClassFromString([NSString stringWithFormat:@"%@ViewController", controllerNames[i]]) alloc] init] autorelease];
        
        if ( i == 0 ) {
            controller = [[[UINavigationController alloc] initWithRootViewController:controller] autorelease];
        }
        
        UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"tab_%@_icon", images[i]]];
        controller.customTabBarItem = [[[CustomTabBarItem alloc] initWithTitle:nil
                                                                         image:image
                                                                 selectedImage:nil] autorelease];
        

        [controllers addObject:controller];
    }
    
    tabBarController.viewControllers = controllers;
    
    self.window.rootViewController = tabBarController;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
