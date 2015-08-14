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
    return 10.0;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {    
    //Capture state from the transitionContext
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toViewController.view];
    toViewController.view.alpha = 0;
    
    [UIView animateWithDuration:kTGAnimatorTransitionAnimationDuration animations:^{
        fromViewController.view.transform = CGAffineTransformMakeScale(0.1, 0.1);
        toViewController.view.alpha = 1;
    } completion:^(BOOL finished) {
        fromViewController.view.transform = CGAffineTransformIdentity;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end
