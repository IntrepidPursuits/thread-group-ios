//
//  TGMeshcopManager+Logging.m
//  ThreadGroup
//
//  Created by Patrick Butkiewicz on 8/13/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGMeshcopManager+Logging.h"

@implementation TGMeshcopManager (Logging)

- (NSString *)logStringForManagementParameter:(MCMgmtParamID_t)parameter {
    switch (parameter) {
        case MGMT_BORDER_ROUTER_LOC:        return @"BORDER_ROUTER_LOCATION";
        case MGMT_CHANNEL:                  return @"CHANNEL";
        case MGMT_COMMISSIONER_CREDENTIAL:  return @"COMMISSIONER_CREDENTIAL";
        case MGMT_COMMISSIONER_ID:          return @"COMMISSIONER_ID";
        case MGMT_COMMISSIONER_PORT:        return @"COMMISSIONER_PORT";
        case MGMT_COMMISSIONER_SESSION_ID:  return @"COMMISSIONER_SESSION_ID";
        case MGMT_NETWORK_KEY_SEQ:          return @"NETWORK_KEY_SEQUENCE";
        case MGMT_NETWORK_MASTER_KEY:       return @"NETWORK_MASTER_KEY";
        case MGMT_NETWORK_NAME:             return @"NETWORK_NAME";
        case MGMT_NETWORK_ULA:              return @"NETWORK_ULA";
        case MGMT_PAN:                      return @"PAN";
        case MGMT_SECURITY_POLICY:          return @"SECURITY_POLICY";
        case MGMT_STEERING:                 return @"STEERING";
        case MGMT_XPANID:                   return @"XPANID";
        default:                            return @"UNKNOWN";
    }
}

- (NSString *)logStringForCallbackIdentifier:(MCCallback_t)callbackType {
    switch (callbackType) {
        case COMM_PET:          return @"COMMISSIONER_PETTION";
        case ERROR_RESPONSE:    return @"ERROR_RESPONSE";
        case JOIN_FIN:          return @"JOIN_FINISHED";
        case JOIN_URL:          return @"JOIN_PROVISION";
        case MGMT_PARAM_GET:    return @"MANAGEMENT_PARAMETER_GET";
        case MGMT_PARAM_SET:    return @"MANAGEMENT_PARAMETER_SET";
        default:                return @"UNKNOWN";
    }
}

@end
