//
//  AppDelegate.m
//  ThreadGroup
//
//  Created by Patrick Butkiewicz on 6/3/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "AppDelegate.h"
#import "TGHomeViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    TGHomeViewController *homeController = [[TGHomeViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:homeController];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = navigationController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
