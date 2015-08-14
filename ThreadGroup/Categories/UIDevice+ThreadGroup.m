//
//  UIDevice+ThreadGroup.m
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 8/14/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "UIDevice+ThreadGroup.h"
#import <UIDeviceIdentifier/UIDeviceHardware.h>

@implementation UIDevice (ThreadGroup)

+ (NSString *)currentDeviceModel{
    NSString *deviceString = [UIDeviceHardware platformString];
    return deviceString;
}

@end
