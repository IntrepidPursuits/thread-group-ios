//
//  TGSuccessView.m
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 9/2/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGSuccessView.h"
#import "TGDevice.h"
#import "TGRouter.h"

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

- (void)setDevice:(TGDevice *)device {
    _device= device;
    self.deviceNameLabel.text = device.name;
}

- (void)setRouter:(TGRouter *)router {
    _router = router;
    self.networkNameLabel.text = [NSString stringWithFormat:@"to %@", router.name];
}

@end
