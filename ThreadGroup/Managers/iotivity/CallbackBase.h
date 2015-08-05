//
//  CallbackBase.h
//  ThreadGroup
//
//  Created by Patrick Butkiewicz on 7/22/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#ifndef __ThreadGroup__CallbackBase__
#define __ThreadGroup__CallbackBase__

#include <stdio.h>
#include <MeshCop.h>

class CallbackResult {
public:
    virtual ~CallbackResult() = 0;
protected:
    CallbackResult() {}
};

// Holds result after a PetitionAsCommissioner call.
// When it commissionerSessionId is set, the Petition was successful and this device is now the Commissioner.
// When its commissionerId is set, the Petition was refused/abandoned and another device is the Commissioner,
// If both are not set, the Petitions was refused/abandoned but the name of the current Commissioner is unknown.
class CallbackResult_COMM_PET : public CallbackResult {
public:
    char* commissionerId;
    int   commissionerSessionId;
    bool  hasAuthorizationFailed;
    CallbackResult_COMM_PET(): commissionerId(NULL), commissionerSessionId(0), hasAuthorizationFailed(false) {}
    virtual ~CallbackResult_COMM_PET() {}
};

// Holds result when a Joiner is request to be added to the Commissioner's network.
// This Commissioner should examine the provisioning-URL and see if it could handle this provisiong-URL.
class CallbackResult_JOIN_URL : public CallbackResult {
public:
    char* provisioningURL;
    CallbackResult_JOIN_URL() : provisioningURL(NULL) {}
    virtual ~CallbackResult_JOIN_URL() {}
};

// When a Joiner finalizes his joining the network, it will provide this Commissioner with data about
// itself. This result holds all that data.
class CallbackResult_JOIN_FIN : public CallbackResult {
public:
    char joinerIID[8];
    MCState_t state;
    char* provisioningURL;
    char* vendorName;
    char* vendorModel;
    char* vendorSoftwareVersion;
    CallbackResult_JOIN_FIN() : state(PENDING), provisioningURL(NULL), vendorName(NULL), vendorModel(NULL), vendorSoftwareVersion(NULL) {
        _memset(joinerIID, 0, 8);
    }
    virtual ~CallbackResult_JOIN_FIN() {}
};

class CallbackBase {
public:
    virtual ~CallbackBase() {}
    
    // Called when a PetitionAsCommissioner has been issued earlier.
    virtual void onPetitionResult(const CallbackResult_COMM_PET *result);
    // Called when the MeshCop needs to know whether this Commissioner can handle the provisioning URL.
    // Only return true if the URL can be handled by this Commissioner.
    virtual bool onJoinUrlQuery(const CallbackResult_JOIN_URL *result);
    // Called when the MeshCop finalizes the joining of a device.
    virtual void onJoinFinished(const CallbackResult_JOIN_FIN *result, char *vendorStackVersion, int vsvLength, char *vendorData, int vdLength);
    // Called when an error-response has been received from the network.
    virtual void onErrorResponse(int mcResult, int caResponseResult, char *token, int tokenLength);
    
    // Called when a MgmtParamsGet request has been issued and a successful response has been received.
    virtual void onMgmtParamReceivedInt(int mcMgmtParamID, int paramValue);
    virtual void onMgmtParamReceivedStr(int mcMgmtParamID, char* paramValue);
    virtual void onMgmtParamReceivedRaw(int mcMgmtParamID, char *paramValue, int paramLength);
    virtual void onMgmtParamReceivedObj(int mcMgmtParamID, MCMgmtSecurityPolicy_t *securityPolicy);
    
    // Called when one of the MgmtParamSetXXX request has been issued.
    virtual void onMgmtParamsSet(bool success, char *token, int tokenLength);
    
    // Called when MeshCop needs the data from the secure storage.
    // Must return a java.nio.ByteBuffer object holding the secure data.
    virtual void * getSecureStorage() = 0;
    // Called when the MeshCop needs to write the data to secure storage.
    // The 'storage' parameter, a java.nio.ByteBuffer, cannot be cached. It will become invalid immediately after this method returns.
    virtual void setSecureStorage(void * storage) = 0;
    
protected:
    CallbackBase() {}
};

#endif /* defined(__ThreadGroup__CallbackBase__) */
