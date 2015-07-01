//
//  TGAnimator.m
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 6/26/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGAnimator.h"
#import "UIImage+ThreadGroup.h"

static NSTimeInterval const kTGAnimatorTransitionAnimationDuration = 0.5;

@interface TGAnimator()
@property (nonatomic, strong) id<UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic, strong) UIVisualEffectView *blurBackgroundView;
@end

@implementation TGAnimator

#pragma mark - UIViewControllerAnimatedTransitioning Methods

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return kTGAnimatorTransitionAnimationDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    self.transitionContext = transitionContext;

    //Capture state from the transitionContext
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    UIView *containerView = [transitionContext containerView];

    if (self.type == TGTransitionTypePresent) {
        [self presentWithTransitionContext:transitionContext
                        fromViewController:fromViewController
                          toViewController:toViewController
                           inContainerView:containerView];
    } else if (self.type == TGTransitionTypeDismiss) {
        [self dismissWithTransitionContext:transitionContext
                        fromViewController:fromViewController
                          toViewController:toViewController
                           inContainerView:containerView];
    }
}

#pragma mark - Present

- (void)presentWithTransitionContext:(id <UIViewControllerContextTransitioning>)transitionContext
                  fromViewController:(UIViewController *)fromViewController
                    toViewController:(UIViewController *)toViewController
                     inContainerView:(UIView *)containerView {

    CGRect finalFrame = [transitionContext finalFrameForViewController:toViewController];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    UIView *snapshotFromView = [fromViewController.view snapshotViewAfterScreenUpdates:NO];

    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurBackgroundView = [[UIVisualEffectView alloc] initWithEffect:blur];

    snapshotFromView.frame = finalFrame;
    containerView.frame = finalFrame;
    blurBackgroundView.frame = finalFrame;
    toViewController.view.translatesAutoresizingMaskIntoConstraints = NO;

    [containerView addSubview:snapshotFromView];
    [containerView addSubview:toViewController.view];
    [containerView insertSubview:blurBackgroundView belowSubview:toViewController.view];

    [containerView addConstraints:[self horizontalConstraintsForView:toViewController.view]];
    [containerView addConstraints:[self verticalConstraintsForView:toViewController.view]];

    toViewController.view.transform = CGAffineTransformMakeScale(0.5f, 0.5f);
    toViewController.view.alpha = 0.0f;
    blurBackgroundView.alpha = 0.0f;
    snapshotFromView.alpha = 1.0f;

    [UIView animateWithDuration:duration
                          delay:0.0
         usingSpringWithDamping:0.8f
          initialSpringVelocity:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         toViewController.view.transform = CGAffineTransformIdentity;
                         toViewController.view.alpha = 1.0f;
                         blurBackgroundView.alpha = 1.0f;
                     } completion:^(BOOL finished) {
                         [transitionContext completeTransition:finished];
                     }];
}

#pragma mark - Dismiss

- (void)dismissWithTransitionContext:(id <UIViewControllerContextTransitioning>)transitionContext
                  fromViewController:(UIViewController *)fromViewController
                    toViewController:(UIViewController *)toViewController
                     inContainerView:(UIView *)containerView {

    NSTimeInterval duration = [self transitionDuration:transitionContext];
    CGRect finalFrame = [transitionContext finalFrameForViewController:toViewController];

    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurBackgroundView = [[UIVisualEffectView alloc] initWithEffect:blur];

    containerView.frame = finalFrame;
    toViewController.view.frame = finalFrame;
    blurBackgroundView.frame = finalFrame;
    fromViewController.view.translatesAutoresizingMaskIntoConstraints = NO;

    [containerView addSubview:toViewController.view];
    [containerView addSubview:blurBackgroundView];
    [containerView addSubview:fromViewController.view];

    [containerView addConstraints:[self horizontalConstraintsForView:fromViewController.view]];
    [containerView addConstraints:[self verticalConstraintsForView:fromViewController.view]];

    [UIView animateWithDuration:duration
                     animations:^{
                         fromViewController.view.transform = CGAffineTransformMakeScale(0.5f, 0.5f);
                         fromViewController.view.alpha = 0.0f;
                         blurBackgroundView.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [blurBackgroundView removeFromSuperview];
                         }
                         [transitionContext completeTransition:finished];
                     }];
}

#pragma mark - Getter

- (NSArray *)horizontalConstraintsForView:(UIView *)view {
    return [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[bar]-40-|"
                                                   options:0
                                                   metrics:nil
                                                     views:@{@"bar" : view}];
}

- (NSArray *)verticalConstraintsForView:(UIView *)view {
    return [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-100-[bar]-(>=100)-|"
                                                   options:0
                                                   metrics:nil
                                                     views:@{@"bar" : view}];

}


@end
