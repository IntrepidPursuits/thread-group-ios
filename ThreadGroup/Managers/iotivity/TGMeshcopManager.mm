//
//  TGMeshcopManager.m
//  ThreadGroup
//
//  Created by Patrick Butkiewicz on 6/30/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGMeshcopManager.h"
#import <iotivity-csdk-thread/cainterface.h>
#import "TGNetworkCallbackResult.h"
#import "TGMeshcopManager+Logging.h"
#import "TGLogManager.h"

#define LOG_TAG "MeshCop"

#pragma mark - Callback

static void* _callback(const MCCallback_t callbackId, ...) {
    va_list argsList;
    va_start(argsList, callbackId);
    
    TGNetworkCallbackResult *callbackResult;
    
    switch(callbackId) {
        case COMM_PET:
            callbackResult = [[TGNetworkCallbackComissionerPetitionResult alloc] initWithArguments:argsList];
            break;
        case JOIN_URL:
            callbackResult = [[TGNetworkCallbackJoinResult alloc] initWithArguments:argsList];
            break;
        case JOIN_FIN:
            callbackResult = [[TGNetworkCallbackJoinerFinishedResult alloc] initWithArguments:argsList];
            break;
        case ERROR_RESPONSE:
            callbackResult = [[TGNetworkCallbackErrorResult alloc] initWithArguments:argsList];
            break;
        case MGMT_PARAM_GET: {
            callbackResult = [[TGNetworkCallbackFetchSettingResult alloc] initWithArguments:argsList];
        }
            break;
        case MGMT_PARAM_SET: {
            callbackResult = [[TGNetworkCallbackSetSettingResult alloc] initWithArguments:argsList];
        }
            break;
        default: {
            return NULL;
        }
    }
    
    va_end(argsList);
 
    id<TGMeshcopManagerDelegate> callbackDelegate = [TGMeshcopManager sharedManager].delegate;
    
    if ([callbackDelegate respondsToSelector:@selector(meshcopManagerDidReceiveCallbackResponse:responseResult:)]) {
        [callbackDelegate meshcopManagerDidReceiveCallbackResponse:callbackId responseResult:callbackResult];
    }

    return NULL;
}

#pragma mark - Get/Set Storage

static NSData *tempStorage = nil;
static uint32_t tempStorageSize = 0;

static const MCSecStorage_t* _getStorageData(f_readStorageFromData fReadStorageFromData) {
    const MCSecStorage_t *retVal = fReadStorageFromData((const uint8_t *)[tempStorage bytes], tempStorageSize);
    return retVal;
}

static void _setStorageData(const uint8_t * const data, uint32_t const dataLen) {
    tempStorage = [NSData dataWithBytes:data length:dataLen];
    tempStorageSize = dataLen;
}

#pragma mark - Implementation

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
        NSLog(@"Initializing Meshcop layer");
        CAResult_t initializeResult;
        initializeResult = MCInitialize();
        NSAssert(initializeResult == CA_STATUS_OK, @"Failed to initialize MeshCop layer");
        MCSetCallback(_callback);
        setStorageDataCallback(_getStorageData, _setStorageData);
    }
    return self;
}

#pragma mark - Public

- (void)setMeshCopEnabled:(BOOL)enabled {
    if (enabled) {
        NSLog(@"Starting Meshcop Layer");
        MCStart();
    } else {
        NSLog(@"Stopping Meshcop Layer");
        MCStop();
    }
}

- (void)addAnyJoinerCredentials:(NSString *)joinerCredentials {
    NSLog(@"Adding joiner credentials <%@>" , joinerCredentials);
    MCAddAnyJoinerCredentials([joinerCredentials UTF8String]);
}

- (void)addJoinerWithIdentifier:(NSString *)identifier credentials:(NSString *)credentials {
    NSLog(@"Adding joiner credentials with identifier <%@> and passphrase <%@>", identifier, credentials);
    MCAddJoinerCredentials([identifier UTF8String], [credentials UTF8String]);
}

- (BOOL)changeToHostAtAddress:(NSString *)address commissionerPort:(NSInteger)port networkType:(CATransportAdapter_t)networkType networkName:(NSString *)name secured:(BOOL)secured {
    NSLog(@"Selecting network at address <%@:%ld> named <%@>", address, port, name);
    CAResult_t res = CASelectNetwork(networkType);
    if (res == CA_STATUS_OK) {
        NSLog(@"Changing host to address <%@:%ld> named <%@>", address, port, name);
        CAResult_t result = MCChangeHost((uint8_t)secured, [address UTF8String], (uint16_t)port, networkType, [name UTF8String], 0);
        return (result == CA_STATUS_OK);
    }
    return NO;
}

- (NSData *)petitionAsCommissioner:(NSString *)commissionerIdentifier {
    NSLog(@"Petitioning as commissioner with identifier <%@>", commissionerIdentifier);
    CAToken_t token = MCCommPet_request([commissionerIdentifier UTF8String]);
    size_t tokenLength = strlen(token);
    return [NSData dataWithBytes:(const void *)token length:tokenLength];
}

- (void)setCredentialsWithName:(NSString *)name andKey:(NSString *)clientPSK {
    NSLog(@"Setting credentials with name <%@> and key <%@>", name, clientPSK);
//    CAResult_t result = MCSetCredentials([name UTF8String], [clientPSK UTF8String]);
    MCAddJoinerCredentials([name UTF8String], [clientPSK UTF8String]);
}

- (void)setPassphrase:(NSString *)passphrase {
    NSLog(@"Setting passphrase to <%@>", passphrase);
    MCSetPassphrase([passphrase UTF8String], 0);
}

#pragma mark - Management

- (NSString *)sendJoinersSteeringDataWithShortForm:(BOOL)shortForm {
    NSLog(@"Sending joiner steering data. Using short form '%@'", shortForm ? @"Y" : @"N");
    CAToken_t token = MCSendJoinersSteeringData((uint8_t)shortForm);
    return [NSString stringWithUTF8String:token];
}

- (NSString *)fetchManagementParameters:(NSArray *)paramsArray peekOnly:(BOOL)peek {
    NSMutableData *params = [NSMutableData new];
    for (NSNumber *num in paramsArray) {
        MCMgmtParamID_t param = (MCMgmtParamID_t)[num intValue];
        NSLog(@"Preparing to fetch management parameter <%@>", [self logStringForManagementParameter:param]);
        Byte tlvByte = (Byte)param;
        [params appendBytes:&tlvByte length:1];
    }
    
    NSLog(@"Executing fetch request for %ld parameters", paramsArray.count);
    CAToken_t token = MCMgmtGet_request((uint8_t *)[params bytes], (uint8_t)paramsArray.count, (uint8_t)peek);
    return [NSString stringWithUTF8String:token];
}

- (NSString *)setManagementParameter:(MCMgmtParamID_t)parameter withValue:(id)value {
    NSLog(@"Setting management parameter <%@> to value <%@>", [self logStringForManagementParameter:parameter], [value description]);
    
    CAToken_t token;
    if ([value isKindOfClass:[NSNumber class]]) {
        token = MCMgmtSet(parameter, [value integerValue]);
    } else if ([value isKindOfClass:[NSString class]]) {
        token = MCMgmtSet(parameter, [(NSString *)value UTF8String]);
    }

    return [NSString stringWithUTF8String:token];
}

- (NSString *)setManagementSecurityPolicy:(MCMgmtSecurityPolicy_t *)securityPolicy {
    NSLog(@"Setting new security policy");
    CAToken_t token = MCMgmtSet(MGMT_SECURITY_POLICY, securityPolicy);
    return [NSString stringWithUTF8String:token];
}

@end
