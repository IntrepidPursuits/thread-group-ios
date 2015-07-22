//
//  TGAddDevicePopup.h
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 7/22/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TGAddDevicePopup;

@protocol TGAddDevicePopupDelegate <NSObject>
- (void)didPressAddDevicePopup:(TGAddDevicePopup *)popup;
@end

@interface TGAddDevicePopup : UIView
@property (nonatomic) id<TGAddDevicePopupDelegate> delegate;
@end
