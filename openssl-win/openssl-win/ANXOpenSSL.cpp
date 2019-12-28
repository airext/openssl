#include "pch.h"
#include "ANXOpenSSL.h"
#include <version>

const char* ANXOpenSSL::version()
{
	return OPENSSL_VERSION_TEXT;
}

unsigned char* ANXOpenSSL::rsaEncryptBytesWithPublicKey(const unsigned char* input, const unsigned char* key, int* outLength)
{
    RSA* rsa = anx_create_rsa_with_public_key(key);

    int rsaSize = RSA_size(rsa);

    unsigned char* output = (unsigned char*)malloc(rsaSize);

    *outLength = RSA_public_encrypt((int)strlen((const char*)input), input, output, rsa, RSA_PKCS1_PADDING);

    if (*outLength == -1) {
        _OutputDebugString(L"[ANX] ERROR: RSA_public_encrypt: %s", ERR_error_string(ERR_get_error(), NULL));
    }

    RSA_free(rsa);

    return output;
}

unsigned char* ANXOpenSSL::rsaDecryptBytesWithPrivateKey(const unsigned char* input, const unsigned char* key, int* outLength)
{
    RSA* rsa = anx_create_rsa_with_private_key(key);

    int rsaSize = RSA_size(rsa);

    unsigned char* output = (unsigned char*)malloc(rsaSize);

    *outLength = RSA_private_decrypt(rsaSize, input, output, rsa, RSA_PKCS1_PADDING);

    if (*outLength == -1) {
        _OutputDebugString(L"[ANX] ERROR: RSA_private_decrypt: %s", ERR_error_string(ERR_get_error(), NULL));
    }

    RSA_free(rsa);

    return output;
}
