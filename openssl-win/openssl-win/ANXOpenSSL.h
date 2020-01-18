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

private:
    ANXOpenSSL() {
        OpenSSL_add_all_algorithms();
        OpenSSL_add_all_ciphers();
        OpenSSL_add_all_digests();
    }

public:
    const char* version();

public:

    unsigned char* rsaEncryptBytesWithPublicKey(const unsigned char* input, const unsigned char* key, int* outLength);
    unsigned char* rsaDecryptBytesWithPrivateKey(const unsigned char* input, const unsigned char* key, int* outLength);

    BOOL verifyCertificate(const char* certificate, const char* caCertificate);

public:
    unsigned char* aesEncryptBytes(const unsigned char* input, const unsigned char* key, const unsigned char* iv, int* outLength);
    unsigned char* aesDecryptBytes(const unsigned char* input, const unsigned char* key, const unsigned char* iv, int* outLength);

};

