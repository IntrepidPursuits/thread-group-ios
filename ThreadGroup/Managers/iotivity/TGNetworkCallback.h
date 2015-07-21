//
//  TGNetworkCallback.h
//  ThreadGroup
//
//  Created by Patrick Butkiewicz on 7/30/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MeshCop.h>

@class CallbackResult_COMM_PET;
@class CallbackResult_JOIN_URL;
@class CallbackResult_JOIN_FIN;

@interface TGNetworkCallback : NSObject

// Called when a PetitionAsCommissioner has been issued earlier.
- (void)onPetitionResult:(const CallbackResult_COMM_PET *)result;
// Called when the MeshCop needs to know whether this Commissioner can handle the provisioning URL.

// Only return true if the URL can be handled by this Commissioner.
- (BOOL)onJoinUrlQueryResult:(const CallbackResult_JOIN_URL *)result;

// Called when the MeshCop finalizes the joining of a device.
- (void)onJoinFinishedResult:(const CallbackResult_JOIN_FIN *)result venderStackVersion:(NSString *)vendorStackVersion vsvLength:(NSInteger)vsvLength vendorData:(NSString *)vendorData vdLength:(NSInteger)vdLength;

// Called when an error-response has been received from the network.
- (void)onErrorResponseResult:(NSInteger)mcResult caResponseResult:(NSInteger)caResponseResult token:(NSString *)token tokenLength:(NSInteger)tokenLength;

// Called when a MgmtParamsGet request has been issued and a successful response has been received.
- (void)onMgmtParamReceivedIntForMgmtID:(MCMgmtParamID_t)mcMgmtParamID value:(NSInteger)paramValue;
- (void)onMgmtParamReceivedStrForMgmtID:(MCMgmtParamID_t)mcMgmtParamID value:(NSString *)paramValue;
- (void)onMgmtParamReceivedRawForMgmtID:(MCMgmtParamID_t)mcMgmtParamID value:(NSString *)paramValue length:(NSInteger)paramLength;
- (void)onMgmtParamReceivedObjForMgmtID:(MCMgmtParamID_t)mcMgmtParamID policy:(MCMgmtSecurityPolicy_t *)securityPolicy;

// Called when one of the MgmtParamSetXXX request has been issued.
- (void)onMgmtParamsSetSuccess:(BOOL)success token:(NSString *)token tokenLength:(NSInteger)tokenLength;

// Called when MeshCop needs the data from the secure storage.
// Must return a java.nio.ByteBuffer object holding the secure data.
- (NSData *)getSecureStorage;
// Called when the MeshCop needs to write the data to secure storage.
// The 'storage' parameter, a java.nio.ByteBuffer, cannot be cached. It will become invalid immediately after this method returns.
- (void)setSecureStorage:(NSData *)storage;

@end


// Callback Result Commissioner Petition
@interface CallbackResult_COMM_PET : TGNetworkCallback
@property (nonatomic, strong) NSString *commissionerIdentifer;
@property (nonatomic) NSInteger commissionerSessionIdentifier;
@property (nonatomic) BOOL hasAuthorizationFailed;
@end

// Callback Result Joiner Finished
@interface CallbackResult_JOIN_FIN : TGNetworkCallback
@property (nonatomic, strong) NSString *joinerIdentifier;
@property (nonatomic) MCState_t state;
@property (nonatomic, strong) NSString *provisioningURL;
@property (nonatomic, strong) NSString *vendorName;
@property (nonatomic, strong) NSString *vendorModel;
@property (nonatomic, strong) NSString *vendorSoftwareVersion;
@end

// Callback Result Joiner URL
@interface CallbackResult_JOIN_URL : TGNetworkCallback
@property (nonatomic, strong) NSString *provisioningURL;
@end