//
//  TGAddProductViewController.m
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 6/25/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGAddProductViewController.h"
#import "TGSpinnerView.h"
#import "UIFont+ThreadGroup.h"

@interface TGAddProductViewController ()
@property (weak, nonatomic) IBOutlet TGSpinnerView *spinnerView;
@property (weak, nonatomic) IBOutlet UILabel *addingDeviceText;

@end

@implementation TGAddProductViewController

#pragma mark - ViewController Lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self startAnimating];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopAnimating];
}

#pragma mark -

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
    if ([self.delegate respondsToSelector:@selector(addProductDidCancelAddingRequest:)]) {
        [self.delegate addProductDidCancelAddingRequest:self];
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
