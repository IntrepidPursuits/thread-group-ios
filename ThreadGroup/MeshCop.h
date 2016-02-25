#ifndef MESH_COP_H_
#define MESH_COP_H_

#include "cacommon.h"

#include "MCSecStorage.h"

#ifdef __cplusplus
extern "C"
{
#endif


// Possible values for TLV_STATE
typedef enum {
    REJECT = -1,
    PENDING = 0,
    ACCEPT = 1
} MCState_t;

// TLV Type definitions.
#define TLV_COMMISSIONER_ID 10
#define TLV_COMMISSIONER_SESSION_ID 11
#define TLV_STATE 16
#define TLV_GET 13
#define TLV_JOINER_DTLS_ENCAP 17
#define TLV_JOINER_UDP_PORT 18
#define TLV_JOINER_IID 19
#define TLV_JOINER_ROUTER_LOC 20
#define TLV_JOINER_ROUTER_KEK 21
#define TLV_PROVISIONING_URL 32
#define TLV_VENDOR_NAME 33
#define TLV_VENDOR_MODEL 34
#define TLV_VENDOR_SOFT_VERSION 35
#define TLV_VENDOR_DATA 36
#define TLV_VENDOR_STACK_VERSION 37
    
#ifndef __WITH_DTLS__
#define __WITH_DTLS__ __APPLE__
#endif
    
typedef union {
    int8_t  byteVal;
    int16_t shortVal;
    int32_t intVal;
    char*   rawVal;
    uint64_t undefined;
} MC_Value;

typedef uint8_t (*f_isRaw)(uint8_t type);

typedef struct {
    uint8_t  type;
    uint16_t length;
    MC_Value value;
    f_isRaw  fIsRaw;
} MCTLV_t;

typedef enum {
    MC_OK = 0,
    MC_ADAPTER_NOT_ENABLED,
    MC_COMMUNICATION_ERROR,
    MC_TIMEOUT,
    MC_ERROR
} MCResult_t;

// Enumeration of the IDs fo all the MGMT_GET/SET parameters.
typedef enum {
    MGMT_CHANNEL = 0,
    MGMT_PAN = 1,
    MGMT_XPANID = 2,
    MGMT_NETWORK_NAME = 3,
    MGMT_COMMISSIONER_CREDENTIAL = 4,
    MGMT_NETWORK_MASTER_KEY = 5,
    MGMT_NETWORK_KEY_SEQ = 6,
    MGMT_NETWORK_ULA = 7,
    MGMT_STEERING = 8,
    MGMT_BORDER_ROUTER_LOC = 9,
    MGMT_COMMISSIONER_ID = 10,
    MGMT_COMMISSIONER_SESSION_ID = 11,
    MGMT_SECURITY_POLICY = 12,
    MGMT_COMMISSIONER_PORT = 15
} MCMgmtParamID_t;

static inline uint8_t _isRawMgmtParam(uint8_t mcMgmtParamID) {
    switch (mcMgmtParamID) {
    case MGMT_CHANNEL:
    case MGMT_PAN:
    case MGMT_BORDER_ROUTER_LOC:
    case MGMT_COMMISSIONER_SESSION_ID:
    case MGMT_COMMISSIONER_PORT:
    case MGMT_NETWORK_KEY_SEQ:
    case MGMT_STEERING:
        return false;
    default:
        return true;
    }
}

typedef MCTLV_t MCMgmtParam_t;

typedef struct {
    bool     isOutOfBandRestricted : 1;
    bool     isNativeRestricted : 1;
    int      reserved : 6;
    short    rotationTime;
} MCMgmtSecurityPolicy_t;

// Initialize the MeshCop (MC) module. This should be called on loading and only once.
CAResult_t MCInitialize();
// Destroy the MC module. This should only be done on app-exit (unloading).
void MCDestroy();

// App starts using the MC module (again) (e.g. when app goes to foreground).
CAResult_t MCStart();
// App stops using the MC module (not interested (for a while)) (e.g. when app goes to background).
void MCStop();

// Change the target host (ip-address) and/or network type for subsequent request.
CAResult_t MCChangeHost(uint8_t isSecure, const char *hostAddress, uint16_t commissionerPort, uint8_t networkType, const char *networkName);

#ifdef __WITH_DTLS__
// Set the credentials for the app (this device).
CAResult_t MCSetCredentials(const char *identity, const char *client_psk);
// Set the passphrase used in conjunction with the J-PAKE cypher suite.
void MCSetPassphrase(const char *utf8Passphrase);
#endif

// Adds the credentials of some Joiner. The first Joiner that tries join will be checked against this credential.
void MCAddAnyJoinerCredentials(const char *joinerCreds);
// Adds the credentials of the given Joiner. The joinerIID is either 3 (short form) or 8 (long form) bytes.
// When using the short form, pad the last 5 bytes with '\0' chars.
void MCAddJoinerCredentials(const char *joinerIID, const char *joinerCreds);
// Sends the Steering data to the Border Router with all Joiners added through the functions above that
// have not yet joined the network.
CAToken_t MCSendJoinersSteeringData(uint8_t useShortForm);

// Sends a COMM_PET request. Returns a token upon success.
CAToken_t COMM_PET_request(const char* commissionerId);
// Sends a MGMT_GET request. Returns a token upon success.
CAToken_t MGMT_GET_request(const uint8_t tlvTypes[], const uint8_t numTypes, uint8_t peekOnly);
// Sends a MGMT_SET request. Returns a token upon success.
CAToken_t MGMT_SET(const int mcMgmtParamID, ...);
CAToken_t MGMT_SET_request(const MCMgmtParam_t* const *tlvs, const uint8_t numTlvs);


// Define callbacks to client.
typedef enum {
    // Commissioner petition success, failure or abandonment.
    // Takes three parameters: char* other_commissioner_id, uint16 commissioner_session, uint8_t authorizationFailed
    COMM_PET = 1,

    // Checks the client (commissioner) whether it can handle the given joiner's provisioning url
    // Takes one parameter: UTF8 string representing the provisioning url.
    // Client should return true (non 0 value) to accept this URL or false/0 for rejecting it.
    JOIN_URL,

    // Tells the client that a joiner has been accepted or rejected.
    // Takes 10 parameters:
    //      uint8_t[8] joinerIID, MCState_t state,
    //      char* utf8ProvisioningUrl,
    //      char* utf8VendorName, char* utf8VendorModel, char* utf8VendorSoftwareVersion,
    //      uint8_t* vendorStackVersion, int vsvLength, uint8_t* vendorData, int vdLength
    JOIN_FIN,

    // Tells the client that a Network Management Parameter GET-request returned a result.
    // Takes at least 2 params:
    //      int paramID ID of the parameter.
    //      ... values  1 or 2 values representing the value of the parameter.
    // See MgmtSetGet.c, function notifyClientParam for more info.
    MGMT_PARAM_GET,

    // Tells the client if a Network Management Parameter SET-request returned a result.
    // Takes 3 params:
    //      uint8_t success Set to a non-0 value if the SET-request was successful.
    //      char *token, uint8_t tokenLength.
    MGMT_PARAM_SET,

    // Tells the client that an unhandled error-response was received from the Border Router
    // Takes four parameters: MCResult_t mcResult, CAResponseResult_t caResult, char* token, uint8_t tokenLength
    ERROR_RESPONSE
} MCCallback_t;

typedef void* (*f_MCCallback)(const MCCallback_t callbackId, ...);

// Sets the client's callback function.
void MCSetCallback(f_MCCallback callback);

// _memset function clears out memory safely (shouldn't be optimized away).
extern void (* const volatile _memset)(void *, int, size_t);

#ifndef NDEBUG
void MCTest();
#endif


#ifdef __cplusplus
} /* extern "C" */
#endif

#endif /* MESH_COP_H_ */
