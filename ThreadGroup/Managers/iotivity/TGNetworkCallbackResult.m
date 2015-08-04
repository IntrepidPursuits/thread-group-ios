//
//  TGNetworkCallbackResult.m
//  ThreadGroup
//
//  Created by Patrick Butkiewicz on 8/4/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGNetworkCallbackResult.h"

@implementation TGNetworkCallbackResult

- (instancetype)initWithArguments:(va_list)args {
    NSAssert(NO, @"Must instantiate a sublass of this class");
    return nil;
}

@end

@implementation TGNetworkCallbackComissionerPetitionResult

- (instancetype)initWithArguments:(va_list)args {
    self = [super init];
    if (self) {
        NSString *commissionerIdentifier = [NSString stringWithUTF8String:va_arg(args, char *)];
        NSInteger commissionerSessionIdentifier = (NSInteger)va_arg(args, int);
        BOOL authorizationFailed = (BOOL)va_arg(args, int);
        
        [self setCommissionerIdentifer:commissionerIdentifier];
        [self setCommissionerSessionIdentifier:commissionerSessionIdentifier];
        [self setHasAuthorizationFailed:authorizationFailed];
    }
    return self;
}

@end

@implementation TGNetworkCallbackJoinerFinishedResult

- (instancetype)initWithArguments:(va_list)args {
    self = [super init];
    if (self) {
        NSString *joinerIdentifier = [NSString stringWithUTF8String:va_arg(args, char *)];
        MCState_t state = (MCState_t)va_arg(args, int);
        NSString *provisioningURL = [NSString stringWithUTF8String:va_arg(args, char *)];
        NSString *vendorName = [NSString stringWithUTF8String:va_arg(args, char *)];
        NSString *vendorModel = [NSString stringWithUTF8String:va_arg(args, char *)];
        NSString *vendorSoftwareVersion = [NSString stringWithUTF8String:va_arg(args, char *)];
        
        [self setJoinerIdentifier:joinerIdentifier];
        [self setState:state];
        [self setProvisioningURL:provisioningURL];
        [self setVendorName:vendorName];
        [self setVendorModel:vendorModel];
        [self setVendorSoftwareVersion:vendorSoftwareVersion];
    }
    return self;
}

@end

@implementation TGNetworkCallbackJoinResult

- (instancetype)initWithArguments:(va_list)args {
    self = [super init];
    if (self) {
        NSString *provisioningURL = [NSString stringWithUTF8String:va_arg(args, char *)];
        [self setProvisioningURL:provisioningURL];
    }
    return self;
}

@end

@implementation TGNetworkCallbackErrorResult

- (instancetype)initWithArguments:(va_list)args {
    self = [super init];
    if (self) {
        NSInteger mcResult = (NSInteger)va_arg(args, int);
        NSInteger caResponseResult = (NSInteger)va_arg(args, int);
        NSString *token = [NSString stringWithUTF8String:va_arg(args, char *)];
        self.mcResult = mcResult;
        self.caResult = caResponseResult;
        self.token = token;
    }
    return self;
}

@end

@implementation TGNetworkCallbackFetchSettingResult

- (instancetype)initWithArguments:(va_list)args {
    self = [super init];
    if (self) {
        self.parameterIdentifier = (MCMgmtParamID_t)va_arg(args, int);
        id returnValue;
        
        switch (self.parameterIdentifier) {
            case MGMT_CHANNEL:
            case MGMT_PAN:
            case MGMT_BORDER_ROUTER_LOC:
            case MGMT_COMMISSIONER_SESSION_ID:
            case MGMT_COMMISSIONER_PORT:
            case MGMT_NETWORK_KEY_SEQ: {
                // Numeric values.
                NSInteger val = (NSInteger)va_arg(args, int);
                returnValue = @(val);
                break;
            }
            case MGMT_NETWORK_NAME:
            case MGMT_COMMISSIONER_CREDENTIAL:
            case MGMT_COMMISSIONER_ID: {
                // String values.
                returnValue = [NSString stringWithUTF8String:va_arg(args, char *)];
                break;
            }
            case MGMT_SECURITY_POLICY: {
                MCMgmtSecurityPolicy_t *securityPolicy = va_arg(args, MCMgmtSecurityPolicy_t *);
                returnValue = (__bridge id)(securityPolicy);
                break;
            }
            case MGMT_XPANID:
            case MGMT_NETWORK_MASTER_KEY:
            case MGMT_NETWORK_ULA:
            default: {
                // Raw values.
                char *rawCharVal = va_arg(args, char *);
                returnValue = [NSString stringWithUTF8String:rawCharVal];
                break;
            }
        }
    }
    return self;
}



@end
