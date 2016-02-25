#ifndef _BLOOM_H_
#define _BLOOM_H_

#include <stdint.h>

#ifdef __cplusplus
extern "C"
{
#endif

struct MCBloom;
typedef struct MCBloom MCBloom_t;

// Create a new bloom filter with given
//      filter-size in bytes,
//      capacity, i.e. the number of expected entries.
//      and a list of hash-functions that each take a byte array (and the length of that array).
struct MCBloom* newBloom(uint8_t filterLenInBytes, uint8_t capacity, uint8_t numHashFuncs, ...);

// Add a new entry to the bloom filter.
void addToBloom(struct MCBloom *bloom, uint8_t *data, uint16_t length);

// See if the given data (entry) has been added to the bloom filter.
uint8_t isInBloom(struct MCBloom *bloom, uint8_t *data, uint16_t length);

// Gets the bit-array of the bloom-filter.
// Note that bit 0 of dataOut[0] upon return is reserved (reserved for the Steering Data's S bit).
void getBloomFilterBits(MCBloom_t *bloom, uint8_t *dataOut, uint8_t dataOutLength);

// Free bloom filter and associates storage.
void freeBloom(struct MCBloom *bloom);

#ifdef __cplusplus
}
#endif

#endif //_BLOOM_H_
