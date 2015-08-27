//
//  TGPopup.m
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 7/23/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGPopup.h"

@interface TGPopup()

@property (strong, nonatomic) UIView *nibView;

@end

@implementation TGPopup

- (instancetype)init {
    self = [super init];
    if (self) {
        self.nibView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                                      owner:self
                                                    options:nil] lastObject];
        [self addSubview:self.nibView];
        self.nibView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[bar]-0-|" options:0 metrics:nil views:@{@"bar" : self.nibView}]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[bar]-0-|" options:0 metrics:nil views:@{@"bar" : self.nibView}]];
    }
    return self;
}

- (void)setNibViewBackgroundColor:(UIColor *)nibViewBackgroundColor {
        [self.nibView setBackgroundColor:nibViewBackgroundColor];
}

@end
