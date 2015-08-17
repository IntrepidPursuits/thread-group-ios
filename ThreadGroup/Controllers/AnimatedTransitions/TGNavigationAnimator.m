//
//  TGNavigationAnimator.m
//  ThreadGroup
//
//  Created by Anbita Siregar on 8/14/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGNavigationAnimator.h"

static NSTimeInterval const kTGAnimatorTransitionAnimationDuration = 0.5;

@implementation TGNavigationAnimator

#pragma mark - UIViewControllerAnimatedTransitioning Methods

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return kTGAnimatorTransitionAnimationDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {    
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toViewController.view];
    toViewController.view.alpha = 0;
    
    [UIView animateWithDuration:kTGAnimatorTransitionAnimationDuration animations:^{
        toViewController.view.alpha = 1;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end
