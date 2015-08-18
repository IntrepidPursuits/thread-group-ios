//
//  TGNavigationViewController.h
//  ThreadGroup
//
//  Created by Anbita Siregar on 8/12/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TGTransitioningDelegate;

@interface TGNavigationViewController : UIViewController

@property (strong, nonatomic) TGTransitioningDelegate *transitionDelegate;

@end
