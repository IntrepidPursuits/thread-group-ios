//
//  TGSelectDeviceStepView.m
//  ThreadGroup
//
//  Created by Patrick Butkiewicz on 6/12/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGSelectDeviceStepView.h"
#import "UIColor+ThreadGroup.h"

static CGFloat TGSelectDeviceStepViewMinimumHeight = 64.0f;
static CGFloat TGSelectDeviceStepViewMaximumHeight = 163.0f;

@interface TGSelectDeviceStepView()

@property (strong, nonatomic) UIView *nibView;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomBar;
@property (weak, nonatomic) IBOutlet UIView *topBar;

@property (weak, nonatomic) IBOutlet UIView *passPhraseView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passPhraseViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIButton *scanCodeButton;
@property (weak, nonatomic) IBOutlet UITextField *passphraseInputField;
@property (weak, nonatomic) IBOutlet UIView *textboxLine;

@end

@implementation TGSelectDeviceStepView

- (void)awakeFromNib {
    [super awakeFromNib];
    if (self) {
        self.nibView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                                      owner:self
                                                    options:nil] lastObject];
        [self addSubview:self.nibView];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[bar]-0-|" options:0 metrics:nil views:@{@"bar" : self.nibView}]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[bar]-0-|" options:0 metrics:nil views:@{@"bar" : self.nibView}]];
        self.nibView.translatesAutoresizingMaskIntoConstraints = NO;
        [self commonInit];
    }
}

- (void)commonInit {
    self.backgroundColor = [UIColor threadGroup_grey];
    self.contentMode = TGSelectDeviceStepViewContentModeScanQRCode;
    self.bottomBar.hidden = YES;
    self.topBar.hidden = NO;
}

#pragma mark - Public

- (void)setContentMode:(TGSelectDeviceStepViewContentMode)contentMode {
    if (_contentMode == TGSelectDeviceStepViewContentModePassphrase) {
        [self setPassphraseInputViewHidden:YES];
    }
    
    switch (contentMode) {
        case TGSelectDeviceStepViewContentModePassphrase: {
            self.titleLabel.text = @"Enter Device Passphrase";
            self.subTitleLabel.text = @"Check the device instructions for more info";
            self.nibView.backgroundColor = [UIColor threadGroup_orange];
            self.iconImageView.image = [UIImage imageNamed:@"steps_code_active"];
            [self setPassphraseInputViewHidden:NO];
        }
            break;
        case TGSelectDeviceStepViewContentModeScanQRCode: {
            self.titleLabel.text = @"Scan Device QR Code";
            self.subTitleLabel.text = @"You can also enter a passphrase manually";
            self.nibView.backgroundColor = [UIColor threadGroup_orange];
            self.iconImageView.image = [UIImage imageNamed:@"steps_device_active"];
        }
            break;
        case TGSelectDeviceStepViewContentModeScanQRCodeInvalid: {
            self.titleLabel.text = @"Invalid QR Code";
            self.subTitleLabel.text = @"Please check your device compatibility";
            self.nibView.backgroundColor = [UIColor threadGroup_red];
            self.iconImageView.image = [UIImage imageNamed:@"steps_error"];
        }
            break;
        case TGSelectDeviceStepViewContentModeComplete: {
            self.titleLabel.text = @"Smart Thermostat";
            self.subTitleLabel.text = @"Intrepid's Thread Network";
            self.nibView.backgroundColor = [UIColor threadGroup_grey];
            self.iconImageView.image = [UIImage imageNamed:@"steps_device_completed"];
        }
            break;
    }

    [self setPassphraseInputViewHidden:(contentMode != TGSelectDeviceStepViewContentModePassphrase)];
}

+ (CGFloat)heightForContentMode:(TGSelectDeviceStepViewContentMode)contentMode {
    switch (contentMode) {
        case TGSelectDeviceStepViewContentModeComplete:             return TGSelectDeviceStepViewMinimumHeight;
        case TGSelectDeviceStepViewContentModePassphrase:           return TGSelectDeviceStepViewMaximumHeight;
        case TGSelectDeviceStepViewContentModeScanQRCode:           return TGSelectDeviceStepViewMinimumHeight;
        case TGSelectDeviceStepViewContentModeScanQRCodeInvalid:    return TGSelectDeviceStepViewMinimumHeight;
        default:                                                    return TGSelectDeviceStepViewMinimumHeight;
    }
}

#pragma mark - Animations

- (void)setPassphraseInputViewHidden:(BOOL)hidden {
    self.passphraseInputField.hidden = hidden;
    self.scanCodeButton.hidden = hidden;
    self.confirmButton.hidden = hidden;
    self.textboxLine.hidden = hidden;
}

#pragma mark - Button Events

- (IBAction)scanCodeButtonTapped:(id)sender {
    [self.passphraseInputField resignFirstResponder];
    
    if ([self.delegate respondsToSelector:@selector(TGSelectDeviceStepViewDidTapScanCodeButton:)]) {
        [self.delegate TGSelectDeviceStepViewDidTapScanCodeButton:self];
    }
}

- (IBAction)confirmButtonTapped:(id)sender {
    [self.passphraseInputField resignFirstResponder];
    
    if ([self.delegate respondsToSelector:@selector(TGSelectDeviceStepViewDidTapConfirmButton:)]) {
        [self.delegate TGSelectDeviceStepViewDidTapConfirmButton:self];
    }
}

#pragma mark - 

- (BOOL)becomeFirstResponder {
    return [self.passphraseInputField becomeFirstResponder];
}

@end
