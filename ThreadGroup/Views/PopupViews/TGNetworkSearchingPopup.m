//
//  TGNetworkSearchingPopup.m
//  ThreadGroup
//
//  Created by Patrick Butkiewicz on 6/11/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGNetworkSearchingPopup.h"
#import "UIView+Animations.h"

@interface TGNetworkSearchingPopup()

@property (strong, nonatomic) UIView *nibView;
@property (weak, nonatomic) IBOutlet UIImageView *clockwiseSpinnerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *counterClockwiseSpinnerImageView;

@end

@implementation TGNetworkSearchingPopup

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
        [self startAnimating];
    }
}

- (void)startAnimating {
    [self.clockwiseSpinnerImageView threadGroup_animateClockwise];
    [self.counterClockwiseSpinnerImageView threadGroup_animateCounterClockwise];
}

@end
