//
//  TGHeaderView.m
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 7/13/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <PureLayout/PureLayout.h>
#import "TGHeaderView.h"
#import "UIFont+ThreadGroup.h"
#import "UIColor+ThreadGroup.h"

static CGFloat const kTGHeaderViewFontSize = 12.0f;
static CGFloat const kTGHeaderLabelCenterOffset = 8.0f;
static CGFloat const kTGHeaderLabelLeftOffset = 15.0f;

@interface TGHeaderView()

@property (strong, nonatomic) UILabel *headerLabel;

@end

@implementation TGHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.headerLabel];
        [self.headerLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.contentView withOffset:kTGHeaderLabelCenterOffset];
        [self.headerLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:kTGHeaderLabelLeftOffset];
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
