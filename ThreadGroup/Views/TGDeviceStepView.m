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
#import "UIImage+ThreadGroup.h"
#import "TGBadgeView.h"

@interface TGDeviceStepView()

@property (strong, nonatomic) UIView *nibView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomBarView;
@property (weak, nonatomic) IBOutlet UIView *topBarView;
@property (weak, nonatomic) IBOutlet UIImageView *threadConfig;
@property (weak, nonatomic) IBOutlet TGBadgeView *badgeView;

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
    self.threadConfig.image = [UIImage tg_routerSettings];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapIcon)];
    [self.iconImageView addGestureRecognizer:tapGesture];

    UITapGestureRecognizer *threadConfigTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapThreadConfig)];
    [self.threadConfig addGestureRecognizer:threadConfigTap];
    
    [self.badgeView setViewState:TGBadgeViewStateFailed];
    self.badgeView.hidden = YES;
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

- (void)setTitle:(NSString *)title subTitle:(NSString *)subTitle {
    [self.titleLabel setText:title];
    [self.subTitleLabel setText:subTitle];
}

- (void)setTopBarHidden:(BOOL)hidden {
    self.topBarView.hidden = hidden;
}

- (void)setThreadConfigHidden:(BOOL)hidden {
    self.threadConfig.hidden = hidden;
}

#pragma mark - Button Events

- (void)didTapIcon {
    if ([self.delegate respondsToSelector:@selector(TGDeviceStepView:didTapIcon:)]) {
        [self.delegate TGDeviceStepView:self didTapIcon:self.iconImageView];
    }
}

- (void)didTapThreadConfig {
    if ([self.delegate respondsToSelector:@selector(TGDeviceStepView:didTapThreadConfig:)]) {
        [self.delegate TGDeviceStepView:self didTapThreadConfig:self.threadConfig];
    }
}

@end
