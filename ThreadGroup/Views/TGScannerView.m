//
//  TGScannerView.m
//  ThreadGroup
//
//  Created by Patrick Butkiewicz on 6/23/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGScannerView.h"
#import "TGDevice.h"
#import <AVFoundation/AVFoundation.h>

@interface TGScannerView() <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@end

@implementation TGScannerView

- (void)awakeFromNib {
    [super awakeFromNib];
    
#if !TARGET_IPHONE_SIMULATOR
    [self configureScanner];
#else
    self.backgroundColor = [UIColor yellowColor];
#endif
}

- (void)configureScanner {
    NSError *error;
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    AVCaptureMetadataOutput *captureMetadataOutput = [AVCaptureMetadataOutput new];
    
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    self.captureSession = [AVCaptureSession new];
    [self.captureSession addInput:input];
    [self.captureSession addOutput:captureMetadataOutput];
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("QRCodeQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    self.videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [self.videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [self.videoPreviewLayer setFrame:self.layer.bounds];
    [self.layer addSublayer:self.videoPreviewLayer];
}

#pragma mark - Public

- (void)startScanning {
    [self.captureSession startRunning];
}

- (void)stopScanning {
    [self.captureSession stopRunning];
}

#pragma mark - AVCaptureDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            TGDevice *device = [TGDevice new];
            device.name = [metadataObj stringValue];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.delegate respondsToSelector:@selector(TGScannerView:didParseDeviceFromCode:)]) {
                    [self.delegate TGScannerView:self didParseDeviceFromCode:device];
                }
            });
        }
    }
}

@end
