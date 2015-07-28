//
//  TGSpinnerView.m
//  ThreadGroup
//
//  Created by Patrick Butkiewicz on 6/10/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGSpinnerView.h"
#import "UIView+Animations.h"

@interface TGSpinnerView()

@property (nonatomic, strong) UIView *nibView;
@property (weak, nonatomic) IBOutlet UIImageView *spinnerLargeCounterClockwiseImageView;
@property (weak, nonatomic) IBOutlet UIImageView *spinnerLargeClockwiseImageView;
@end

@implementation TGSpinnerView

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
    }
    [self startAnimating];
}

- (void)startAnimating {
    [self.spinnerLargeClockwiseImageView threadGroup_animateClockwise];
    [self.spinnerLargeCounterClockwiseImageView threadGroup_animateCounterClockwise];
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
