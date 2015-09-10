//
//  TGScannerView.m
//  ThreadGroup
//
//  Created by Patrick Butkiewicz on 6/23/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <PureLayout/PureLayout.h>
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
    [self.cameraContainer autoPinEdgesToSuperviewEdges];

    self.tutorialButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.tutorialButton addTarget:self action:@selector(tutorialButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.tutorialButton setImage:[UIImage imageNamed:@"action_qr_tutorial"] forState:UIControlStateNormal];

    [self.cameraContainer addSubview:self.tutorialButton];
    [self.tutorialButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.cameraContainer withOffset:TGScannerTutorialButtonInset];
    [self.tutorialButton autoConstrainAttribute:ALAttributeMarginRight toAttribute:ALAttributeMarginRight ofView:self.cameraContainer withOffset:-TGScannerTutorialButtonInset];
}

- (void)configureOverlay {
    self.cameraOverlay = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"camera_overlay"]];
    [self.cameraContainer addSubview:self.cameraOverlay];
    [self.cameraOverlay autoCenterInSuperview];
}

- (void)configureMask {
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.maskView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [self addSubview:self.maskView];
    [self.maskView autoPinEdgesToSuperviewEdges];
}

- (void)configureTutorialView {
    self.tutorialView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tutorialView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.tutorialView];
    [self.tutorialView autoPinEdgesToSuperviewEdges];


    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage tg_tutorialView]];
    [imageView setBackgroundColor:[UIColor clearColor]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.tutorialView addSubview:imageView];
    [imageView autoConstrainAttribute:ALAttributeBottom toAttribute:ALAttributeHorizontal ofView:self.tutorialView withOffset:16.0f];
    [imageView autoConstrainAttribute:ALAttributeVertical toAttribute:ALAttributeVertical ofView:self.tutorialView];
    [imageView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.tutorialView withOffset:32.0f relation:NSLayoutRelationGreaterThanOrEqual];


    UILabel *tutorialMessageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [tutorialMessageLabel setBackgroundColor:[UIColor clearColor]];
    [tutorialMessageLabel setFont:[UIFont threadGroup_bookFontWithSize:14.0f]];
    [tutorialMessageLabel setNumberOfLines:0];
    [tutorialMessageLabel setText:@"Point your camera at the device Connect QR Code to scan it"];
    [tutorialMessageLabel setTextColor:[UIColor whiteColor]];
    [self.tutorialView addSubview:tutorialMessageLabel];
    [tutorialMessageLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.tutorialView withOffset:16.0f];
    [tutorialMessageLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.tutorialView withOffset:16.0f];
    [tutorialMessageLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:imageView withOffset:32.0f];
    [tutorialMessageLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.tutorialView withOffset:32.0f relation:NSLayoutRelationGreaterThanOrEqual];
}

- (void)configureNoCameraAccessView {
    self.hasCameraAccess = YES;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied) {
        self.noCameraAccessView = [[TGNoCameraAccessView alloc] init];
        [self addSubview:self.noCameraAccessView];
        [self.noCameraAccessView autoPinEdgesToSuperviewEdges];
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
            [self startDetection];
            [self setTutorialViewHidden:YES animated:animated];
            break;
        case TGScannerViewContentModeInactive:
            [self stopDetection];
            [self setTutorialViewHidden:YES animated:animated];
            [self setMaskViewHidden:NO animated:animated];
            break;
        case TGScannerViewContentModeNoCameraAccess:
            [self stopDetection];
            [self setTutorialViewHidden:YES animated:animated];
            break;
        case TGScannerViewContentModeTutorial:
            [self stopDetection];
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
                    if ([self.delegate respondsToSelector:@selector(TGScannerView:didParseDeviceFromCode:)]) {
                        [self.delegate TGScannerView:self didParseDeviceFromCode:device];
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
    }
    return _cameraContainer;
}

@end
