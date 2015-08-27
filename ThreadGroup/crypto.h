#ifndef _CRYPTO_H_
#define _CRYPTO_H_

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C"
{
#endif

// Block size of AES-128 (16 bytes).
#define AES_BLOCK_SIZE 16
#define PSK_C_LEN 16

// Implementation according to http://tools.ietf.org/html/rfc4493
void aes_cmac(const uint8_t *key,
              const uint8_t *message, const size_t messageLen,
              uint8_t *out);

// Implementation according to http://tools.ietf.org/html/rfc4615
void aes_cmac_prf_128(const uint8_t *key, const size_t keyLen,
                      const uint8_t *message, const size_t messageLen,
                      uint8_t *out);

typedef void (*f_PRF)(const uint8_t *key, size_t keyLen,
                      const uint8_t *message, size_t messageLen,
                      uint8_t *out);

// Implementation according to http://tools.ietf.org/html/rfc2898#section-5.2
// The prf parameter is the pseudo-random-funciton being used to do the actual encryption.
void pbkdf2(f_PRF prf, size_t prfBlockLen,
            const uint8_t *password, size_t passwordLen,
            const uint8_t *salt, size_t saltLen,
            uint32_t iterationCount,
            uint8_t *derivedKeyOut, size_t derivedKeyLen);

// Given the pass-phrase and the network name a derived/stretched key will be returned in derivedKeyOut.
// The derivedKeyOut must at least hold PSK_C_LEN bytes.
void getPSKc(const char *passPhrase, const char* networkName, uint8_t *derivedKeyOut);

// Stores the KEK generated from the given keyblock into kekOut.
// Be sure that the kekOut is an array of at least 16 bytes.
void calcJoinerKEK(const uint8_t* const keyblock, uint8_t* const kekOut);

#ifndef NDEBUG
int crypto_test();
#endif


#ifdef __cplusplus
} // extern "C"
#endif

#endif // _CRYPTO_H_
