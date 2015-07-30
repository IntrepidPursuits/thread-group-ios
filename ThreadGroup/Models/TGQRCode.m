//
//  TGQRCode.m
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 7/29/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGQRCode.h"

@implementation TGQRCode

- (instancetype)initWithParameters:(NSArray *)parameters {
    self = [super init];
    if (self) {
        [self parseParameters:parameters];
    }
    return self;
}

#pragma mark - Helper methods

- (void)parseParameters:(NSArray *)parameters {
    _qrCodeVersion = [[self parseItem:parameters[0]] integerValue];
    _longAddress = [self parseItem:parameters[1]];
    _connectCode = [self parseItem:parameters[2]];
    _vendorName = [self parseItem:parameters[3]];
    _vendorModel = [self parseItem:parameters[4]];
    _vendorVersion = [self parseItem:parameters[5]];
    _vendorSerialNumber = [self parseItem:parameters[6]];
}

- (NSString *)parseItem:(NSURLQueryItem *)item {
    return item.value;
}


@end
