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

@interface TGScannerView : UIView

@property (weak, nonatomic) id<TGScannerViewDelegate> delegate;

- (void)startScanning;
- (void)stopScanning;

@end

@protocol TGScannerViewDelegate <NSObject>

- (void)TGScannerView:(UIView *)scannerView didParseDeviceFromCode:(TGDevice *)device;
- (void)TGScannerViewDidFailParsingDevice:(UIView *)scannerView;

@end