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
#import "UIImage+ThreadGroup.h"
#import "TGDevice.h"
#import "TGRouter.h"

@interface TGAddProductViewController ()

@property (weak, nonatomic) IBOutlet UIView *spinnerViewContainer;
@property (weak, nonatomic) IBOutlet UILabel *addingDeviceText;

@property (strong, nonatomic) TGDevice *device;
@property (strong, nonatomic) TGRouter *router;
@end

@implementation TGAddProductViewController

#pragma mark - ViewController Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSpinnerView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.addingDeviceText.attributedText = [self createLabelFromDevice:self.device andRouter:self.router];
}

- (void)setupSpinnerView {
    TGSpinnerView *spinnerView = [[TGSpinnerView alloc] initWithClockwiseImage:[UIImage tg_mainSpinnerClockwise] counterClockwiseImage:[UIImage tg_mainSpinnerCounterClockwise]];
    [self.spinnerViewContainer addSubview:spinnerView];
    spinnerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.spinnerViewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[bar]-0-|" options:0 metrics:nil views:@{@"bar" : spinnerView}]];
    [self.spinnerViewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[bar]-0-|" options:0 metrics:nil views:@{@"bar" : spinnerView}]];
}

#pragma mark -

- (void)setDevice:(TGDevice *)device andRouter:(TGRouter *)router {
    _device = device;
    _router = router;
}

- (IBAction)cancelButtonPressed:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(addProductDidCancelAddingRequest:)]) {
        [self.delegate addProductDidCancelAddingRequest:self];
    }
}

#pragma mark - Helper Methods

- (NSAttributedString *)createLabelFromDevice:(TGDevice *)device andRouter:(TGRouter *)router {
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
