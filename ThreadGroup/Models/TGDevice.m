//
//  TGDevice.m
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 6/23/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGDevice.h"
#import "TGNetworkManager.h"

@interface TGDevice()

@property (nonatomic, strong) NSString *passphrase;

@end

@implementation TGDevice

- (instancetype)initWithPassphrase:(NSString *)passphrase {
    self = [super init];
    if (self) {
        _passphrase = passphrase;
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

@end
