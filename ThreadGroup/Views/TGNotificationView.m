//
//  TGNotificationView.m
//  ThreadGroup
//
//  Created by Anbita Siregar on 8/27/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGNotificationView.h"
#import "UIImage+ThreadGroup.h"

@interface TGNotificationView()

@property (nonatomic) NSInteger count;

@property (nonatomic, strong) UIView *nibView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation TGNotificationView

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
        
        //This is just temporary. In the event we want to put any other views inside contentView, we would need to make a setContentViewWithView:(UIView *)view method
        [self.contentView addSubview:[[UIImageView alloc] initWithImage:[UIImage tg_connectionFailedAlert]]];
    }
}

- (void)setBackgroundColor:(UIColor *)color {
    self.nibView.backgroundColor = color;
}

#pragma mark - Setters

- (void)setCount:(NSInteger)count {
    _count = count;
    self.countLabel.text = [@(count) stringValue];
}

@end
