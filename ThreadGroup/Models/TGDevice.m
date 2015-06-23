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

- (void)isConnectCodeValidWithCompletion:(void(^)(BOOL success))completion {
    [[TGNetworkManager sharedManager] connectDevice:self.connectCode completion:^(NSError *__autoreleasing *error) {
        if (!error) {
            completion(YES);
        } else
            completion(NO);
    }];
}

@end
