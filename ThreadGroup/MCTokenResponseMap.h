#ifndef MC_TOKEN_RESPONSE_MAP_H_
#define MC_TOKEN_RESPONSE_MAP_H_

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include "logger.h"
#include "oic_malloc.h"

#include "cacommon.h"
#include "cainterface.h"

#include "uthash.h"

#ifdef __cplusplus
extern "C"
{
#endif


typedef struct {
    char*          keyToken;
    uint8_t        tokenLength;
    void*          userData;
    UT_hash_handle hash;
} MCTokenResponseMap_t;

uint8_t tokenResponseMapInit();
void tokenResponseMapDestroy();

uint8_t putResponseData(MCTokenResponseMap_t **map, CAInfo_t* responseInfo, void* data);
void* findResponseData(MCTokenResponseMap_t **map, CAToken_t token, uint8_t tokenLength);
void* deleteResponseData(MCTokenResponseMap_t **map, CAToken_t token, uint8_t tokenLength);
void deleteAllResponseData(MCTokenResponseMap_t **map);


#ifdef __cplusplus
} /* extern "C" */
#endif

#endif // MC_TOKEN_RESPONSE_MAP_H_
