//
//  TGHeaderView.m
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 7/13/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGHeaderView.h"
#import "UIFont+ThreadGroup.h"
#import "UIColor+ThreadGroup.h"

static CGFloat const kTGHeaderViewFontSize = 12.0f;

@interface TGHeaderView()

@property (strong, nonatomic) UILabel *headerLabel;

@end

@implementation TGHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.headerLabel];
        NSMutableArray *constraints = [NSMutableArray new];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.headerLabel
                                                            attribute:NSLayoutAttributeCenterY
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.contentView
                                                            attribute:NSLayoutAttributeCenterY
                                                           multiplier:1.0f
                                                             constant:8.0f]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.headerLabel
                                                            attribute:NSLayoutAttributeLeft
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.contentView
                                                            attribute:NSLayoutAttributeLeft
                                                           multiplier:1.0f
                                                             constant:15.0f]];
        [self.contentView addConstraints:constraints];
    }
    return self;
}

#pragma mark - Setter

- (void)setTitle:(NSString *)title {
    self.headerLabel.text = title;
}

#pragma mark - Lazy Load

- (UILabel *)headerLabel {
    if (!_headerLabel) {
        _headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _headerLabel.font = [UIFont threadGroup_mediumFontWithSize:kTGHeaderViewFontSize];
        _headerLabel.textColor = [UIColor threadGroup_warmGrey];
        _headerLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _headerLabel;
}

@end
