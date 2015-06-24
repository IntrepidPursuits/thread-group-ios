//
//  TGRouterAuthenticationView.h
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 6/23/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TGRouterAuthenticationView;
@class TGRouterItem;

@protocol TGRouterAuthenticationViewProtocol <NSObject>
- (void)routerAuthenticationSuccessful:(TGRouterAuthenticationView *)routerAuthenticationView;
- (void)routerAuthenticationCanceled:(TGRouterAuthenticationView *)routerAuthenticationView;
@end

@interface TGRouterAuthenticationView : UIView
@property (nonatomic, weak) id<TGRouterAuthenticationViewProtocol> delegate;
@property (nonatomic, strong) TGRouterItem *item;
- (void)resetView;
@end
