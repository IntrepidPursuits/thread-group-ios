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

+ (TGQRCode *)qrCodeWithParameters:(NSArray *)parameters {
    if ([TGQRCode canParseParameters:parameters]) {
        return [[TGQRCode alloc] initWithParameters:parameters];
    } else {
        return nil;
    }
}

- (instancetype)initWithParameters:(NSArray *)parameters {
    self = [super init];
    if (self) {
        [self parseParameters:parameters];
    }
    return self;
}

- (void)parseParameters:(NSArray *)parameters {
    for (NSURLQueryItem *item in parameters) {
        NSArray *parameterKeys = [TGQRCode keys];
        NSInteger index = [parameterKeys indexOfObject:item.name];
        if ([[parameterKeys objectAtIndex:index] isEqualToString:kQRCodeVersionKey]) {
            _qrCodeVersion = [item.value integerValue];
        }
        if ([[parameterKeys objectAtIndex:index] isEqualToString:kEUI64Key]) {
            _longAddress = item.value;
        }
        if ([[parameterKeys objectAtIndex:index] isEqualToString:kConnectCodeKey]) {
            _connectCode = item.value;
        }
        if ([[parameterKeys objectAtIndex:index] isEqualToString:kVendorNameKey]) {
            _vendorName = item.value;;
        }
        if ([[parameterKeys objectAtIndex:index] isEqualToString:kVendorModelKey]) {
            _vendorModel = item.value;;
        }
        if ([[parameterKeys objectAtIndex:index] isEqualToString:kVendorVersionKey]) {
            _vendorVersion = item.value;
        }
        if ([[parameterKeys objectAtIndex:index] isEqualToString:kVendorProductSerialNumberKey]) {
            _vendorSerialNumber = item.value;;
        }
    }
}

#pragma mark - QR Code validation

+ (BOOL)canParseParameters:(NSArray *)parameters {
    NSArray *parameterkeys = [TGQRCode keysFromParameters:parameters];
    if ([TGQRCode hasCorrectVerisonNumber:parameters] && [TGQRCode hasRequiredParameterKeys:parameterkeys]) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)hasRequiredParameterKeys:(NSArray *)parameterKeys {
    for (NSString *key in [TGQRCode requiredKeys]) {
        if (![parameterKeys containsObject:key]) {
            return NO;
        }
    }
    return YES;

}

+ (BOOL)hasCorrectVerisonNumber:(NSArray *)parameters {
    for (NSURLQueryItem *item in parameters) {
        if ([item.name isEqualToString:kQRCodeVersionKey] && [item.value isEqualToString:kCurrentQRCodeVersion]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - Helpers

+ (NSArray *)keysFromParameters:(NSArray *)parameters {
    NSMutableArray *mutableArray = [NSMutableArray new];
    for (NSURLQueryItem *item in parameters) {
        [mutableArray addObject:item.name];
    }
    return mutableArray;
}

#pragma mark - Keys

+ (NSArray *)keys {
    return @[kQRCodeVersionKey, kEUI64Key, kConnectCodeKey, kVendorNameKey, kVendorModelKey, kVendorVersionKey, kVendorProductSerialNumberKey];
}

+ (NSArray *)requiredKeys {
    return @[kQRCodeVersionKey, kEUI64Key, kConnectCodeKey];
}

@end
