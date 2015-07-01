//
//  TGPopupContentAnimator.m
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 7/1/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGPopupContentAnimator.h"

@implementation TGPopupContentAnimator

#pragma mark - Overwrite constraints

- (NSArray *)horizontalConstraintsForView:(UIView *)view {
    return [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[bar]-20-|"
                                                   options:0
                                                   metrics:nil
                                                     views:@{@"bar" : view}];
}

- (NSArray *)verticalConstraintsForView:(UIView *)view {
    return [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-40-[bar]-40-|"
                                                   options:0
                                                   metrics:nil
                                                     views:@{@"bar" : view}];
}

@end
