//
//  TGDeviceStepView.h
//  ThreadGroup
//
//  Created by Patrick Butkiewicz on 6/10/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TGDeviceStepView : UIView

- (void)setTitle:(NSString *)title subTitle:(NSString *)subTitle;
- (void)setIcon:(UIImage *)icon;
- (void)setTopBarHidden:(BOOL)hidden;
- (void)setBottomBarHidden:(BOOL)hidden;

@end
