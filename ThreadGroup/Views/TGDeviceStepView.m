//
//  TGDeviceStepView.m
//  ThreadGroup
//
//  Created by Patrick Butkiewicz on 6/10/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGDeviceStepView.h"
#import "UIColor+ThreadGroup.h"
#import "UIView+Animations.h"

@interface TGDeviceStepView()

@property (strong, nonatomic) UIView *nibView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *spinnerImageView;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomBarView;
@property (weak, nonatomic) IBOutlet UIView *topBarView;

@end

@implementation TGDeviceStepView

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

#pragma mark - Configure

- (void)commonInit {
    self.backgroundColor = [UIColor threadGroup_grey];
    [self setSpinnerHidden:YES animated:NO];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapIcon)];
    [tapGesture setNumberOfTapsRequired:1];
    [self.iconImageView addGestureRecognizer:tapGesture];
}

#pragma mark - Public

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    self.nibView.backgroundColor = backgroundColor;
}

- (void)setBottomBarHidden:(BOOL)hidden {
    self.bottomBarView.hidden = hidden;
}

- (void)setIcon:(UIImage *)icon {
    self.iconImageView.image = icon;
    [self.iconImageView threadGroup_animatePopup];
}

- (void)setSpinnerActive:(BOOL)spinnerActive {
    if (_spinnerActive == spinnerActive) {
        return;
    }
    _spinnerActive = spinnerActive;
    [self setSpinnerHidden:!spinnerActive animated:YES];
}

- (void)setTitle:(NSString *)title subTitle:(NSString *)subTitle {
    [self.titleLabel setText:title];
    [self.subTitleLabel setText:subTitle];
}

- (void)setTopBarHidden:(BOOL)hidden {
    self.topBarView.hidden = hidden;
}

#pragma mark - Animations

- (void)setSpinnerHidden:(BOOL)hidden animated:(BOOL)animated{
    [UIView animateWithDuration:(animated) ? 0.3f : 0
                     animations:^{
                         self.spinnerImageView.alpha = (hidden) ? 0 : 1.0f;
                         if (hidden) {
                             [self.spinnerImageView.layer removeAllAnimations];
                         } else {
                             [self.spinnerImageView threadGroup_animateClockwise];
                         }
                         [self layoutIfNeeded];
                     }];
}

#pragma mark - Button Events

- (void)didTapIcon {
    if ([self.delegate respondsToSelector:@selector(TGDeviceStepView:didTapIcon:)]) {
        [self.delegate TGDeviceStepView:self didTapIcon:self.iconImageView];
    }
}

@end