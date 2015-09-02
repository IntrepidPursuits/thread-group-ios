//
//  TGSuccessView.m
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 9/2/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGSuccessView.h"

@interface TGSuccessView()
@property (nonatomic, strong) UIView *nibView;
@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *networkNameLabel;
@end

@implementation TGSuccessView

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

#pragma mark - Setters/Getters

- (void)setDeviceName:(NSString *)deviceName {
    _deviceName = deviceName;
    self.deviceNameLabel.text = deviceName;
}

- (void)setNetworkName:(NSString *)networkName {
    _networkName = networkName;
    NSString *networkNameText = [NSString stringWithFormat:@"to %@", networkName];
    self.networkNameLabel.text = networkNameText;
}

@end
