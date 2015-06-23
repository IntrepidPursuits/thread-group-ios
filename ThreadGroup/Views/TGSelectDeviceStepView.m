//
//  TGSelectDeviceStepView.m
//  ThreadGroup
//
//  Created by Patrick Butkiewicz on 6/12/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGSelectDeviceStepView.h"
#import "UIColor+ThreadGroup.h"
#import "UIImage+ThreadGroup.h"
#import "TGDevice.h"

static CGFloat TGSelectDeviceStepViewMinimumHeight = 64.0f;
static CGFloat TGSelectDeviceStepViewMaximumHeight = 163.0f;

@interface TGSelectDeviceStepView() <UITextFieldDelegate>

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
@property (weak, nonatomic) IBOutlet UITextField *connectCodeInputField;
@property (weak, nonatomic) IBOutlet UIView *textboxLine;
@property (weak, nonatomic) IBOutlet UIView *topSeperatorBar;

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
    self.confirmButton.hidden = YES;
    self.connectCodeInputField.delegate = self;
}

#pragma mark - Public

- (void)setContentMode:(TGSelectDeviceStepViewContentMode)contentMode {
    if (_contentMode == TGSelectDeviceStepViewContentModeConnectCode) {
        [self setPassphraseInputViewHidden:YES];
    }

    if (_contentMode != TGSelectDeviceStepViewContentModeComplete) {
        self.topSeperatorBar.hidden = YES;
    }
    
    switch (contentMode) {
        case TGSelectDeviceStepViewContentModeConnectCode: {
            self.titleLabel.text = @"Enter Connect Code";
            self.subTitleLabel.text = @"Read this off the product you're connecting";
            self.nibView.backgroundColor = [UIColor threadGroup_orange];
            self.iconImageView.image = [UIImage tg_selectPassphraseActive];
            [self setPassphraseInputViewHidden:NO];
        }
            break;
        case TGSelectDeviceStepViewContentModeConnectCodeInvalid: {
            self.titleLabel.text = @"Wrong Connect Code";
            self.subTitleLabel.text = @"Please check Connect Code and try again";
            self.nibView.backgroundColor = [UIColor threadGroup_red];
            self.iconImageView.image = [UIImage tg_selectDeviceError];
            [self setPassphraseInputViewHidden:NO];
        }
            break;
        case TGSelectDeviceStepViewContentModeScanQRCode: {
            self.titleLabel.text = @"Scan Device QR Code";
            self.subTitleLabel.text = @"You can also enter the Connect Code manually";
            self.nibView.backgroundColor = [UIColor threadGroup_orange];
            self.iconImageView.image = [UIImage tg_selectQRCodeActive];
        }
            break;
        case TGSelectDeviceStepViewContentModeScanQRCodeInvalid: {
            self.titleLabel.text = @"Wrong Connect QR Code";
            self.subTitleLabel.text = @"Please check your product compatibility";
            self.nibView.backgroundColor = [UIColor threadGroup_red];
            self.iconImageView.image = [UIImage tg_selectDeviceError];
        }
            break;
        case TGSelectDeviceStepViewContentModeComplete: {
            self.titleLabel.text = @"Smart Thermostat";
            self.subTitleLabel.text = @"Intrepid's Thread Network";
            self.nibView.backgroundColor = [UIColor threadGroup_grey];
            self.iconImageView.image = [UIImage tg_selectDeviceCompleted];
            self.topSeperatorBar.hidden = NO;
        }
            break;
    }
    [self setPassphraseInputViewHidden:(contentMode != TGSelectDeviceStepViewContentModeConnectCode && contentMode != TGSelectDeviceStepViewContentModeConnectCodeInvalid)];
}

+ (CGFloat)heightForContentMode:(TGSelectDeviceStepViewContentMode)contentMode {
    switch (contentMode) {
        case TGSelectDeviceStepViewContentModeComplete:             return TGSelectDeviceStepViewMinimumHeight;
        case TGSelectDeviceStepViewContentModeConnectCode:           return TGSelectDeviceStepViewMaximumHeight;
        case TGSelectDeviceStepViewContentModeScanQRCode:           return TGSelectDeviceStepViewMinimumHeight;
        case TGSelectDeviceStepViewContentModeScanQRCodeInvalid:    return TGSelectDeviceStepViewMinimumHeight;
        case TGSelectDeviceStepViewContentModeConnectCodeInvalid:    return TGSelectDeviceStepViewMaximumHeight;
        default:                                                    return TGSelectDeviceStepViewMinimumHeight;
    }
}

#pragma mark - Animations

- (void)setPassphraseInputViewHidden:(BOOL)hidden {
    self.connectCodeInputField.hidden = hidden;
    self.scanCodeButton.hidden = hidden;
    self.textboxLine.hidden = hidden;
}

#pragma mark - Button Events

- (IBAction)scanCodeButtonTapped:(id)sender {
    [self.connectCodeInputField resignFirstResponder];
    [self resetConnectCodeTextField];

    if ([self.delegate respondsToSelector:@selector(TGSelectDeviceStepViewDidTapScanCodeButton:)]) {
        [self.delegate TGSelectDeviceStepViewDidTapScanCodeButton:self];
    }
}

- (IBAction)confirmButtonTapped:(id)sender {
    [self.connectCodeInputField resignFirstResponder];
    [self resetConnectCodeTextField];

    //TODO: would need to perform this same process with connect code obtained from QR code
    TGDevice *device = [self createDeviceWithConnectCode:self.connectCodeInputField.text];

    if ([self.delegate respondsToSelector:@selector(TGSelectDeviceStepViewDidTapConfirmButton:validateWithDevice:)]) {
        [self.delegate TGSelectDeviceStepViewDidTapConfirmButton:self validateWithDevice:device];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *checkString = [self.connectCodeInputField.text stringByReplacingCharactersInRange:range withString:string];
    [self validateTextField:checkString];
    return YES;
}

- (void)validateTextField:(NSString *)checkString {
    if ([checkString length]) {
        self.confirmButton.hidden = NO;
    } else {
        self.confirmButton.hidden = YES;
    }
}

- (void)resetConnectCodeTextField {
    self.confirmButton.hidden = YES;
    self.connectCodeInputField.text = @"";
}

#pragma mark - TGDevice

- (TGDevice *)createDeviceWithConnectCode:(NSString *)connectCode {
    return [[TGDevice alloc] initWithConnectCode:connectCode];
}

#pragma mark - 

- (BOOL)becomeFirstResponder {
    return [self.connectCodeInputField becomeFirstResponder];
}

@end
