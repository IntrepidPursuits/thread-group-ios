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
static NSString * const kTGDefaultDeviceName = @"Thread Device";

@interface TGDevice()
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) TGQRCode *qrCode;
@property (nonatomic, strong) NSString *connectCode;
@end

@implementation TGDevice

- (instancetype)initWithConnectCode:(NSString *)connectCode {
    self = [super init];
    if (self) {
        _connectCode = connectCode;
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
    return (self.qrCode) ? self.qrCode.connectCode : _connectCode;
}

- (NSString *)name {
    return (self.qrCode && self.qrCode.vendorModel) ? self.qrCode.vendorModel : kTGDefaultDeviceName;
}

@end
