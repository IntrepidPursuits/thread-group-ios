//
//  UIImage+ThreadGroup.m
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 6/17/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "UIImage+ThreadGroup.h"

static CGSize const kTGRouterSettingsImageSize = {18.0f, 18.0f};

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

+ (UIImage *)tg_shareAction {
    return [UIImage imageNamed:@"action_share_log"];
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

+ (UIImage *)tg_selectDeviceCompleted {
    return [UIImage imageNamed:@"steps_device_completed"];
}

+ (UIImage *)tg_selectDeviceError {
    return [UIImage imageNamed:@"steps_error"];
}

+ (UIImage *)tg_selectPassphraseActive {
    return [UIImage imageNamed:@"steps_code_active"];
}

+ (UIImage *)tg_selectQRCodeActive {
    return [UIImage imageNamed:@"steps_device_active"];
}

+ (UIImage *)tg_spinner {
    return [UIImage imageNamed:@"steps_cancel_spinner"];
}

+ (UIImage *)tg_tutorialView {
    return [UIImage imageNamed:@"qr_tutorial"];
}

+ (UIImage *)tg_routerSettings {
    return [UIImage imageNamed:@"router_settings" scaledToSize:kTGRouterSettingsImageSize];
}

+ (UIImage *)tg_mainSpinnerClockwise {
    return [UIImage imageNamed:@"spinner_large_clockwise"];
}

+ (UIImage *)tg_mainSpinnerCounterClockwise {
    return [UIImage imageNamed:@"spinner_large_counter_clockwise"];
}

+ (UIImage *)tg_popupSpinnerClockwise {
    return [UIImage imageNamed:@"spinner_small_clockwise"];
}

+ (UIImage *)tg_popupSpinnerCounterClockwise {
    return [UIImage imageNamed:@"spinner_small_counter_clockwise"];
}

+ (UIImage *)tg_popupWhiteSpinnerClockwise {
    return [UIImage imageNamed:@"spinner_small_white_clockwise"];
}

+ (UIImage *)tg_popupWhiteSpinnerCounterClockwise {
    return [UIImage imageNamed:@"spinner_small_white_counter_clockwise"];
}

+ (UIImage *)tg_connectionFailedAlert {
    return [UIImage imageNamed:@"alert_icon"];
}

#pragma mark - helper

+ (UIImage *)imageNamed:(NSString *)name scaledToSize:(CGSize)size {
    UIImage *originalImage = [UIImage imageNamed:name];
    UIGraphicsBeginImageContext(size);
    [originalImage drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

@end
