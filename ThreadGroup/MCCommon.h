#ifndef MC_COMMON_H_
#define MC_COMMON_H_

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include "logger.h"
#include "oic_malloc.h"

#include "cainterface.h"
#include "cacommon.h"
#include "uthash.h"
#include "MeshCop.h"

#ifdef __cplusplus
extern "C"
{
#endif

#define STRLEN(STR) ( (STR)? strlen(STR) : 0 )
#define STRCPY(STR) ( (STR)? strcpy(calloc(STRLEN(STR) + 1, sizeof(char)), STR) : NULL )

#define IS_RESULT_SUCCESS(R) (CA_SUCCESS <= (R) && (R) < CA_BAD_REQ)

#define NEW_TLV_COMMISSIONER_ID(ID) ( newTLV(TLV_COMMISSIONER_ID, STRLEN(ID), (MC_Value){ .rawVal = (char*)(ID)}, NULL) )
#define NEW_TLV_COMMISSIONER_SESSION_ID(ID) ( newTLV(TLV_COMMISSIONER_SESSION_ID, sizeof(uint16_t), (MC_Value){ .shortVal = (ID)}, NULL) )
#define NEW_TLV_STATE(STATE) ( newTLV(TLV_STATE, sizeof(uint8_t), (MC_Value){ .byteVal = (STATE)}, NULL) )
#define NEW_TLV_GET(LIST,LEN) ( newTLV(TLV_GET, LEN, (MC_Value){ .rawVal = (char*)(LIST)}, NULL) )
#define NEW_TLV_JOINER_ENCAP(ENCAP,LEN) ( newTLV(TLV_JOINER_DTLS_ENCAP, LEN, (MC_Value){ .rawVal = (char*)(ENCAP)}, NULL) )
#define NEW_TLV_JOINER_ROUTER_KEK(KEK) ( newTLV(TLV_JOINER_ROUTER_KEK, 16, (MC_Value){ .rawVal = (char*)(KEK)}, NULL) )

#define TLV_VALUE_LEN(TLVS,SIZE,TYPE) findTlv(TLVS,SIZE,TYPE)->length
#define GET_TLV_VALUE(TLVS,SIZE,TYPE) findTlv(TLVS,SIZE,TYPE)->value
#define IS_TLV_VALUE_UNDEFINED(VALUE) ((VALUE).undefined == 0xffffffffffffffffLL)
#define GET_TLV_TYPED_VALUE(VALUE,TYPE,DEF) IS_TLV_VALUE_UNDEFINED(VALUE)?(DEF):((VALUE).TYPE)
#define TLV_AS_STRING(NAME,TLVS,SIZE,TYPE) const MCTLV_t* __##TYPE=findTlv((TLVS),(SIZE),(TYPE)); char NAME[__##TYPE->length+1]; if(__##TYPE->length){memcpy(NAME,__##TYPE->value.rawVal,__##TYPE->length);} NAME[__##TYPE->length]=0;
#define TLV_AS_BUFFER(TLVS,SIZE,TYPE) GET_TLV_TYPED_VALUE(GET_TLV_VALUE(TLVS,SIZE,TYPE), rawVal, NULL), TLV_VALUE_LEN(TLVS,SIZE,TYPE)

static inline uint8_t _isRawType(uint8_t type) {
    switch (type) {
    case TLV_COMMISSIONER_ID:
    case TLV_GET:
    case TLV_JOINER_DTLS_ENCAP:
    case TLV_JOINER_IID:
    case TLV_JOINER_ROUTER_KEK:
    case TLV_PROVISIONING_URL:
    case TLV_VENDOR_NAME:
    case TLV_VENDOR_MODEL:
    case TLV_VENDOR_SOFT_VERSION:
    case TLV_VENDOR_DATA:
    case TLV_VENDOR_STACK_VERSION:
        return true;
    default:
        return false;
    }
}

#define COMM_PET_PATH "/c/cp"
#define COMM_KA_PATH  "/c/ca"
#define MGMT_GET_PATH "/c/mg"
#define MGMT_SET_PATH "/c/ms"
#define RLY_RX_PATH   "/c/rx"
#define RLY_TX_PATH   "/c/tx"
#define JOIN_FIN_PATH "/c/jf"

#define JOINER_IID_LEN 8
#define JOINER_IID_LEN_SHORT 3
#define JOINER_KEK_LEN 16
#define DTLS_KEYBLOCK_LEN 40


// Header info
extern const MCTLV_t NO_TLV;

MCTLV_t* newTLV(uint8_t type, uint16_t length, MC_Value mcValue, f_isRaw fIsRaw);
MCTLV_t* copyTLV(const MCTLV_t *tlv);
void destroyTLVs(const MCTLV_t *tlvs, uint8_t numTlvs);
void destroyTLVReferences(const MCTLV_t **tlvRefs, uint8_t numTlvs);

void determineTLVBufferLength(const MCTLV_t *tlv, uint32_t *bufferStart);
MCTLV_t* writeBufferToTLV(char* buffer, uint32_t *bufferStart, f_isRaw fIsRaw);
void writeTLVToBuffer(const MCTLV_t *tlv, char* buffer, uint32_t *bufferStart);
CAResult_t writeTLVsToRequestData(const MCTLV_t* const *tlvs, uint8_t numTlvs, CAInfo_t *requestData);

uint8_t getNumberOfTlvsInRequestData(const CAInfo_t *data);
void getTLVsFromRequestData(const CAInfo_t *data, const MCTLV_t **tlvsOut, f_isRaw fIsRaw);

void logTLV(LogLevel level, const char* tag, const MCTLV_t *tlv);
void logTLVs(LogLevel level, const char* tag, const MCTLV_t **tlvs, uint8_t numTlvs);

extern const uint16_t g_portCOAP;
extern const uint16_t g_portCOAPS;
extern uint16_t g_portMC;
extern uint16_t g_portMJ;
extern uint16_t g_portMM;

typedef uint8_t (*f_TokenResponseCallback)(const CAResponseResult_t result, const char *path, const CAInfo_t *responseInfo);
typedef void (*f_RequestCallback)(const CAEndpoint_t *remoteEndpoint, const CAMethod_t method, const char *path, const CAInfo_t *requestInfo);

CAResult_t prologue(uint16_t port, const char* path, CAEndpoint_t **endpointOut, CAInfo_t *requestDataInOut, f_TokenResponseCallback responseCallback);
CAToken_t epilogue(CAEndpoint_t *endpoint, CAInfo_t *requestData, uint8_t success);

char* MCGetNetworkName();
void  MCSetNetworkName(const char* const networkName);
void MCSetJoinerHasJoined(const char * const joinerIID, const char * const joinerCred);

uint8_t RlyRx_init();

// Sends a COMM_KA request. Returns a token upon success.
CAToken_t COMM_KA_request(MCState_t state, uint16_t commissionerSessionId);

// Request handlers
void RlyRx_request(const CAEndpoint_t *remoteEndpoint, const CAMethod_t method, const char *path, const CAInfo_t *requestInfo);
void JoinFin_request(const CAEndpoint_t *remoteEndpoint, const CAMethod_t method, const char *path, const CAInfo_t *requestInfo);

static inline const MCTLV_t* findTlv(const MCTLV_t* const *tlvs, const uint8_t numTlvs, uint8_t type) {
    uint8_t i;
    for (i = 0; i < numTlvs; i++) {
        if (tlvs[i]->type == type) {
            return tlvs[i];
        }
    }
    return &NO_TLV;
}

void initializeMgmtParameters();
void destroyMgmtParameters();

//extern uint16_t g_commissionerSessionId;
//extern char g_commissionerId[];

// Sets the (user specified) ID/name for the commissioner app.
// The authFailed is set to a non-0 value if authorization for this commissioner app failed.
void setCommissionerIdAndSessionId(char *commissionerId, int32_t sessionId, uint8_t authFailed);
// Sets the data to accept or reject the this app as the commissioner.
void mc_setKeepAliveData(MCState_t state, uint16_t commissionerSessionId);
// Let the commissioner code now that the Border Router has sent back some response for keeping the commissioner active/alive.
void mc_refreshKeepAlive();
// Returns the client callback function.
f_MCCallback mc_getCallback();

// Functions that deal with reading and writing data from/to secure storage.
void MCGetCommissionerCredentials(char ** const utf8CommCred);
char* MCGetJoinerCredentials(const char* const joinerIID);
void MCSetCommissionerCredentials(const char * const utf8CommCred);
void MCSetJoinerCredentials(const char * const joinerIID, const char * const joinerCred);
void MCGetJoinerSteeringData(uint8_t *filterOut, uint8_t *filterLengthInOut, uint8_t useShortForm);
void MCGetPSKc(const char* const networkName, uint8_t *keyOut);

#ifdef __cplusplus
} /* extern "C" */
#endif

#endif // MC_COMMON_H_