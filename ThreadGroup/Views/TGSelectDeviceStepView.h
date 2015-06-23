//
//  TGSelectDeviceStepView.h
//  ThreadGroup
//
//  Created by Patrick Butkiewicz on 6/12/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TGDevice;

typedef NS_ENUM(NSUInteger, TGSelectDeviceStepViewContentMode) {
    TGSelectDeviceStepViewContentModeScanQRCodeInvalid,
    TGSelectDeviceStepViewContentModeScanQRCode,
    TGSelectDeviceStepViewContentModeConnectCodeInvalid,
    TGSelectDeviceStepViewContentModeConnectCode,
    TGSelectDeviceStepViewContentModeComplete
};

@protocol TGSelectDeviceStepViewDelegate;

@interface TGSelectDeviceStepView : UIView

@property (nonatomic, weak) id<TGSelectDeviceStepViewDelegate> delegate;
@property (nonatomic, assign) TGSelectDeviceStepViewContentMode contentMode;

+ (CGFloat)heightForContentMode:(TGSelectDeviceStepViewContentMode)contentMode;

@end

@protocol TGSelectDeviceStepViewDelegate <NSObject>

- (void)TGSelectDeviceStepViewDidTapConfirmButton:(TGSelectDeviceStepView *)stepView validateWithDevice:(TGDevice *)device;
- (void)TGSelectDeviceStepViewDidTapScanCodeButton:(TGSelectDeviceStepView *)stepView;

@end