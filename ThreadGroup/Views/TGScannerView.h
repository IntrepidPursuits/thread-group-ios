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
    TGScannerViewContentModeNoCameraAccess,
};

@interface TGScannerView : UIView

@property (weak, nonatomic) id<TGScannerViewDelegate> delegate;
@property (nonatomic) TGScannerViewContentMode contentMode;
@property (nonatomic) BOOL hasCameraAccess;

@end

@protocol TGScannerViewDelegate <NSObject>
- (void)TGScannerView:(UIView *)scannerView didParseDeviceFromCode:(TGDevice *)device;
- (void)TGScannerViewDidFailParsingDevice:(UIView *)scannerView;
- (void)TGScannerView:(UIView *)scannerView didTapInfoButton:(id)sender;
@end