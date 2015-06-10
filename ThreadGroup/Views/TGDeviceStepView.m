//
//  TGDeviceStepView.m
//  ThreadGroup
//
//  Created by Patrick Butkiewicz on 6/10/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGDeviceStepView.h"

@interface TGDeviceStepView()

@property (strong, nonatomic) UIView *nibView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UIView *topBarView;
@property (weak, nonatomic) IBOutlet UIView *bottomBarView;
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
    }
}

- (void)setTitle:(NSString *)title subTitle:(NSString *)subTitle {
    [self.titleLabel setText:title];
    [self.subTitleLabel setText:subTitle];
}

- (void)setIcon:(UIImage *)icon {
    self.iconImageView.image = icon;
}

- (void)setTopBarHidden:(BOOL)hidden {
    self.topBarView.hidden = hidden;
}

- (void)setBottomBarHidden:(BOOL)hidden {
    self.bottomBarView.hidden = hidden;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    self.nibView.backgroundColor = backgroundColor;
}

@end
