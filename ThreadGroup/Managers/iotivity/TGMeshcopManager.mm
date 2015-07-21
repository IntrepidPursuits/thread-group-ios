//
//  TGMeshcopManager.m
//  ThreadGroup
//
//  Created by Patrick Butkiewicz on 6/30/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGMeshcopManager.h"
#import <cainterface.h>
#import <cacommon.h>
#import <logger.h>
#import <exception>
#import "CallbackBase.h"
#import <MCSecStorage.h>
#import <malloc/malloc.h>

#define LOG_TAG "MeshCop"

static CallbackBase* g_clientCallback = NULL;

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

- (BOOL)changeToHostAtAddress:(NSString *)address commissionerPort:(NSInteger)port networkType:(CATransportAdapter_t)networkType networkName:(NSString *)name secured:(BOOL)secured {
    CAResult_t res = CASelectNetwork(networkType);
    if (res == CA_STATUS_OK) {
        CAResult_t result = MCChangeHost((uint8_t)secured, [address UTF8String], (uint8_t)port, networkType, [name UTF8String]);
        return (result == CA_STATUS_OK);
    }
    return NO;
}

- (NSData *)petitionAsCommissioner:(NSString *)commissionerIdentifier {
    CAToken_t token = COMM_PET_request([commissionerIdentifier UTF8String]);
    return [[NSString stringWithUTF8String:token] dataUsingEncoding:NSUTF8StringEncoding];
}

- (void)setCallback:(CallbackBase *)callback {
    g_clientCallback = callback;
}

- (BOOL)setCredentialsWithName:(NSString *)name andKey:(NSString *)clientPSK {
    CAResult_t result = MCSetCredentials([name UTF8String], [clientPSK UTF8String]);
    return (result == CA_STATUS_OK);
}

- (void)setPassphrase:(NSString *)passphrase {
    MCSetPassphrase([passphrase UTF8String]);
}

#pragma mark - Get/Set Storage

static const MCSecStorage_t* _getStorageData(f_readStorageFromData fReadStorageFromData) {
    if (!g_clientCallback) {
        return NULL;
    }
    
    const void * storage = g_clientCallback->getSecureStorage();
    if (!storage) {
        return NULL;
    }
    
    NSUInteger bufferLength = malloc_size(storage);
    NSData *buffer = [[NSData alloc] initWithBytes:&storage length:bufferLength];
    uint8_t *byteBuffer = (uint8_t *)[buffer bytes];
    const MCSecStorage_t* retVal = fReadStorageFromData(byteBuffer, (uint32_t)bufferLength);
    return retVal;
}

static void _setStorageData(const uint8_t * const data, uint32_t const dataLen) {
    if (!g_clientCallback) {
        return;
    }
    
    NSData *buffer = [NSData dataWithBytes:data length:dataLen];
    g_clientCallback->setSecureStorage((void *)[buffer bytes]);
}

#pragma mark - Management

static void handleMGMT_PARAM_GET(MCMgmtParamID_t paramID, va_list argsList) {
    switch (paramID) {
        case MGMT_CHANNEL:
        case MGMT_PAN:
        case MGMT_BORDER_ROUTER_LOC:
        case MGMT_COMMISSIONER_SESSION_ID:
        case MGMT_COMMISSIONER_PORT:
        case MGMT_NETWORK_KEY_SEQ:
            // Numeric values.
            g_clientCallback->onMgmtParamReceivedInt(paramID, va_arg(argsList, int));
            break;
            
        case MGMT_NETWORK_NAME:
        case MGMT_COMMISSIONER_CREDENTIAL:
        case MGMT_COMMISSIONER_ID:
            // String values.
            g_clientCallback->onMgmtParamReceivedStr(paramID, va_arg(argsList, char*));
            break;
            
        case MGMT_SECURITY_POLICY:
            g_clientCallback->onMgmtParamReceivedObj(paramID, va_arg(argsList, MCMgmtSecurityPolicy_t*));
            break;
            
        case MGMT_XPANID:
        case MGMT_NETWORK_MASTER_KEY:
        case MGMT_NETWORK_ULA:
        default: {
            // Raw values.
            char* rawVal = va_arg(argsList, char*);
            int   length = va_arg(argsList, int);
            g_clientCallback->onMgmtParamReceivedRaw(paramID, rawVal, length);
        }
            break;
    }
}

- (NSString *)sendJoinersSteeringDataWithShortForm:(BOOL)shortForm {
    CAToken_t token = MCSendJoinersSteeringData((uint8_t)shortForm);
    return [NSString stringWithUTF8String:token];
}

- (NSString *)petitionAsCommissionerWithIdentifier:(NSString *)commissionerIdentifier {
    CAToken_t token = COMM_PET_request([commissionerIdentifier UTF8String]);
    return [NSString stringWithUTF8String:token];
}

- (NSString *)mgmtParamsGetArray:(NSArray *)paramsArray peekOnly:(BOOL)peek{
    NSMutableData *params = [NSMutableData new];
    for (NSNumber *num in paramsArray) {
        NSInteger integer = [num integerValue];
        NSData *data = [NSData dataWithBytes:&integer length:sizeof(integer)];
        [params appendData:data];
    }
    
    uint8_t arrayCount = (uint8_t)paramsArray.count;
    uint8_t *paramBytes = (uint8_t *) malloc(sizeof(*paramBytes) * arrayCount);
    memcpy(paramBytes, [params bytes], arrayCount);
    CAToken_t token = MGMT_GET_request(paramBytes, arrayCount, (uint8_t)peek);
    return [NSString stringWithUTF8String:token];
}

// Implemented above with additional peek parameter
//void MgmtParamsPeek(char *byteArray, int arrayLength)


- (NSString *)mgmtParamSet:(MCMgmtParamID_t)paramIdentifier withInteger:(NSInteger)paramValue {
    CAToken_t token = MGMT_SET(paramIdentifier, paramValue);
    return [NSString stringWithUTF8String:token];
}

- (NSString *)mgmtParamSet:(MCMgmtParamID_t)paramIdentifier withString:(NSString *)stringValue {
    CAToken_t token = MGMT_SET(paramIdentifier, [stringValue UTF8String]);
    return [NSString stringWithUTF8String:token];
}

- (NSString *)mgmtParamSetRawParameter:(MCMgmtParamID_t)paramIdentifier withParamValue:(NSString *)paramValue {
    CAToken_t token = MGMT_SET(paramIdentifier, [paramValue UTF8String], (uint8_t)paramValue.length);
    return [NSString stringWithUTF8String:token];
}

- (NSString *)mgmtParamSetObj:(MCMgmtParamID_t)paramIdentifier withSecurityPolicy:(MCMgmtSecurityPolicy_t *)securityPolicy {
    CAToken_t token = MGMT_SET(paramIdentifier, securityPolicy);
    return [NSString stringWithUTF8String:token];
}

#pragma mark - Callback

static void* _callback(const MCCallback_t callbackId, ...) {
    if (!g_clientCallback) {
        return NULL;
    }
    
    va_list argsList;
    va_start(argsList, callbackId);
    
    try {
        switch(callbackId) {
                
            case COMM_PET: {
                CallbackResult_COMM_PET* result1 = new CallbackResult_COMM_PET();
                result1->commissionerId = va_arg(argsList, char*);
                result1->commissionerSessionId = (uint16_t)va_arg(argsList, int);
                result1->hasAuthorizationFailed = (bool)va_arg(argsList, int);
                g_clientCallback->onPetitionResult(result1);
                delete result1;
            }
                break;
                
            case JOIN_URL: {
                CallbackResult_JOIN_URL* result2 = new CallbackResult_JOIN_URL();
                result2->provisioningURL = va_arg(argsList, char*);
                g_clientCallback->onJoinUrlQuery(result2);
                delete result2;
            }
                break;
                
            case JOIN_FIN: {
                CallbackResult_JOIN_FIN* result3 = new CallbackResult_JOIN_FIN();
                
                char* joinerIID = va_arg(argsList, char*);
                if (joinerIID) {
                    memcpy(result3->joinerIID, joinerIID, 8);
                }
                else {
                    memset(result3->joinerIID, 0, 8);
                }
                result3->state = (MCState_t)va_arg(argsList, int);
                result3->provisioningURL = va_arg(argsList, char*);
                result3->vendorName = va_arg(argsList, char*);
                result3->vendorModel = va_arg(argsList, char*);
                result3->vendorSoftwareVersion = va_arg(argsList, char*);
                
                char empty[1] = "";
                char*  vendorSV      = va_arg(argsList, char*);
                int    vendorSVLen   = va_arg(argsList, int);
                char*  vendorData    = va_arg(argsList, char*);
                int    vendorDataLen = va_arg(argsList, int);
                
                g_clientCallback->onJoinFinished(
                                                 result3,
                                                 vendorSV? vendorSV : empty, vendorSVLen,
                                                 vendorData? vendorData : empty, vendorDataLen);
                
                delete result3;
            }
                break;
                
            case ERROR_RESPONSE: {
                int    mcResult         = va_arg(argsList, int);
                int    caResponseResult = va_arg(argsList, int);
                char*  token            = va_arg(argsList, char*);
                int    tokenLength      = va_arg(argsList, int);
                g_clientCallback->onErrorResponse(mcResult, caResponseResult, token, tokenLength);
            }
                break;
                
            case MGMT_PARAM_GET: {
                MCMgmtParamID_t paramID = (MCMgmtParamID_t)va_arg(argsList, int);
                handleMGMT_PARAM_GET(paramID, argsList);
            }
                break;
                
            case MGMT_PARAM_SET: {
                int    success     = va_arg(argsList, int);
                char*  token       = va_arg(argsList, char*);
                int    tokenLength = va_arg(argsList, int);
                g_clientCallback->onMgmtParamsSet(success? true : false, token, tokenLength);
            }
                break;
                
        } // switch
        
    }
    catch (std::exception& e) {
        OICLogv(ERROR, LOG_TAG, "Callback exception: %s", e.what());
    }
    
    va_end(argsList);
    return NULL;
}

@end
