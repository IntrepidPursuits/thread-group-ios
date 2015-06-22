//
//  UIImage+ThreadGroup.m
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 6/17/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "UIImage+ThreadGroup.h"

@implementation UIImage (ThreadGroup)

+ (UIImage *)tg_navThreadLogo {
    return [UIImage imageNamed:@"nav_thread_logo"];
}

+ (UIImage *)tg_navMoreMenu {
    return [UIImage imageNamed:@"nav_more_menu"];
}

+ (UIImage *)tg_navLogInfo {
    return [UIImage imageNamed:@"nav_log_info"];
}

+ (UIImage *)tg_wifiCompleted {
    return [UIImage imageNamed:@"steps_wifi_completed"];
}

+ (UIImage *)tg_routerActive {
    return [UIImage imageNamed:@"steps_router_active"];
}

+ (UIImage *)tg_routerCompleted {
    return [UIImage imageNamed:@"steps_router_completed"];
}

+ (UIImage *)tg_cancelButton {
    return [UIImage imageNamed:@"steps_cancel_button"];
}

@end
