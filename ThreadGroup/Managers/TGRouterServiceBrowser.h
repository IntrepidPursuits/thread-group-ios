//
//  TGRouterServiceBrowser.h
//  ThreadGroup
//
//  Created by Patrick Butkiewicz on 7/21/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TGRouter;
@protocol TGRouterServiceBrowserDelegate;

@interface TGRouterServiceBrowser : NSObject
@property (nonatomic, weak) id<TGRouterServiceBrowserDelegate> delegate;
- (void)startSearching;
@end

@protocol TGRouterServiceBrowserDelegate <NSObject>
- (void)TGRouterServiceBrowser:(TGRouterServiceBrowser *)browser didResolveRouter:(TGRouter *)router;
@end
