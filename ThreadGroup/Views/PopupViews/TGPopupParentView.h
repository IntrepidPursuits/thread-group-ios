//
//  TGPopupView.h
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 7/22/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TGPopupParentView;
@protocol TGPopupParentViewDelegate <NSObject>
- (void)parentPopup:(TGPopupParentView *)popupParent didReceiveTouchForChildPopupAtIndex:(NSInteger)index;
@end

@interface TGPopupParentView : UIView
@property (nonatomic) id<TGPopupParentViewDelegate> delegate;
- (void)setPopups:(NSArray *)popups;
- (void)bringChildPopupToFront:(UIView *)childPopup animated:(BOOL)animated;

- (NSInteger)numberOfPopups;
- (UIView *)popupAtIndex:(NSInteger)index;
- (NSInteger)indexOfPopup:(UIView *)popup;

@end
