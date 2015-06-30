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
#import "TGDevice.h"
#import "TGRouterItem.h"

@interface TGAddProductViewController ()
@property (weak, nonatomic) IBOutlet TGSpinnerView *spinnerView;
@property (weak, nonatomic) IBOutlet UILabel *addingDeviceText;

@property (strong, nonatomic) TGDevice *device;
@property (strong, nonatomic) TGRouterItem *router;
@end

@implementation TGAddProductViewController

#pragma mark - ViewController Lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.spinnerView startAnimating];
    self.addingDeviceText.attributedText = [self createLabelFromDevice:self.device andRouter:self.router];
}

#pragma mark -

- (void)setDevice:(TGDevice *)device andRouter:(TGRouterItem *)router {
    _device = device;
    _router = router;
}

- (IBAction)cancelButtonPressed:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(addProductDidCancelAddingRequest:)]) {
        [self.delegate addProductDidCancelAddingRequest:self];
    }
}

#pragma mark - Helper Methods

- (NSAttributedString *)createLabelFromDevice:(TGDevice *)device andRouter:(TGRouterItem *)router {
    //Creating attributed strings
    NSAttributedString *adding = [[NSAttributedString alloc] initWithString:@"Adding " attributes:[self bookFontAttributeDictionary]];
    NSAttributedString *to = [[NSAttributedString alloc] initWithString:@" to " attributes:[self bookFontAttributeDictionary]];
    NSAttributedString *deviceName = [[NSAttributedString alloc] initWithString:device.name attributes:[self boldFontAttributeDictionary]];
    NSAttributedString *threadNetworkName = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@...", router.networkName] attributes:[self boldFontAttributeDictionary]];

    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithAttributedString:adding];
    [attString appendAttributedString:deviceName];
    [attString appendAttributedString:to];
    [attString appendAttributedString:threadNetworkName];

    return attString;
}

- (NSDictionary *)boldFontAttributeDictionary {
    return @{NSFontAttributeName : [UIFont threadGroup_boldFontWithSize:16.0]};
}

- (NSDictionary *)bookFontAttributeDictionary {
    return @{NSFontAttributeName : [UIFont threadGroup_bookFontWithSize:16.0]};
}


@end
