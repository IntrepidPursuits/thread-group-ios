//
//  TGNetworkSearchingPopup.m
//  ThreadGroup
//
//  Created by Patrick Butkiewicz on 6/11/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGNetworkSearchingPopup.h"
#import "UIView+Animations.h"
#import "UIImage+ThreadGroup.h"
#import "TGSpinnerView.h"

@interface TGNetworkSearchingPopup()
@property (weak, nonatomic) IBOutlet UIView *spinnerViewContainer;
@end

@implementation TGNetworkSearchingPopup

- (instancetype)init {
    self = [super init];
    if (self) {
        TGSpinnerView *spinnerView = [[TGSpinnerView alloc] initWithFrame:CGRectZero clockwiseImage:[UIImage tg_popupSpinnerClockwise] counterClockwiseImage:[UIImage tg_popupSpinnerCounterClockwise]];
        [self.spinnerViewContainer addSubview:spinnerView];
        spinnerView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.spinnerViewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[bar]-0-|" options:0 metrics:nil views:@{@"bar" : spinnerView}]];
        [self.spinnerViewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[bar]-0-|" options:0 metrics:nil views:@{@"bar" : spinnerView}]];
    }
    return self;
}

@end
