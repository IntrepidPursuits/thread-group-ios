//
//  TGAddingDeviceView.m
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 6/22/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGAddingDeviceView.h"
#import "TGSpinnerView.h"
#import "UIFont+ThreadGroup.h"

@interface TGAddingDeviceView()

@property (strong, nonatomic) UIView *nibView;

@property (weak, nonatomic) IBOutlet TGSpinnerView *spinnerView;
@property (weak, nonatomic) IBOutlet UILabel *addingDeviceText;


@end

@implementation TGAddingDeviceView

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

- (void)setDeviceName:(NSString *)name withNetworkName:(NSString *)networkName {
    //Creating attributed strings
    NSAttributedString *adding = [[NSAttributedString alloc] initWithString:@"Adding " attributes:[self bookFontAttributeDictionary]];
    NSAttributedString *to = [[NSAttributedString alloc] initWithString:@" to " attributes:[self bookFontAttributeDictionary]];
    NSAttributedString *deviceName = [[NSAttributedString alloc] initWithString:name attributes:[self boldFontAttributeDictionary]];
    NSAttributedString *threadNetworkName = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@...", networkName] attributes:[self boldFontAttributeDictionary]];

    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithAttributedString:adding];
    [attString appendAttributedString:deviceName];
    [attString appendAttributedString:to];
    [attString appendAttributedString:threadNetworkName];

    self.addingDeviceText.attributedText = attString;
}

- (void)startAnimating {
    [self.spinnerView startAnimating];
}

- (void)stopAnimating {
    [self.spinnerView stopAnimating];
}

- (IBAction)cancelButtonPressed:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(addingDeviceViewDidCancelAddingRequest:)]) {
        [self.delegate addingDeviceViewDidCancelAddingRequest:self];
    }
}

#pragma mark - Helper Methods

- (NSDictionary *)boldFontAttributeDictionary {
    return @{NSFontAttributeName : [UIFont threadGroup_boldFontWithSize:16.0]};
}

- (NSDictionary *)bookFontAttributeDictionary {
    return @{NSFontAttributeName : [UIFont threadGroup_bookFontWithSize:16.0]};
}

@end
