#include <openssl/opensslv.h>
#include <openssl/pem.h>
#include <openssl/ssl.h>
#include <openssl/rsa.h>
#include <openssl/evp.h>
#include <openssl/bio.h>
#include <openssl/err.h>
#include "ANXOpenSSLUtils.h"
#include "ANXOpenSSLUtils.h"

#pragma once
class ANXOpenSSL
{
public:
    static ANXOpenSSL& getInstance()
    {
        static ANXOpenSSL instance; // Guaranteed to be destroyed. Instantiated on first use.
        return instance;
    }

public:
    const char* version();

    unsigned char* rsaEncryptBytesWithPublicKey(const unsigned char* input, const unsigned char* key, int* outLength);

    unsigned char* rsaDecryptBytesWithPrivateKey(const unsigned char* input, const unsigned char* key, int* outLength);
};

