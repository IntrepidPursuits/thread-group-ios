//
//  TGMeshcopManager.m
//  ThreadGroup
//
//  Created by Patrick Butkiewicz on 6/30/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGMeshcopManager.h"

@implementation TGMeshcopManager

+ (instancetype)sharedManager {
    static id _sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        CAResult_t initializeResult;
        initializeResult = MCInitialize();
        NSAssert(initializeResult == CA_STATUS_OK, @"Failed to initialize MeshCop layer");
    }
    return self;
}

#pragma mark - Public

- (void)setMeshCopEnabled:(BOOL)enabled {
    if (enabled) {
        MCStart();
    } else {
        MCStop();
    }
}

- (void)addAnyJoinerCredentials:(NSString *)joinerCredentials {
    MCAddAnyJoinerCredentials([joinerCredentials UTF8String]);
}

- (void)addJoinerWithIdentifier:(NSString *)identifier credentials:(NSString *)credentials {
    MCAddJoinerCredentials([identifier UTF8String], [credentials UTF8String]);
}

- (void)changeToHostAtAddress:(NSString *)address commissionerPort:(NSInteger)port networkType:(CATransportAdapter_t)networkType networkName:(NSString *)name secured:(BOOL)secured {
    MCChangeHost((uint8_t)secured, [address UTF8String], (uint8_t)port, networkType, [name UTF8String]);
}

- (NSData *)petitionAsCommissioner:(NSString *)commissionerIdentifier {
    return nil;
}

- (void)setCallback:(MCCallback_t)callback {
//    f_MCCallback callbackFunc = ^void(const MCCallback_t callbackId){
//        NSLog(@"Callback");
//    };    
}

- (void)setCredentialsWithName:(NSString *)name andKey:(NSString *)clientPSK {
    MCSetCredentials([name UTF8String], [clientPSK UTF8String]);
}

- (void)setPassphrase:(NSString *)passphrase {
    MCSetPassphrase([passphrase UTF8String]);
}

@end
