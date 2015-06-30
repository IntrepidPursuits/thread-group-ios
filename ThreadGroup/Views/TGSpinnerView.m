//
//  TGSpinnerView.m
//  ThreadGroup
//
//  Created by Patrick Butkiewicz on 6/10/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGSpinnerView.h"
#import "UIView+Animations.h"
#import "UIImage+ThreadGroup.h"

@interface TGSpinnerView()

@property (nonatomic, strong) UIView *nibView;
@property (strong, nonatomic) UIImageView *spinnerLargeCounterClockwiseImageView;
@property (strong, nonatomic) UIImageView *spinnerLargeClockwiseImageView;
@end

@implementation TGSpinnerView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configureImageViews];
    [self startAnimating];
}

- (void)configureImageViews {
    self.spinnerLargeClockwiseImageView = [[UIImageView alloc] initWithImage:[UIImage tg_largeClockwiseSpinner]];
    [self.spinnerLargeClockwiseImageView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [self.spinnerLargeClockwiseImageView setContentMode:UIViewContentModeCenter];
    [self.spinnerLargeClockwiseImageView setFrame:self.bounds];
    [self addSubview:self.spinnerLargeClockwiseImageView];
    
    self.spinnerLargeCounterClockwiseImageView = [[UIImageView alloc] initWithImage:[UIImage tg_largeCounterClockwiseSpinner]];
    [self.spinnerLargeCounterClockwiseImageView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [self.spinnerLargeCounterClockwiseImageView setContentMode:UIViewContentModeCenter];
    [self.spinnerLargeCounterClockwiseImageView setFrame:self.bounds];
    [self addSubview:self.spinnerLargeCounterClockwiseImageView];
}

#pragma mark - Public

- (void)startAnimating {
    [self.spinnerLargeClockwiseImageView threadGroup_animateClockwise];
    [self.spinnerLargeCounterClockwiseImageView threadGroup_animateCounterClockwise];
}

- (void)stopAnimating {
    [self.spinnerLargeClockwiseImageView.layer removeAllAnimations];
    [self.spinnerLargeCounterClockwiseImageView.layer removeAllAnimations];
}

@end
