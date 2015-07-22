//
//  TGTutorialPopup.m
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 7/22/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGTutorialPopup.h"

@interface TGTutorialPopup()
@property (strong, nonatomic) UIView *nibView;
@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;
@end

@implementation TGTutorialPopup

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
    [self addGestureRecognizer:self.tapGesture];
}

- (UITapGestureRecognizer *)tapGesture {
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.delegate action:@selector(didPressTutorialPopup:)];
    }
    return _tapGesture;
}

@end
