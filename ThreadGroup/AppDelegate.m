//
//  AppDelegate.m
//  ThreadGroup
//
//  Created by Patrick Butkiewicz on 6/3/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "AppDelegate.h"
#import "TGRootViewController.h"
#import "UIColor+ThreadGroup.h"
#import "UIImage+ThreadGroup.h"
#import "TGMeshcopManager.h"
#import "UIFont+ThreadGroup.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self navigationAppearanceSetup];
    TGRootViewController *homeController = [[TGRootViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:homeController];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = nav;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)navigationAppearanceSetup {
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor] , NSFontAttributeName : [UIFont threadGroup_mediumFontWithSize:17.0f]}];
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setBarTintColor:[UIColor threadGroup_grey]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
}

@end
