//
//  TGAddProductAnimator.m
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 8/14/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGAddProductAnimator.h"
#import "UIDevice+ThreadGroup.h"

@implementation TGAddProductAnimator

- (NSArray *)horizontalConstraintsForView:(UIView *)view {
    return [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[bar]-40-|"
                                                   options:0
                                                   metrics:nil
                                                     views:@{@"bar" : view}];
}

- (NSArray *)verticalConstraintsForView:(UIView *)view {
    NSString *visualFormatString;
    if ([[UIDevice currentDeviceModel] isEqualToString:kUIDeviceHardwareiPhone6PlusString] || [[UIDevice currentDeviceModel] isEqualToString:kUIDeviceHardwareiPhone6String]) {
        visualFormatString = @"V:|-120-[bar]-(>=100)-|";

    } else {
        visualFormatString = @"V:|-80-[bar]-(>=100)-|";
    }
    return [NSLayoutConstraint constraintsWithVisualFormat:visualFormatString
                                                   options:0
                                                   metrics:nil
                                                     views:@{@"bar" : view}];
    
}

@end
