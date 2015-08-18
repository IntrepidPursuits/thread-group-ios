//
//  TGTransitioningDelegate.h
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 8/12/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

@import UIKit;
#import <Foundation/Foundation.h>

@interface TGTransitioningDelegate : UIViewController <UIViewControllerTransitioningDelegate>

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source;
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed;

@end
