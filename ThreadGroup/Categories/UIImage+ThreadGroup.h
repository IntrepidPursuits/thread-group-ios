//
//  UIImage+ThreadGroup.h
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 6/17/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ThreadGroup)

+ (UIImage *)tg_navThreadLogo;
+ (UIImage *)tg_navMoreMenu;
+ (UIImage *)tg_navLogInfo;

+ (UIImage *)tg_wifiCompleted;
+ (UIImage *)tg_routerActive;
+ (UIImage *)tg_routerCompleted;
+ (UIImage *)tg_cancelButton;

+ (UIImage *)tg_selectDeviceCompleted;
+ (UIImage *)tg_selectDeviceError;
+ (UIImage *)tg_selectQRCodeActive;
+ (UIImage *)tg_selectPassphraseActive;

+ (UIImage *)tg_spinner;
+ (UIImage *)tg_tutorialView;

@end
