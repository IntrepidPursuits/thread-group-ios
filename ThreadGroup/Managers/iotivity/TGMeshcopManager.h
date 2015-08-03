//
//  TGMeshcopManager.h
//  ThreadGroup
//
//  Created by Patrick Butkiewicz on 6/30/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MeshCop.h>
#import "TGNetworkCallback.h"

@interface TGMeshcopManager : NSObject

+ (instancetype)sharedManager;
- (void)setMeshCopEnabled:(BOOL)enabled;
- (void)addAnyJoinerCredentials:(NSString *)joinerCredentials;
- (void)addJoinerWithIdentifier:(NSString *)identifier credentials:(NSString *)credentials;
- (BOOL)changeToHostAtAddress:(NSString *)address commissionerPort:(NSInteger)port networkType:(CATransportAdapter_t)networkType networkName:(NSString *)name secured:(BOOL)secured;
- (NSData *)petitionAsCommissioner:(NSString *)commissionerIdentifier;
- (BOOL)setCredentialsWithName:(NSString *)name andKey:(NSString *)clientPSK;
- (void)setPassphrase:(NSString *)passphrase;
- (void)setCallback:(TGNetworkCallback *)callback;

@end
