//
//  TGDevice.h
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 6/23/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TGQRCode;
/**
 *  A representation of a thread enabled device. 
 */
@interface TGDevice : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong, readonly) TGQRCode *qrCode;

- (instancetype)initWithPassphrase:(NSString *)passphrase;
- (void)isPassphraseValidWithCompletion:(void(^)(BOOL success))completion;
- (instancetype)initWithQRCode:(TGQRCode *)qrCode;

@end

extern const NSUInteger TGDeviceConnectCodeMaximumCharacters;
extern const NSUInteger TGDeviceConnectCodeMinimumCharacters;