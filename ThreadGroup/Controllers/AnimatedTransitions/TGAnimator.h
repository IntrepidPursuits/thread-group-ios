//
//  TGAnimator.h
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 6/26/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TGTransitionType) {
    TGTransitionTypePresent,
    TGTransitionTypeDismiss
};

/**
 *  To use: Remember to set the parent rootViewController as the transitioningDelegate. And the modalPresentationStyle to custom.
 */
@interface TGAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic) TGTransitionType type;

- (NSArray *)verticalConstraintsForView:(UIView *)view;
- (NSArray *)horizontalConstraintsForView:(UIView *)view;

@end
