//
//  UIDevice+ThreadGroup.h
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 8/14/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const kUIDeviceHardwareiPhone6PlusString = @"iPhone 6 Plus";
static NSString * const kUIDeviceHardwareiPhone6String = @"iPhone 6";

@interface UIDevice (ThreadGroup)

/**
 *  Return device model such "iPhone 6" or "iPhone 6 Plus"
 *
 */
+ (NSString *)currentDeviceModel;

@end
