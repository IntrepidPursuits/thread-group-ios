#ifndef RLY_SERVER_H_
#define RLY_SERVER_H_

#include <netinet/in.h>
#include <errno.h>

#include "cacommon.h"
#include "MCCommon.h"

#ifdef __cplusplus
extern "C"
{
#endif

#define MAX_ENCAP_PAYLOAD_SIZE 65535

static const uint8_t EMPTY_KEK[JOINER_KEK_LEN] = { 0 };

typedef uint8_t (*f_RlyCallback)(const char* buffer, const uint16_t bufferLen, const uint8_t kek[JOINER_KEK_LEN], const void* requestPayload);

uint8_t rly_dtls_init(f_RlyCallback callback);
uint8_t rly_handleRxData(const CAEndpoint_t *forEndPoint, uint8_t joinerIID[JOINER_IID_LEN], uint16_t joinerPort, uint8_t *joinerEncap, uint16_t joinerEncapLength, const void* payload);
uint8_t rly_getInfo(const uint16_t clientPort, char joinerIIDOut[JOINER_IID_LEN], uint8_t addKEK);

#ifdef __cplusplus
} // extern C
#endif

#endif // RLY_SERVER_H_