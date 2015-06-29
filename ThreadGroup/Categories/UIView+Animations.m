//
//  UIView+Animations.m
//  ThreadGroup
//
//  Created by Patrick Butkiewicz on 6/23/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "UIView+Animations.h"

static CGFloat TGAnimationSpinDuration = 2.0f;
static CGFloat TGAnimationSpinSpeed = 1.0f;

@implementation UIView (Animations)

- (void)threadGroup_animatePopup {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation
                                      animationWithKeyPath:@"transform"];
    
    CATransform3D scale1 = CATransform3DMakeScale(0.5, 0.5, 1);
    CATransform3D scale2 = CATransform3DMakeScale(1.2, 1.2, 1);
    CATransform3D scale3 = CATransform3DMakeScale(0.9, 0.9, 1);
    CATransform3D scale4 = CATransform3DMakeScale(1.0, 1.0, 1);
    
    NSArray *frameValues = [NSArray arrayWithObjects:
                            [NSValue valueWithCATransform3D:scale1],
                            [NSValue valueWithCATransform3D:scale2],
                            [NSValue valueWithCATransform3D:scale3],
                            [NSValue valueWithCATransform3D:scale4],
                            nil];
    [animation setValues:frameValues];
    
    NSArray *frameTimes = [NSArray arrayWithObjects:
                           [NSNumber numberWithFloat:0.0],
                           [NSNumber numberWithFloat:0.5],
                           [NSNumber numberWithFloat:0.9],
                           [NSNumber numberWithFloat:1.0],
                           nil];
    [animation setKeyTimes:frameTimes];
    
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = .5;
    
    [self.layer addAnimation:animation forKey:@"popup"];
}

- (void)threadGroup_animateClockwise {
    CABasicAnimation *animation;
    animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.fromValue = @(0);
    animation.duration = TGAnimationSpinDuration;
    animation.repeatCount = MAXFLOAT;
    animation.speed = TGAnimationSpinSpeed;
    animation.toValue = @((2 * M_PI));
    [self.layer addAnimation:animation forKey:@"spin"];
}

- (void)threadGroup_animateCounterClockwise {
    CABasicAnimation *animation;
    animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.duration = TGAnimationSpinDuration;
    animation.fromValue = @(0);
    animation.repeatCount = MAXFLOAT;
    animation.speed = TGAnimationSpinSpeed;
    animation.toValue = @(-(2 * M_PI));
    [self.layer addAnimation:animation forKey:@"spin"];
}

@end
