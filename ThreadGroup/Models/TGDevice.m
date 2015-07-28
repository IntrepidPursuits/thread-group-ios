//
//  TGDevice.m
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 6/23/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGDevice.h"
#import "TGNetworkManager.h"

const NSUInteger TGDeviceConnectCodeMaximumCharacters = 16;
const NSUInteger TGDeviceConnectCodeMinimumCharacters = 6;

@interface TGDevice()

@property (nonatomic, strong) NSString *passphrase;

//As define by the QR code specification
@property (nonatomic) NSUInteger qrCodeVersion; //uint8
@property (nonatomic, strong) NSString *longAddress; //ASCII Hex
@property (nonatomic, strong) NSString *connectCode; //base32-thread
@property (nonatomic, strong) NSString *vendorName; //utf-8
@property (nonatomic, strong) NSString *vendorModel; //utf-8
@property (nonatomic, strong) NSString *vendorVersion; //utf-8
@property (nonatomic, strong) NSString *vendorSerialNumber; //String

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

- (void)isPassphraseValidWithCompletion:(void(^)(BOOL success))completion {
    [[TGNetworkManager sharedManager] connectDevice:self.passphrase
                                         completion:^(NSError *__autoreleasing *error) {
                                             BOOL successful = (BOOL)(arc4random() % 2);
                                             completion(successful);
                                         }];
}

- (instancetype)initWithParamaters:(NSArray *)parameters {
    self = [super init];
    if (self) {
        [self parseParameters:parameters];
    }
    return self;
}

#pragma mark - Helper methods

- (void)parseParameters:(NSArray *)parameters {
    self.qrCodeVersion = [[self parseItem:parameters[0]] integerValue];
    self.longAddress = [self parseItem:parameters[1]];
    self.connectCode = [self parseItem:parameters[2]];
    self.vendorName = [self parseItem:parameters[3]];
    self.vendorModel = [self parseItem:parameters[4]];
    self.vendorVersion = [self parseItem:parameters[5]];
    self.vendorSerialNumber = [self parseItem:parameters[6]];
}

- (NSString *)parseItem:(NSURLQueryItem *)item {
    return item.value;
}

@end
