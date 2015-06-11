//
//  CABasicAnimation+TGSpinner.m
//  ThreadGroup
//
//  Created by Patrick Butkiewicz on 6/11/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "CABasicAnimation+TGSpinner.h"

static CGFloat kAnimationSpinDuration = 2.0f;
static CGFloat kAnimationSpinSpeed = 1.0f;

@implementation CABasicAnimation (TGSpinner)

+ (CABasicAnimation *)clockwiseRotationAnimation {
    CABasicAnimation *animation;
    animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.fromValue = @(0);
    animation.duration = kAnimationSpinDuration;
    animation.repeatCount = MAXFLOAT;
    animation.speed = kAnimationSpinSpeed;
    animation.toValue = @((2 * M_PI));
    return animation;
}

+ (CABasicAnimation *)counterClockwiseRotationAnimation {
    CABasicAnimation *animation;
    animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.duration = kAnimationSpinDuration;
    animation.fromValue = @(0);
    animation.repeatCount = MAXFLOAT;
    animation.speed = kAnimationSpinSpeed;
    animation.toValue = @(-(2 * M_PI));
    return animation;
}

@end
