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

static CGFloat const TGScannerViewOverlaySize = 199.0f;
static CGFloat const TGScannerYOffset = 32.0f;

@interface TGScannerView() <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@property (nonatomic, strong) UIImageView *cameraOverlay;
@property (nonatomic, strong) UIView *maskView;

@end

@implementation TGScannerView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configureScanner];
    [self configureOverlay];
    [self configureMask];
    [self setMaskViewEnabled:NO];
}

- (void)configureScanner {
#if TARGET_IPHONE_SIMULATOR
    self.backgroundColor = [UIColor whiteColor];
    return;
#endif
    
    NSError *error;
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    AVCaptureMetadataOutput *captureMetadataOutput = [AVCaptureMetadataOutput new];
    
    if (input == nil) {
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

- (void)configureOverlay {
    self.cameraOverlay = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"camera_overlay"]];
    [self addSubview:self.cameraOverlay];
    [self.cameraOverlay setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-topOffset-[overlayView]->=0-|" options:0 metrics:@{@"topOffset" : @(TGScannerYOffset), @"overlaySize" : @(TGScannerViewOverlaySize)} views:@{@"overlayView" : self.cameraOverlay}]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.cameraOverlay attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0]];
}

- (void)configureMask {
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.maskView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [self addSubview:self.maskView];
    [self.maskView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[maskView]-0-|" options:0 metrics:nil views:@{@"maskView" : self.maskView}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[maskView]-0-|" options:0 metrics:nil views:@{@"maskView" : self.maskView}]];
}

#pragma mark - Public

- (void)setContentMode:(TGScannerViewContentMode)contentMode {
    _contentMode = contentMode;
    switch (contentMode) {
        case TGScannerViewContentModeActiveScanning:
            [self.captureSession startRunning];
            [self setMaskViewEnabled:YES];
            break;
        case TGScannerViewContentModeInactive:
            if ([self.captureSession isRunning]) {
                [self.captureSession stopRunning];
                [self setMaskViewEnabled:NO];
            }
            break;
        case TGScannerViewContentModeTutorial:
            [self setMaskViewEnabled:YES];
            break;
    }
}

- (void)setMaskViewEnabled:(BOOL)enabled {
    CGFloat maskAlpha = (enabled) ? 0 : 1.0f;
    [UIView animateWithDuration:0.5f animations:^{
        self.maskView.alpha = maskAlpha;
    } completion:^(BOOL finished) {
        NSLog(@"Finished %@ Camera", (enabled) ? @"Enabling" : @"Disabling");
    }];
}

#pragma mark - AVCaptureDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            TGDevice *device = [TGDevice new];
            device.name = [metadataObj stringValue];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                BOOL debugSuccess = (arc4random() % 2);
                if (debugSuccess) {
                    if ([self.delegate respondsToSelector:@selector(TGScannerView:didParseDeviceFromCode:)]) {
                        [self.delegate TGScannerView:self didParseDeviceFromCode:device];
                    }
                } else {
                    if ([self.delegate respondsToSelector:@selector(TGScannerViewDidFailParsingDevice:)]) {
                        [self.delegate TGScannerViewDidFailParsingDevice:self];
                    }
                }
            });
        }
    }
}

@end
