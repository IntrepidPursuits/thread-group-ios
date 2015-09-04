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
#import "UIFont+ThreadGroup.h"
#import "UIImage+ThreadGroup.h"
#import "UIColor+ThreadGroup.h"
#import "TGNoCameraAccessView.h"
#import "TGQRCodeParser.h"

static CGFloat const TGScannerTutorialButtonInset = 18.0f;
static CGFloat const TGScannerViewOverlayOffset = -65.0f;

@interface TGScannerView() <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@property (nonatomic, strong) UIView *cameraContainer;
@property (nonatomic, strong) UIImageView *cameraOverlay;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *tutorialView;
@property (nonatomic, strong) TGNoCameraAccessView *noCameraAccessView;

@property (nonatomic, strong) UIButton *tutorialButton;

@end

@implementation TGScannerView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configure];
    [self setTutorialViewHidden:YES animated:NO];
}

- (void)configure {
    [self configureScanner];
    [self configureContainer];
    [self configureOverlay];
    [self configureNoCameraAccessView];
    [self configureMask];
    [self configureTutorialView];
}

- (void)configureScanner {
#if TARGET_IPHONE_SIMULATOR
    self.backgroundColor = [UIColor whiteColor];
#else
    NSError *error;
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    AVCaptureMetadataOutput *captureMetadataOutput = [AVCaptureMetadataOutput new];
    
    if (error != nil) {
        NSLog(@"%@", [error localizedDescription]);
        return;
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

    CGRect extendedCameraFrame = self.layer.bounds;
    extendedCameraFrame.size.height += fabs(TGScannerViewOverlayOffset);
    [self.videoPreviewLayer setFrame:extendedCameraFrame];
    [self.layer addSublayer:self.videoPreviewLayer];
#endif
}

- (void)configureContainer {
    [self addSubview:self.cameraContainer];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[container]-0-|" options:0 metrics:nil views:@{@"container" : self.cameraContainer}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[container]-0-|" options:0 metrics:nil views:@{@"container" : self.cameraContainer}]];
    
    self.tutorialButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.tutorialButton addTarget:self action:@selector(tutorialButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.tutorialButton setImage:[UIImage imageNamed:@"action_qr_tutorial"] forState:UIControlStateNormal];
    [self.tutorialButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.cameraContainer addSubview:self.tutorialButton];
    
    [self.cameraContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-Inset-[Button]" options:0 metrics:@{@"Inset" : @(TGScannerTutorialButtonInset)} views:@{@"Button" : self.tutorialButton}]];
    [self.cameraContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.tutorialButton attribute:NSLayoutAttributeRightMargin relatedBy:NSLayoutRelationEqual toItem:self.cameraContainer attribute:NSLayoutAttributeRightMargin multiplier:1.0f constant:-TGScannerTutorialButtonInset]];
}

- (void)configureOverlay {
    self.cameraOverlay = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"camera_overlay"]];
    [self.cameraOverlay setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.cameraContainer addSubview:self.cameraOverlay];
    
    [self.cameraContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.cameraOverlay attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.cameraContainer attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0]];
    [self.cameraContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.cameraOverlay attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.cameraContainer attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0]];
}

- (void)configureMask {
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.maskView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [self.maskView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:self.maskView];
    [self.maskView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSDictionary *views = @{@"maskView" : self.maskView};
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[maskView]-0-|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[maskView]-0-|" options:0 metrics:nil views:views]];
}

- (void)configureTutorialView {
    self.tutorialView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tutorialView setBackgroundColor:[UIColor clearColor]];
    [self.tutorialView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:self.tutorialView];
    
    UILabel *tutorialMessageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [tutorialMessageLabel setBackgroundColor:[UIColor clearColor]];
    [tutorialMessageLabel setFont:[UIFont threadGroup_bookFontWithSize:14.0f]];
    [tutorialMessageLabel setNumberOfLines:0];
    [tutorialMessageLabel setText:@"Point your camera at the device Connect QR Code to scan it"];
    [tutorialMessageLabel setTextColor:[UIColor whiteColor]];
    [tutorialMessageLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.tutorialView addSubview:tutorialMessageLabel];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage tg_tutorialView]];
    [imageView setBackgroundColor:[UIColor clearColor]];
    [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.tutorialView addSubview:imageView];
    
    NSDictionary *metrics = @{@"TextInset" : @16, @"VerticalInset" : @32};
    NSDictionary *views = @{@"ImageView" : imageView, @"MessageLabel" : tutorialMessageLabel, @"Container" : self.tutorialView};
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[Container]-0-|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[Container]-0-|" options:0 metrics:nil views:views]];
    [self.tutorialView addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.tutorialView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [self.tutorialView addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.tutorialView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:16.0f]];
    [self.tutorialView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-TextInset-[MessageLabel]-TextInset-|" options:0 metrics:metrics views:views]];
    [self.tutorialView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=VerticalInset-[ImageView]-VerticalInset-[MessageLabel]->=VerticalInset-|" options:0 metrics:metrics views:views]];
}

- (void)configureNoCameraAccessView {
    self.hasCameraAccess = YES;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied) {
        self.noCameraAccessView = [[TGNoCameraAccessView alloc] init];
        [self.noCameraAccessView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:self.noCameraAccessView];
        
        NSDictionary *views = @{@"View" : self.noCameraAccessView};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[View]-0-|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[View]-0-|" options:0 metrics:nil views:views]];
        self.hasCameraAccess = NO;
    }
}

#pragma mark - Public

- (void)setContentMode:(TGScannerViewContentMode)contentMode {
    [self setContentMode:contentMode animated:YES];
}

- (void)setContentMode:(TGScannerViewContentMode)contentMode animated:(BOOL)animated{
    _contentMode = contentMode;
    switch (contentMode) {
        case TGScannerViewContentModeActiveScanning:
            [self.captureSession startRunning];
            [self setTutorialViewHidden:YES animated:animated];
            break;
        case TGScannerViewContentModeInactive:
            [self.captureSession stopRunning];
            [self setTutorialViewHidden:YES animated:animated];
            [self setMaskViewHidden:NO animated:animated];
            break;
        case TGScannerViewContentModeNoCameraAccess:
            [self.captureSession stopRunning];
            [self setTutorialViewHidden:YES animated:animated];
            break;
        case TGScannerViewContentModeTutorial:
            [self.captureSession stopRunning];
            [self setTutorialViewHidden:NO animated:animated];
            break;
    }
}

#pragma mark - Layout and Animations

- (void)setMaskViewHidden:(BOOL)hidden animated:(BOOL)animated {
    CGFloat maskAlpha = (hidden) ? 0 : 1.0f;
    [UIView animateWithDuration:(animated) ? 0.5f : 0 animations:^{
        self.maskView.alpha = maskAlpha;
    }];
}

- (void)setTutorialViewHidden:(BOOL)hidden animated:(BOOL)animated {
    CGFloat tutorialViewAlpha = (hidden) ? 0 : 1.0f;
    
    [UIView animateKeyframesWithDuration:0.6f delay:0 options:0 animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.5f animations:^{
            self.tutorialView.alpha = tutorialViewAlpha;
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.3f relativeDuration:0.5f animations:^{
            [self setMaskViewHidden:hidden animated:NO];
        }];
    } completion:^(BOOL finished) {
        NSLog(@"Finished %@ Tutorial", (hidden) ? @"Hiding" : @"Showing");
    }];
}

#pragma mark - Button Events

- (void)tutorialButtonTapped:(id)sender {
    if ([self.delegate respondsToSelector:@selector(TGScannerView:didTapInfoButton:)]) {
        [self.delegate TGScannerView:self didTapInfoButton:sender];
    }
}

#pragma mark - AVCaptureDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            [self stopDetection];
            TGQRCode *qrCode = [TGQRCodeParser parseDataFromString:[metadataObj stringValue]];
            TGDevice *device = [[TGDevice alloc] initWithQRCode:qrCode];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (device.qrCode) {
                    if ([self.delegate respondsToSelector:@selector(TGScannerView:didParseDeviceFromCode:)]) {
                        [self.delegate TGScannerView:self didParseDeviceFromCode:device];
                    }
                } else {
                    [self startDetection];
                    if ([self.delegate respondsToSelector:@selector(TGScannerViewDidFailParsingDevice:)]) {
                        [self.delegate TGScannerViewDidFailParsingDevice:self];
                    }
                }
            });
        }
    }
}

#pragma mark - Start/Stop Detection

- (void)startDetection {
    [self.captureSession startRunning];
}

- (void)stopDetection {
    [self.captureSession stopRunning];
}

#pragma mark - Lazy

- (UIView *)cameraContainer {
    if (_cameraContainer == nil) {
        _cameraContainer = [[UIView alloc] initWithFrame:CGRectZero];
        [self.cameraContainer setBackgroundColor:[UIColor clearColor]];
        [self.cameraContainer setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return _cameraContainer;
}

@end
