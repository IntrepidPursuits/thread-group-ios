//
//  TGQRCode.m
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 7/29/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGQRCode.h"

static NSString * const kCurrentQRCodeVersion = @"1";

static NSString * const kQRCodeVersionKey = @"v";
static NSString * const kEUI64Key = @"eui";
static NSString * const kConnectCodeKey = @"cc";
static NSString * const kVendorNameKey = @"vn";
static NSString * const kVendorModelKey = @"vm";
static NSString * const kVendorVersionKey = @"vv";
static NSString * const kVendorProductSerialNumberKey = @"vs";

@interface TGQRCode()
@property (nonatomic, strong) NSArray *parameters;
@property (nonatomic, strong) NSArray *parameterKeys;

@property (nonatomic, strong) NSArray *keys;
@property (nonatomic, strong) NSArray *requiredKeys;

@property (nonatomic) NSUInteger qrCodeVersion; //uint8
@property (nonatomic, strong) NSString *longAddress; //ASCII Hex
@property (nonatomic, strong) NSString *connectCode; //base32-thread
@property (nonatomic, strong) NSString *vendorName; //utf-8
@property (nonatomic, strong) NSString *vendorModel; //utf-8
@property (nonatomic, strong) NSString *vendorVersion; //utf-8
@property (nonatomic, strong) NSString *vendorSerialNumber; //String

@end

@implementation TGQRCode

- (instancetype)initWithParameters:(NSArray *)parameters {
    self = [super init];
    if (self) {
        self.parameters = parameters;
        if ([self canParseParameters]) {
            [self parseParameters];
        } else {
            NSLog(@"Could not parse QR Code");
            return nil;
        }
    }
    return self;
}

- (void)parseParameters {
    for (NSURLQueryItem *item in self.parameters) {
        NSInteger index = [self.keys indexOfObject:item.name];
        if ([[self.keys objectAtIndex:index] isEqualToString:kQRCodeVersionKey]) {
            _qrCodeVersion = [item.value integerValue];
        }
        if ([[self.keys objectAtIndex:index] isEqualToString:kEUI64Key]) {
            _longAddress = item.value;
        }
        if ([[self.keys objectAtIndex:index] isEqualToString:kConnectCodeKey]) {
            _connectCode = item.value;
        }
        if ([[self.keys objectAtIndex:index] isEqualToString:kVendorNameKey]) {
            _vendorName = item.value;;
        }
        if ([[self.keys objectAtIndex:index] isEqualToString:kVendorModelKey]) {
            _vendorModel = item.value;;
        }
        if ([[self.keys objectAtIndex:index] isEqualToString:kVendorVersionKey]) {
            _vendorVersion = item.value;
        }
        if ([[self.keys objectAtIndex:index] isEqualToString:kVendorProductSerialNumberKey]) {
            _vendorSerialNumber = item.value;;
        }
    }
}

#pragma mark - QR Code validation

- (BOOL)canParseParameters {
    if ([self hasRequiredParameterKeys] && [self hasCorrectVerisonNumber]) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)hasRequiredParameterKeys {
    for (NSString *key in self.requiredKeys) {
        if (![self.parameterKeys containsObject:key]) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)hasCorrectVerisonNumber {
    for (NSURLQueryItem *item in self.parameters) {
        if ([item.name isEqualToString:kQRCodeVersionKey] && [item.value isEqualToString:kCurrentQRCodeVersion]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - Helpers

- (NSArray *)keysFromParameters:(NSArray *)parameters {
    NSMutableArray *mutableArray;
    for (NSURLQueryItem *item in parameters) {
        [mutableArray addObject:item.name];
    }
    return mutableArray;
}

#pragma mark - Setters

- (void)setParameters:(NSArray *)parameters {
    _parameters = parameters;
    _parameterKeys = [self keysFromParameters:parameters];
}

#pragma mark - Getters

- (NSArray *)keys {
    if (!_keys) {
        _keys = @[kQRCodeVersionKey, kEUI64Key, kConnectCodeKey, kVendorNameKey, kVendorModelKey, kVendorVersionKey, kVendorProductSerialNumberKey];
    }
    return _keys;
}

- (NSArray *)requiredKeys {
    if (!_requiredKeys) {
        _requiredKeys = @[kQRCodeVersionKey, kEUI64Key, kConnectCodeKey];
    }
    return _requiredKeys;
}

- (NSUInteger)qrCodeVersion {
    if (!_qrCodeVersion) {
        _qrCodeVersion = 0;
    }
    return _qrCodeVersion;
}

- (NSString *)longAddress {
    if (!_longAddress) {
        _longAddress = @"";
    }
    return _longAddress;
}

- (NSString *)connectCode {
    if (!_connectCode) {
        _connectCode = @"";
    }
    return _connectCode;
}

- (NSString *)vendorName {
    if (!_vendorName) {
        _vendorName = @"";
    }
    return _vendorName;
}

- (NSString *)vendorModel {
    if (!_vendorModel) {
        _vendorModel = @"";
    }
    return _vendorModel;
}

- (NSString *)vendorVersion {
    if (!_vendorVersion) {
        _vendorVersion = @"";
    }
    return _vendorVersion;
}

- (NSString *)vendorSerialNumber {
    if (!_vendorSerialNumber) {
        _vendorSerialNumber = @"";
    }
    return _vendorSerialNumber;
}

@end
