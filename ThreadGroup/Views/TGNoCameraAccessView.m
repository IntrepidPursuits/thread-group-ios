//
//  TGNoCameraAccessView.m
//  ThreadGroup
//
//  Created by Anbita Siregar on 7/31/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGNoCameraAccessView.h"
#import "UIColor+ThreadGroup.h"

@interface TGNoCameraAccessView()
@property (nonatomic, strong) UIView *nibView;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@end

@implementation TGNoCameraAccessView

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

- (void)commonInit {
    self.backgroundColor = [UIColor threadGroup_grey];
    self.settingsButton.backgroundColor = [UIColor threadGroup_darkGrey];
}

@end
