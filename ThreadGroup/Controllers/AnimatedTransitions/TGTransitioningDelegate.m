//
//  TGTransitioningDelegate.m
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 8/12/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGTransitioningDelegate.h"
#import "TGPopupContentViewController.h"
#import "TGRouterAuthViewController.h"
#import "TGAddProductViewController.h"
#import "TGPasswordViewController.h"

#import "TGAnimator.h"
#import "TGPopupContentAnimator.h"
#import "TGAddProductAnimator.h"

@implementation TGTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    if ([presented isKindOfClass:[TGRouterAuthViewController class]] || [presented isKindOfClass:[TGPasswordViewController class]]) {
        TGAnimator *animator = [TGAnimator new];
        animator.type = TGTransitionTypePresent;
        return animator;
    } else if ([presented isKindOfClass:[TGAddProductViewController class]]){
        TGAnimator *animator = [TGAddProductAnimator new];
        animator.type = TGTransitionTypePresent;
        return animator;
    } else {
        TGPopupContentAnimator *animator = [TGPopupContentAnimator new];
        animator.type = TGTransitionTypePresent;
        return animator;
    }
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    if ([dismissed isKindOfClass:[TGRouterAuthViewController class]] || [dismissed isKindOfClass:[TGPasswordViewController class]]) {
        TGAnimator *animator = [TGAnimator new];
        animator.type = TGTransitionTypeDismiss;
        return animator;
    } else if ([dismissed isKindOfClass:[TGAddProductViewController class]]){
        TGAnimator *animator = [TGAddProductAnimator new];
        animator.type = TGTransitionTypeDismiss;
        return animator;
    }  else {
        TGPopupContentAnimator *animator = [TGPopupContentAnimator new];
        animator.type = TGTransitionTypeDismiss;
        return animator;
    }
}

@end
