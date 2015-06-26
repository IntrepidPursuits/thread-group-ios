//
//  TGAnimator.m
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 6/26/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGAnimator.h"
#import "UIImage+ThreadGroup.h"

/**
 *  Duration for transition animation
 */
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

    //Transition properties
    CGRect finalFrame = [transitionContext finalFrameForViewController:toViewController];
    NSTimeInterval duration = [self transitionDuration:transitionContext];

    //Create Image from fromViewController for blur
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.blurBackgroundView = [[UIVisualEffectView alloc] initWithEffect:blur];

    //Add blurBackgroundView to toViewController
    containerView.frame = finalFrame;
    self.blurBackgroundView.frame = finalFrame;
    toViewController.view.translatesAutoresizingMaskIntoConstraints = NO;


    [containerView addSubview:self.blurBackgroundView];
    [self.blurBackgroundView addSubview:toViewController.view];
    //Constrain in a way to allow for the view content to size itself
    [self.blurBackgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[bar]-40-|"
                                                                                    options:0
                                                                                    metrics:nil
                                                                                      views:@{@"bar" : toViewController.view}]];
    [self.blurBackgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-100-[bar]-100-|"
                                                                                    options:0
                                                                                    metrics:nil
                                                                                      views:@{@"bar" : toViewController.view}]];

//    [containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[bar]|"
//                                                                          options:0
//                                                                          metrics:nil
//                                                                            views:@{@"bar" : self.blurBackgroundView}]];
//    [containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bar]|"
//                                                                          options:0
//                                                                          metrics:nil
//                                                                            views:@{@"bar" : self.blurBackgroundView}]];

    //Initiai state of the animation
    toViewController.view.transform = CGAffineTransformMakeScale(0.5, 0.5);
    toViewController.view.alpha = 0;
//    self.blurBackgroundView.alpha = 0;

    //animate
    [UIView animateWithDuration:duration
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         toViewController.view.transform = CGAffineTransformIdentity;
                         toViewController.view.alpha = 1;
//                         self.blurBackgroundView.alpha = 1;
                     } completion:^(BOOL finished) {
                         if (finished) {
                             [transitionContext completeTransition:YES];
                         }
                     }];
}

#pragma mark - Dismiss

- (void)dismissWithTransitionContext:(id <UIViewControllerContextTransitioning>)transitionContext
                  fromViewController:(UIViewController *)fromViewController
                    toViewController:(UIViewController *)toViewController
                     inContainerView:(UIView *)containerView {
    //Transition properties
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    CGRect finalFrame = [transitionContext finalFrameForViewController:toViewController];

    //Add views and background
    [containerView addSubview:toViewController.view];

    containerView.frame = finalFrame;
    toViewController.view.frame = finalFrame;
    self.blurBackgroundView.frame = finalFrame;
    fromViewController.view.translatesAutoresizingMaskIntoConstraints = NO;


    [containerView addSubview:self.blurBackgroundView];
    [self.blurBackgroundView addSubview:fromViewController.view];
    //Constrain in a way to allow for the view content to size itself
    [self.blurBackgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[bar]-40-|"
                                                                                    options:0
                                                                                    metrics:nil
                                                                                      views:@{@"bar" : fromViewController.view}]];
    [self.blurBackgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-100-[bar]-100-|"
                                                                                    options:0
                                                                                    metrics:nil
                                                                                      views:@{@"bar" : fromViewController.view}]];


    // Animate with keyframes
    [UIView animateWithDuration:duration
                     animations:^{
                         fromViewController.view.transform = CGAffineTransformMakeScale(0.9, 0.9);
                         fromViewController.view.alpha = 0.0;
                         self.blurBackgroundView.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         [self.blurBackgroundView removeFromSuperview];
                         self.blurBackgroundView = nil;
                         [transitionContext completeTransition:YES];
                     }];
}

@end
