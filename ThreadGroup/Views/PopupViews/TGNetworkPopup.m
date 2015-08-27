//
//  TGNetworkSearchingPopup.m
//  ThreadGroup
//
//  Created by Patrick Butkiewicz on 6/11/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGNetworkPopup.h"
#import "UIView+Animations.h"
#import "UIImage+ThreadGroup.h"
#import "UIColor+ThreadGroup.h"
#import "TGSpinnerView.h"

static NSString * const kSearchingTitleLabelText = @"Still looking for Thread Networks...";
static NSString * const kConnectingTitleLabelText = @"Connecting to...";

@interface TGNetworkPopup()
@property (weak, nonatomic) IBOutlet UIView *spinnerViewContainer;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) TGSpinnerView *spinnerView;
@end

@implementation TGNetworkPopup

- (instancetype)initWithContentMode:(TGNetworkPopupContentMode)contentMode {
    self = [super init];
    if (self) {
        [self setContentMode:contentMode];
    }
    return self;
}

- (void)setContentMode:(TGNetworkPopupContentMode)contentMode {
    if (contentMode == TGNetworkPopupContentModeSearching) {
        [self setNibViewBackgroundColor:[UIColor threadGroup_whiteGrey]];
        self.titleLabel.text = kSearchingTitleLabelText;
        self.titleLabel.textColor = [UIColor threadGroup_grey];
        self.spinnerView = [[TGSpinnerView alloc] initWithFrame:CGRectZero clockwiseImage:[UIImage tg_popupSpinnerClockwise] counterClockwiseImage:[UIImage tg_popupSpinnerCounterClockwise]];
        [self constrainSpinnerViewToContainer];
    } else if (contentMode == TGNetworkPopupContentModeConnecting) {
        [self setNibViewBackgroundColor:[UIColor threadGroup_orange]];
        self.titleLabel.text = kConnectingTitleLabelText;
        self.titleLabel.textColor = [UIColor whiteColor];
        self.spinnerView = [[TGSpinnerView alloc] initWithFrame:CGRectZero clockwiseImage:[UIImage tg_popupWhiteSpinnerClockwise] counterClockwiseImage:[UIImage tg_popupWhiteSpinnerCounterClockwise]];
        [self constrainSpinnerViewToContainer];
    }
}

- (void)constrainSpinnerViewToContainer {
    [self.spinnerViewContainer addSubview:self.spinnerView];
    self.spinnerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.spinnerViewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[bar]-0-|" options:0 metrics:nil views:@{@"bar" : self.spinnerView}]];
    [self.spinnerViewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[bar]-0-|" options:0 metrics:nil views:@{@"bar" : self.spinnerView}]];
}

- (void)resetTitleLabel:(NSString *)title {
    [self.titleLabel setText:title];
}

@end
