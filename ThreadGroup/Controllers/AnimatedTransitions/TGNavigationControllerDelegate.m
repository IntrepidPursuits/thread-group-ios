//
//  TGNavigationControllerDelegate.m
//  ThreadGroup
//
//  Created by Anbita Siregar on 8/14/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGNavigationControllerDelegate.h"
#import "TGNavigationAnimator.h"

@interface TGNavigationControllerDelegate ()

@property (strong, nonatomic) TGNavigationAnimator *animator;
@property (strong, nonatomic) UIPercentDrivenInteractiveTransition *interactionController;

@end

@implementation TGNavigationControllerDelegate

- (void)awakeFromNib {
    [super awakeFromNib];
    self.animator = [TGNavigationAnimator new];
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if (operation == UINavigationControllerOperationPop) {
        return self.animator;
    }
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    return self.interactionController;
}

@end
