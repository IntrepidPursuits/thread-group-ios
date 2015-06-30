//
//  TGAddProductViewController.h
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 6/25/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TGAddProductViewController;
@class TGRouterItem;
@class TGDevice;

@protocol TGAddProductViewControllerDelegate <NSObject>
- (void)addProductDidCancelAddingRequest:(TGAddProductViewController *)addProductViewController;
@end

@interface TGAddProductViewController : UIViewController

@property (nonatomic, weak) id<TGAddProductViewControllerDelegate> delegate;
- (void)setDevice:(TGDevice *)device andRouter:(TGRouterItem *)router;
//Should make it so that when the view is being shown, we should start animationg and we can stop animating when we are done with the view.
@end
