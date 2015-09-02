//
//  TGNotificationView.m
//  ThreadGroup
//
//  Created by Anbita Siregar on 8/27/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGBadgeView.h"
#import "UIImage+ThreadGroup.h"
#import "UIColor+ThreadGroup.h"

@interface TGBadgeView()

@property (nonatomic) NSInteger count;

@property (nonatomic, strong) UIView *nibView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation TGBadgeView

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

#pragma mark - Setters

- (void)setViewState:(TGBadgeViewState)viewState {
    if (viewState == TGBadgeViewStateCount) {
        self.nibView.backgroundColor = [UIColor threadGroup_orange];
        self.countLabel.hidden = NO;
        self.containerView.hidden = YES;
    } else if (viewState == TGBadgeViewStateFailed) {
        self.nibView.backgroundColor = [UIColor threadGroup_red];
        [self setContainerWithView:[[UIImageView alloc] initWithImage:[UIImage tg_connectionFailedAlert]]];
        self.countLabel.hidden = YES;
        self.containerView.hidden = NO;
    }
}

- (void)setCount:(NSInteger)count {
    _count = count;
    self.countLabel.text = [@(count) stringValue];
}

- (void)setContainerWithView:(UIView *)view {
    [self.containerView addSubview:view];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-2-[bar]-2-|" options:0 metrics:nil views:@{@"bar" : view}]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-2-[bar]-2-|" options:0 metrics:nil views:@{@"bar" : view}]];
}

@end
