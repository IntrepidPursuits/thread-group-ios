//
//  TGQRCode.h
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 7/29/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TGQRCode : NSObject

+ (TGQRCode *)qrCodeWithParameters:(NSArray *)parameters;

@property (nonatomic, readonly) NSUInteger qrCodeVersion; //uint8
@property (nonatomic, strong, readonly) NSString *longAddress; //ASCII Hex
@property (nonatomic, strong, readonly) NSString *connectCode; //base32-thread
@property (nonatomic, strong, readonly) NSString *vendorName; //utf-8
@property (nonatomic, strong, readonly) NSString *vendorModel; //utf-8
@property (nonatomic, strong, readonly) NSString *vendorVersion; //utf-8
@property (nonatomic, strong, readonly) NSString *vendorSerialNumber; //String

@end
