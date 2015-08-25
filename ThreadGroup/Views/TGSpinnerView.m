//
//  TGSpinnerView.m
//  ThreadGroup
//
//  Created by Anbita Siregar on 8/24/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGSpinnerView.h"
#import "UIView+Animations.h"

@implementation TGSpinnerView

- (instancetype)initWithFrame:(CGRect)frame clockwiseImage:(UIImage *)clockwiseImage counterClockwiseImage:(UIImage *)counterClockwiseImage {
    self = [super initWithFrame:frame];
    if (self) {
        self.clockwiseSpinnerImageView = [[UIImageView alloc] initWithImage:clockwiseImage];
        self.counterClockwiseSpinnerImageView = [[UIImageView alloc] initWithImage:counterClockwiseImage];
        
        [self addSubview:self.clockwiseSpinnerImageView];
        [self addSubview:self.counterClockwiseSpinnerImageView];
        
        self.clockwiseSpinnerImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[bar]-0-|" options:0 metrics:nil views:@{@"bar" : self.clockwiseSpinnerImageView}]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[bar]-0-|" options:0 metrics:nil views:@{@"bar" : self.clockwiseSpinnerImageView}]];
        
        self.counterClockwiseSpinnerImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[bar]-0-|" options:0 metrics:nil views:@{@"bar" : self.counterClockwiseSpinnerImageView}]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[bar]-0-|" options:0 metrics:nil views:@{@"bar" : self.counterClockwiseSpinnerImageView}]];
        
        [self registerForEnterForegroundNotification];
        [self startAnimating];
    }
    return self;
}

- (void)startAnimating {
    [self.clockwiseSpinnerImageView threadGroup_animateClockwise];
    [self.counterClockwiseSpinnerImageView threadGroup_animateCounterClockwise];
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    [self startAnimating];
}

#pragma mark - Return from background notification

- (void)registerForEnterForegroundNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(startAnimating)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:[UIApplication sharedApplication]];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
