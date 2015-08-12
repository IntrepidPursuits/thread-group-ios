//
//  TGMeshcopManager.h
//  ThreadGroup
//
//  Created by Patrick Butkiewicz on 6/30/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MeshCop.h>

@class TGNetworkCallbackResult;
@class TGNetworkCallback;
@protocol TGMeshcopManagerDelegate;

@interface TGMeshcopManager : NSObject
@property (nonatomic, weak) id<TGMeshcopManagerDelegate> delegate;

+ (instancetype)sharedManager;
- (void)setMeshCopEnabled:(BOOL)enabled;
- (void)addAnyJoinerCredentials:(NSString *)joinerCredentials;
- (void)addJoinerWithIdentifier:(NSString *)identifier credentials:(NSString *)credentials;
- (BOOL)changeToHostAtAddress:(NSString *)address commissionerPort:(NSInteger)port networkType:(CATransportAdapter_t)networkType networkName:(NSString *)name secured:(BOOL)secured;
- (NSData *)petitionAsCommissioner:(NSString *)commissionerIdentifier;
- (BOOL)setCredentialsWithName:(NSString *)name andKey:(NSString *)clientPSK;
- (void)setPassphrase:(NSString *)passphrase;
- (NSString *)sendJoinersSteeringDataWithShortForm:(BOOL)shortForm;
- (NSString *)fetchManagementParameters:(NSArray *)paramsArray peekOnly:(BOOL)peek;
- (NSString *)setManagementParameter:(MCMgmtParamID_t)parameter withValue:(id)value;
- (NSString *)setManagementSecurityPolicy:(MCMgmtSecurityPolicy_t *)securityPolicy;

@end

@protocol TGMeshcopManagerDelegate <NSObject>
- (void)meshcopManagerDidReceiveCallbackResponse:(MCCallback_t)responseType responseResult:(TGNetworkCallbackResult *)callbackResult;
@end