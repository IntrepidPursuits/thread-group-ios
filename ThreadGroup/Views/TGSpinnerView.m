//
//  TGSpinnerView.m
//  ThreadGroup
//
//  Created by Patrick Butkiewicz on 6/10/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGSpinnerView.h"

static CGFloat kAnimationSpinDuration = 2.0f;
static CGFloat kAnimationSpinSpeed = 1.0f;

@interface TGSpinnerView()

@property (nonatomic, strong) UIView *nibView;
@property (weak, nonatomic) IBOutlet UIImageView *spinnerLargeCounterClockwiseImageView;
@property (weak, nonatomic) IBOutlet UIImageView *spinnerLargeClockwiseImageView;
@property (weak, nonatomic) IBOutlet UIImageView *spinnerSmallCounterClockwiseImageView;
@property (weak, nonatomic) IBOutlet UIImageView *spinnerSmallClockwiseImageView;
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
}

#pragma mark - Public

- (void)startAnimating {
    [self.spinnerLargeCounterClockwiseImageView.layer addAnimation:[self counterClockwiseRotationAnimation] forKey:@"spin"];
    [self.spinnerLargeClockwiseImageView.layer addAnimation:[self clockwiseRotationAnimation] forKey:@"spin"];
    [self.spinnerSmallCounterClockwiseImageView.layer addAnimation:[self counterClockwiseRotationAnimation] forKey:@"spin"];
    [self.spinnerSmallClockwiseImageView.layer addAnimation:[self clockwiseRotationAnimation] forKey:@"spin"];
}

- (void)stopAnimating {
    [self.spinnerLargeClockwiseImageView.layer removeAllAnimations];
    [self.spinnerLargeCounterClockwiseImageView.layer removeAllAnimations];
    [self.spinnerSmallClockwiseImageView.layer removeAllAnimations];
    [self.spinnerSmallCounterClockwiseImageView.layer removeAllAnimations];
}

#pragma mark - Animations

- (CABasicAnimation *)clockwiseRotationAnimation {
    CABasicAnimation *animation;
    animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.fromValue = @(0);
    animation.duration = kAnimationSpinDuration;
    animation.repeatCount = MAXFLOAT;
    animation.speed = kAnimationSpinSpeed;
    animation.toValue = @(-(2 * M_PI));
    return animation;
}

- (CABasicAnimation *)counterClockwiseRotationAnimation {
    CABasicAnimation *animation;
    animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.duration = kAnimationSpinDuration;
    animation.fromValue = @(0);
    animation.repeatCount = MAXFLOAT;
    animation.speed = kAnimationSpinSpeed;
    animation.toValue = @((2 * M_PI));
    return animation;
}

@end
