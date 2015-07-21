//
//  TGNetworkCallback.m
//  ThreadGroup
//
//  Created by Patrick Butkiewicz on 7/30/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGNetworkCallback.h"

@implementation TGNetworkCallback

// Called when a PetitionAsCommissioner has been issued earlier.
- (void)onPetitionResult:(const CallbackResult_COMM_PET *)result {
    NSAssert(YES, @"%s not implemented in base class", __PRETTY_FUNCTION__);
}
// Called when the MeshCop needs to know whether this Commissioner can handle the provisioning URL.

// Only return true if the URL can be handled by this Commissioner.
- (BOOL)onJoinUrlQueryResult:(const CallbackResult_JOIN_URL *)result {
    NSAssert(YES, @"%s not implemented in base class", __PRETTY_FUNCTION__);
    return NO;
}

// Called when the MeshCop finalizes the joining of a device.
- (void)onJoinFinishedResult:(const CallbackResult_JOIN_FIN *)result venderStackVersion:(NSString *)vendorStackVersion vsvLength:(NSInteger)vsvLength vendorData:(NSString *)vendorData vdLength:(NSInteger)vdLength {
    NSAssert(YES, @"%s not implemented in base class", __PRETTY_FUNCTION__);
}

// Called when an error-response has been received from the network.
- (void)onErrorResponseResult:(NSInteger)mcResult caResponseResult:(NSInteger)caResponseResult token:(NSString *)token tokenLength:(NSInteger)tokenLength {
    NSAssert(YES, @"%s not implemented in base class", __PRETTY_FUNCTION__);
}

// Called when a MgmtParamsGet request has been issued and a successful response has been received.
- (void)onMgmtParamReceivedIntForMgmtID:(MCMgmtParamID_t)mcMgmtParamID value:(NSInteger)paramValue {
    NSAssert(YES, @"%s not implemented in base class", __PRETTY_FUNCTION__);
}

- (void)onMgmtParamReceivedStrForMgmtID:(MCMgmtParamID_t)mcMgmtParamID value:(NSString *)paramValue {
    NSAssert(YES, @"%s not implemented in base class", __PRETTY_FUNCTION__);
}

- (void)onMgmtParamReceivedRawForMgmtID:(MCMgmtParamID_t)mcMgmtParamID value:(NSString *)paramValue length:(NSInteger)paramLength {
    NSAssert(YES, @"%s not implemented in base class", __PRETTY_FUNCTION__);
}

- (void)onMgmtParamReceivedObjForMgmtID:(MCMgmtParamID_t)mcMgmtParamID policy:(MCMgmtSecurityPolicy_t *)securityPolicy {
    NSAssert(YES, @"%s not implemented in base class", __PRETTY_FUNCTION__);
}

// Called when one of the MgmtParamSetXXX request has been issued.
- (void)onMgmtParamsSetSuccess:(BOOL)success token:(NSString *)token tokenLength:(NSInteger)tokenLength {
    NSAssert(YES, @"%s not implemented in base class", __PRETTY_FUNCTION__);
}

// Called when MeshCop needs the data from the secure storage.
// Must return a java.nio.ByteBuffer object holding the secure data.
- (NSData *)getSecureStorage {
    NSAssert(YES, @"%s not implemented in base class", __PRETTY_FUNCTION__);
    return nil;
}
// Called when the MeshCop needs to write the data to secure storage.
// The 'storage' parameter, a java.nio.ByteBuffer, cannot be cached. It will become invalid immediately after this method returns.
- (void)setSecureStorage:(NSData *)storage {
    NSAssert(YES, @"%s not implemented in base class", __PRETTY_FUNCTION__);
}

@end
