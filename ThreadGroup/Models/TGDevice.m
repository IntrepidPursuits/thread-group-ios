//
//  TGDevice.m
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 6/23/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGDevice.h"
#import "TGNetworkManager.h"
#import "TGQRCode.h"

const NSUInteger TGDeviceConnectCodeMaximumCharacters = 16;
const NSUInteger TGDeviceConnectCodeMinimumCharacters = 6;

@interface TGDevice()
@property (nonatomic, strong) NSString *passphrase;
@end

@implementation TGDevice

- (instancetype)initWithPassphrase:(NSString *)passphrase {
    self = [super init];
    if (self) {
        _passphrase = passphrase;
        _name = passphrase;
    }
    return self;
}

- (instancetype)initWithQRCode:(TGQRCode *)qrCode {
    self = [super init];
    if (self) {
        _qrCode = qrCode;
    }
    return self;
}

#pragma mark - Getters

- (NSString *)connectCode {
    return (self.qrCode) ? self.qrCode.connectCode : self.passphrase;
}

- (NSString *)name {
    return (self.qrCode) ? self.qrCode.vendorModel : self.name;
}

@end
