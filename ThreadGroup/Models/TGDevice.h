//
//  TGDevice.h
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 6/23/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  A representation of a thread enabled device. 
 */
@interface TGDevice : NSObject

@property (nonatomic, strong) NSString *name;

//As define by the QR code specification
@property (nonatomic, readonly) NSUInteger qrCodeVersion; //uint8
@property (nonatomic, strong, readonly) NSString *longAddress; //ASCII Hex
@property (nonatomic, strong, readonly) NSString *connectCode; //base32-thread
@property (nonatomic, strong, readonly) NSString *vendorName; //utf-8
@property (nonatomic, strong, readonly) NSString *vendorModel; //utf-8
@property (nonatomic, strong, readonly) NSString *vendorVersion; //utf-8
@property (nonatomic, strong, readonly) NSString *vendorSerialNumber; //String

- (instancetype)initWithPassphrase:(NSString *)passphrase;
- (void)isPassphraseValidWithCompletion:(void(^)(BOOL success))completion;
- (instancetype)initWithParamaters:(NSArray *)parameters;

@end

extern const NSUInteger TGDeviceConnectCodeMaximumCharacters;
extern const NSUInteger TGDeviceConnectCodeMinimumCharacters;