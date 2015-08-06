//
//  TGDevice.h
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 6/23/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TGQRCode;

@interface TGDevice : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong, readonly) TGQRCode *qrCode;
@property (nonatomic, strong, readonly) NSString *connectCode;

- (instancetype)initWithPassphrase:(NSString *)passphrase;
- (instancetype)initWithQRCode:(TGQRCode *)qrCode;

@end

extern const NSUInteger TGDeviceConnectCodeMaximumCharacters;
extern const NSUInteger TGDeviceConnectCodeMinimumCharacters;