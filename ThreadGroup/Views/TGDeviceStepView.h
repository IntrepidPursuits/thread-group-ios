//
//  TGDeviceStepView.h
//  ThreadGroup
//
//  Created by Patrick Butkiewicz on 6/10/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TGDeviceStepViewDelegate;

@interface TGDeviceStepView : UIView

@property (nonatomic, weak) id<TGDeviceStepViewDelegate> delegate;
@property (nonatomic, assign) BOOL spinnerActive;

- (void)setBottomBarHidden:(BOOL)hidden;
- (void)setIcon:(UIImage *)icon;
- (void)setTitle:(NSString *)title subTitle:(NSString *)subTitle;
- (void)setTopBarHidden:(BOOL)hidden;

@end

@protocol TGDeviceStepViewDelegate <NSObject>

- (void)TGDeviceStepView:(TGDeviceStepView *)stepView didTapIcon:(id)sender;

@end