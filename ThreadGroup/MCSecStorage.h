#ifndef MC_SEC_STORAGE_H_
#define MC_SEC_STORAGE_H_

#include <stdlib.h>

#ifdef __cplusplus
extern "C"
{
#endif


struct MCSecStorage;
typedef struct MCSecStorage MCSecStorage_t;

// Definition of internal/static function that reads and create secure storage from a given buffer.
// The function of type f_GetStorageDataCallback must call that at some point.
typedef const MCSecStorage_t* (*f_readStorageFromData)(const uint8_t * const data, const uint32_t dataLen);

// The type of the function that a client must implement to retrieve a byte array from persisted and secure storage.
// The contents of the byte array then must be provided to the fReadStorageFromData function.
typedef const MCSecStorage_t* (*f_GetStorageDataCallback)(f_readStorageFromData fReadStorageFromData);

// The type of the function that a client must implement to save a byte array to persisted and secure storage.
typedef void (*f_SetStorageDataCallback)(const uint8_t * const data, uint32_t const dataLen);

// Tells MeshCop which two function the client has implemented for reading and retrieving data from/to secure storage.
void setStorageDataCallback(const f_GetStorageDataCallback getData, const f_SetStorageDataCallback setData);


#ifdef __cplusplus
} //extern "C"
#endif

#endif // MC_SEC_STORAGE_H_
