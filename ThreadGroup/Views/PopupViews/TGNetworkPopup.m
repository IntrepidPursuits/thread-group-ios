//
//  TGNetworkSearchingPopup.m
//  ThreadGroup
//
//  Created by Patrick Butkiewicz on 6/11/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <PureLayout/PureLayout.h>
#import "TGNetworkPopup.h"
#import "UIView+Animations.h"
#import "UIImage+ThreadGroup.h"
#import "UIColor+ThreadGroup.h"
#import "TGSpinnerView.h"

static NSString * const kSearchingTitleLabelText = @"Still looking for Thread Networks...";
static NSString * const kConnectingTitleLabelText = @"Connecting to...";
static NSString * const kFailedConnectionTitleLabelText = @"Connection failed";

@interface TGNetworkPopup()
@property (weak, nonatomic) IBOutlet UIView *imageViewContainer;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
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
        TGSpinnerView *spinnerView = [[TGSpinnerView alloc] initWithClockwiseImage:[UIImage tg_popupSpinnerClockwise] counterClockwiseImage:[UIImage tg_popupSpinnerCounterClockwise]];
        [self constrainImageViewToContainer:spinnerView];
    } else if (contentMode == TGNetworkPopupContentModeConnecting) {
        [self setNibViewBackgroundColor:[UIColor threadGroup_orange]];
        self.titleLabel.text = kConnectingTitleLabelText;
        self.titleLabel.textColor = [UIColor whiteColor];
        TGSpinnerView *spinnerView = [[TGSpinnerView alloc] initWithClockwiseImage:[UIImage tg_popupWhiteSpinnerClockwise] counterClockwiseImage:[UIImage tg_popupWhiteSpinnerCounterClockwise]];
        [self constrainImageViewToContainer:spinnerView];
    } else if (contentMode == TGNetworkPopupContentModeFailedConnection) {
        [self setNibViewBackgroundColor:[UIColor threadGroup_red]];
        self.titleLabel.text = kFailedConnectionTitleLabelText;
        self.titleLabel.textColor = [UIColor whiteColor];
        [self constrainImageViewToContainer:[[UIImageView alloc] initWithImage:[UIImage tg_connectionFailedAlert]]];
    }
}

- (void)constrainImageViewToContainer:(UIView *)imageView {
    [self.imageViewContainer addSubview:imageView];
    [imageView autoPinEdgesToSuperviewEdges];
}

- (void)resetTitleLabel:(NSString *)title {
    [self.titleLabel setText:title];
}

@end
