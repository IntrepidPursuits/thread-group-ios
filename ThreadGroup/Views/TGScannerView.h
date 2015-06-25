//
//  TGScannerView.h
//  ThreadGroup
//
//  Created by Patrick Butkiewicz on 6/23/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TGDevice;
@protocol TGScannerViewDelegate;

typedef NS_ENUM(NSUInteger, TGScannerViewContentMode) {
    TGScannerViewContentModeActiveScanning,
    TGScannerViewContentModeInactive,
    TGScannerViewContentModeTutorial,
};

@interface TGScannerView : UIView

@property (weak, nonatomic) id<TGScannerViewDelegate> delegate;
@property (nonatomic) TGScannerViewContentMode contentMode;

@end

@protocol TGScannerViewDelegate <NSObject>
- (void)TGScannerView:(UIView *)scannerView didParseDeviceFromCode:(TGDevice *)device;
- (void)TGScannerViewDidFailParsingDevice:(UIView *)scannerView;
@end