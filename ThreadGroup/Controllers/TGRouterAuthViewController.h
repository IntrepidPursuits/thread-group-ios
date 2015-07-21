//
//  TGRouterAuthViewController.h
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 6/25/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TGRouter;
@class TGRouterAuthViewController;

@protocol TGRouterAuthViewControllerDelegate <NSObject>
- (void)routerAuthenticationSuccessful:(TGRouterAuthViewController *)routerAuthenticationView;
- (void)routerAuthenticationCanceled:(TGRouterAuthViewController *)routerAuthenticationView;
@end

@interface TGRouterAuthViewController : UIViewController
@property (nonatomic, weak) id<TGRouterAuthViewControllerDelegate> delegate;
@property (nonatomic, strong) TGRouter *item;
@end
