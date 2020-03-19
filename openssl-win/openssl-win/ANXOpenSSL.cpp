#include "pch.h"
#include "ANXOpenSSL.h"

#pragma region Common

const char* ANXOpenSSL::version()
{
	return OPENSSL_VERSION_TEXT;
}

#pragma endregion

#pragma region RSA

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

BOOL ANXOpenSSL::verifyCertificate(const char* certificate, const char* caCertificate)
{

    BIO* b = BIO_new(BIO_s_mem());
    BIO_puts(b, caCertificate);
    X509* issuer = PEM_read_bio_X509(b, NULL, NULL, NULL);
    EVP_PKEY* signing_key = X509_get_pubkey(issuer);

    BIO* c = BIO_new(BIO_s_mem());
    BIO_puts(c, certificate);
    X509* x509 = PEM_read_bio_X509(c, NULL, NULL, NULL);

    int result = X509_verify(x509, signing_key);

    EVP_PKEY_free(signing_key);
    BIO_free(b);
    BIO_free(c);
    X509_free(x509);
    X509_free(issuer);

    return result > 0;
}

#pragma endregion

#pragma region AES

/// AES implementation based on https://wiki.openssl.org/index.php/EVP_Symmetric_Encryption_and_Decryption

unsigned char* ANXOpenSSL::aesEncryptBytes(const unsigned char* input, uint32_t inputLength, const unsigned char* key, const unsigned char* iv, uint32_t* outLength) {

    unsigned char ciphertext[inputLength + EVP_CIPHER_block_size(EVP_aes_256_cbc())];

    EVP_CIPHER_CTX *ctx = EVP_CIPHER_CTX_new();
    if (!ctx) {
        _OutputDebugString(L"[ANX] ERROR: aesEncryptBytes: %s", ERR_error_string(ERR_get_error(), NULL));
        return nullptr;
    }

    if (EVP_EncryptInit_ex(ctx, EVP_aes_256_cbc(), NULL, key, iv) != 1) {
        _OutputDebugString(L"[ANX] ERROR: aesEncryptBytes: %s", ERR_error_string(ERR_get_error(), NULL));
        return nullptr;
    }

    int len;
    if (EVP_EncryptUpdate(ctx, ciphertext, &len, input, inputLength) != 1) {
        _OutputDebugString(L"[ANX] ERROR: aesEncryptBytes: %s", ERR_error_string(ERR_get_error(), NULL));
        return nullptr;
    }

    int ciphertext_len = len;

    if (EVP_EncryptFinal_ex(ctx, ciphertext + len, &len) != 1) {
        _OutputDebugString(L"[ANX] ERROR: aesEncryptBytes: %s", ERR_error_string(ERR_get_error(), NULL));
        return nullptr;
    }

    ciphertext_len += len;

    EVP_CIPHER_CTX_free(ctx);

    *outLength = ciphertext_len;

    unsigned char* returnValue = (unsigned char*)malloc(ciphertext_len);
    memcpy(returnValue, ciphertext, ciphertext_len);

    return returnValue;
}

unsigned char* ANXOpenSSL::aesDecryptBytes(const unsigned char* input, uint32_t inputLength, const unsigned char* key, const unsigned char* iv, uint32_t* outLength) {

    unsigned char plaintext[inputLength + EVP_CIPHER_block_size(EVP_aes_256_cbc()) + 1];

    EVP_CIPHER_CTX *ctx = EVP_CIPHER_CTX_new();
    if (!ctx) {
        _OutputDebugString(L"[ANX] ERROR: aesDecryptBytes: %s", ERR_error_string(ERR_get_error(), NULL));
        return nullptr;
    }

    if (EVP_DecryptInit_ex(ctx, EVP_aes_256_cbc(), NULL, key, iv) != 1) {
        _OutputDebugString(L"[ANX] ERROR: aesDecryptBytes: %s", ERR_error_string(ERR_get_error(), NULL));
        return nullptr;
    }

    int len;
    if (EVP_DecryptUpdate(ctx, plaintext, &len, input, inputLength) != 1) {
        _OutputDebugString(L"[ANX] ERROR: aesDecryptBytes: %s", ERR_error_string(ERR_get_error(), NULL));
        return nullptr;
    }

    int plaintext_len = len;

    if (EVP_DecryptFinal_ex(ctx, plaintext + len, &len) != 1) {
        _OutputDebugString(L"[ANX] ERROR: aesDecryptBytes: %s", ERR_error_string(ERR_get_error(), NULL));
        return nullptr;
    }

    plaintext_len += len;

    EVP_CIPHER_CTX_free(ctx);

    *outLength = plaintext_len;

    unsigned char* returnValue = (unsigned char*)malloc(plaintext_len);
    memcpy(returnValue, plaintext, plaintext_len);

    return returnValue;
}

#pragma endregion

#pragma region SHA

unsigned char* ANXOpenSSL::sha256FromBytes(const unsigned char* input, uint32_t inputLength, uint32_t* outputLength) {
    unsigned char md_value[SHA256_DIGEST_LENGTH];
    unsigned int md_len;

    const EVP_MD* md = EVP_sha256();

    EVP_MD_CTX* ctx = EVP_MD_CTX_create();
    EVP_DigestInit_ex(ctx, md, NULL);
    EVP_DigestUpdate(ctx, input, inputLength);
    EVP_DigestFinal_ex(ctx, md_value, &md_len);
    EVP_MD_CTX_destroy(ctx);

    *outputLength = md_len * 2;

    char* buffer = (char *)malloc(sizeof(char) * (*outputLength) + 1);
    if (!buffer) {
        return NULL;
    }

    int offset = 0;
    for (int i = 0; i < md_len; i++) {
#ifdef __APPLE__
        int count = sprintf(buffer + offset, "%02x", md_value[i]);
#elif defined(_WIN32) || defined(_WIN64)
        int count = sprintf_s(buffer + offset, SHA256_DIGEST_LENGTH * 2, "%02x", md_value[i]);
#endif
        if (count == -1) {
            _OutputDebugString(L"[ANX] EOF received, return NULL");
            free(buffer);
            return NULL;
        }
        offset += count;
    }

    buffer[*outputLength] = '\0';

    return (unsigned char*)buffer;
}

unsigned char* ANXOpenSSL::sha256FromString(const unsigned char* string) {

    unsigned char md_value[SHA256_DIGEST_LENGTH];
    unsigned int md_len;

    const EVP_MD *md = EVP_sha256();

    EVP_MD_CTX* ctx = EVP_MD_CTX_create();
    EVP_DigestInit_ex(ctx, md, NULL);
    EVP_DigestUpdate(ctx, string, strlen((char*)string));
    EVP_DigestFinal_ex(ctx, md_value, &md_len);
    EVP_MD_CTX_cleanup(ctx);

    char* buffer = (char*)malloc(sizeof(unsigned char*) * SHA256_DIGEST_LENGTH * 2);

    unsigned int i, j;
    for (i = 0, j = 0; i < md_len; i++, j+=2) {
#ifdef __APPLE__
        int count = sprintf(buffer + j, "%02x", md_value[i]);
#endif
#if defined(_WIN32) || defined(_WIN64)
        int count = sprintf_s(buffer + j, SHA256_DIGEST_LENGTH * 2, "%02x", md_value[i]);
#endif
        if (count == -1) {
            _OutputDebugString(L"[ANX] EOF received, return NULL");
            free(buffer);
            return NULL;
        }
    }

    return (unsigned char*)buffer;
}

#pragma endregion

#pragma region HMAC

unsigned char* ANXOpenSSL::hmacFromBytes(const unsigned char *bytes, int bytesLength, const void *key, int keyLength) {
    return HMAC(EVP_sha1(), key, keyLength, bytes, bytesLength, NULL, NULL);
}

#pragma endregion

#pragma region HEX

unsigned char* ANXOpenSSL::hexEncodeString(const unsigned char* input, uint32_t inputLength, uint32_t* outputLength) {
    _OutputDebugString(L"[ANX] input with length: %i", inputLength);

    BIGNUM* bn = BN_bin2bn(input, inputLength, NULL);

    char* output = BN_bn2hex(bn);

    *outputLength = (uint32_t)strlen(output);

    BN_free(bn);

    return (unsigned char*)output;
}

unsigned char* ANXOpenSSL::hexDecodeString(const unsigned char* input, uint32_t inputLength, uint32_t* outputLength) {
    _OutputDebugString(L"[ANX] input: %s", input);

    if (inputLength % 2 != 0) {
        _OutputDebugString(L"[ANX] input has odd length, return NULL");
        return NULL;
    }

    BIGNUM* bn = BN_new();

    int input_length = BN_hex2bn(&bn, (const char*)input);
    if (input_length == 0) {
        return NULL;
    }

    unsigned int numOfBytes = BN_num_bytes(bn);

    unsigned char* output = (unsigned char*)OPENSSL_malloc(numOfBytes);

    *outputLength = BN_bn2bin(bn, output);

    BN_free(bn);

    return output;
}

#pragma endregion
