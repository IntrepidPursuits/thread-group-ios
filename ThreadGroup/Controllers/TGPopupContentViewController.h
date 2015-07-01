//
//  TGPopupContentViewController.h
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 6/30/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TGPopupContentViewController;

@protocol TGPopupContentViewControllerDelegate <NSObject>
- (void)popupContentViewControllerDidPressButtonAtIndex:(NSUInteger)index;
@end

@interface TGPopupContentViewController : UIViewController

@property (nonatomic, weak) id<TGPopupContentViewControllerDelegate> delegate;
- (void)setContentTitle:(NSString *)contentTitle andButtons:(NSArray *)buttons;

@end
