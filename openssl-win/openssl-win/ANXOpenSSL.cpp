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

unsigned char* ANXOpenSSL::aesEncryptBytes(const unsigned char* input, const unsigned char* key, const unsigned char* iv, int* outLength) {

    int inputLength = (int)strlen((char*)input);

    EVP_CIPHER_CTX *ctx;

    int len;

    int ciphertext_len;

    unsigned char ciphertext[128];

    /* Create and initialise the context */
    if (!(ctx = EVP_CIPHER_CTX_new())) {
        _OutputDebugString(L"[ANX] ERROR: aesEncryptBytes: %s", ERR_error_string(ERR_get_error(), NULL));
    }

    /*
     * Initialise the encryption operation. IMPORTANT - ensure you use a key
     * and IV size appropriate for your cipher
     * In this example we are using 256 bit AES (i.e. a 256 bit key). The
     * IV size for *most* modes is the same as the block size. For AES this
     * is 128 bits
     */
    if (EVP_EncryptInit_ex(ctx, EVP_aes_256_cbc(), NULL, key, iv) != 1) {
        _OutputDebugString(L"[ANX] ERROR: aesEncryptBytes: %s", ERR_error_string(ERR_get_error(), NULL));
    }

    /*
     * Provide the message to be encrypted, and obtain the encrypted output.
     * EVP_EncryptUpdate can be called multiple times if necessary
     */
    if (EVP_EncryptUpdate(ctx, ciphertext, &len, input, inputLength) != 1) {
        _OutputDebugString(L"[ANX] ERROR: aesEncryptBytes: %s", ERR_error_string(ERR_get_error(), NULL));
    }

    ciphertext_len = len;

    /*
     * Finalise the encryption. Further ciphertext bytes may be written at
     * this stage.
     */
    if (EVP_EncryptFinal_ex(ctx, ciphertext + len, &len) != 1) {
        _OutputDebugString(L"[ANX] ERROR: aesEncryptBytes: %s", ERR_error_string(ERR_get_error(), NULL));
    }

    ciphertext_len += len;

    /* Clean up */
    EVP_CIPHER_CTX_free(ctx);

    *outLength = ciphertext_len;

    unsigned char* returnValue = (unsigned char*)malloc(ciphertext_len);
    if (returnValue) {
        memcpy(returnValue, ciphertext, ciphertext_len);
    }

    return returnValue;
}

unsigned char* ANXOpenSSL::aesDecryptBytes(const unsigned char* input, const unsigned char* key, const unsigned char* iv, int* outLength) {

    int inputLength = (int)strlen((char*)input);

    EVP_CIPHER_CTX *ctx;

    int len;

    int plaintext_len;

    unsigned char plaintext[128];

    /* Create and initialise the context */
    if (!(ctx = EVP_CIPHER_CTX_new())) {
        _OutputDebugString(L"[ANX] ERROR: aesDecryptBytes: %s", ERR_error_string(ERR_get_error(), NULL));
    }

    /*
     * Initialise the decryption operation. IMPORTANT - ensure you use a key
     * and IV size appropriate for your cipher
     * In this example we are using 256 bit AES (i.e. a 256 bit key). The
     * IV size for *most* modes is the same as the block size. For AES this
     * is 128 bits
     */
    if (EVP_DecryptInit_ex(ctx, EVP_aes_256_cbc(), NULL, key, iv) != 1) {
        _OutputDebugString(L"[ANX] ERROR: aesDecryptBytes: %s", ERR_error_string(ERR_get_error(), NULL));
    }

    /*
     * Provide the message to be decrypted, and obtain the plaintext output.
     * EVP_DecryptUpdate can be called multiple times if necessary.
     */
    if (EVP_DecryptUpdate(ctx, plaintext, &len, input, inputLength) != 1) {
        _OutputDebugString(L"[ANX] ERROR: aesDecryptBytes: %s", ERR_error_string(ERR_get_error(), NULL));
    }

    plaintext_len = len;

    /*
     * Finalise the decryption. Further plaintext bytes may be written at
     * this stage.
     */
    if (EVP_DecryptFinal_ex(ctx, plaintext + len, &len) != 1) {
        _OutputDebugString(L"[ANX] ERROR: aesDecryptBytes: %s", ERR_error_string(ERR_get_error(), NULL));
    }

    plaintext_len += len;

    /* Clean up */
    EVP_CIPHER_CTX_free(ctx);

    *outLength = plaintext_len;

    unsigned char* returnValue = (unsigned char*)malloc(plaintext_len);
    if (returnValue) {
        memcpy(returnValue, plaintext, plaintext_len);
    }

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

    int offset = 0;
    for (int i = 0; i < md_len; i++) {
#ifdef __APPLE__
        int count = sprintf(buffer + offset, "%02x", md_value[i]);
#elif defined(_WIN32) || defined(_WIN64)
        int count = sprintf_s(buffer + offset, SHA256_DIGEST_LENGTH * 2, "%02x", md_value[i]);
#endif
        if (count == -1) {
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
        sprintf(buffer + j, "%02x", md_value[i]);
#endif
#if defined(_WIN32) || defined(_WIN64)
        sprintf_s(buffer + j, SHA256_DIGEST_LENGTH * 2, "%02x", md_value[i]);
#endif
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
    _OutputDebugString(L"[ANX] input: %s with length: %i", input, inputLength);

    *outputLength = inputLength * 2;

    char* buffer = (char*)malloc(sizeof(char) * (*outputLength) + 1);

    int offset = 0;
    for (int i = 0; i < inputLength; i++) {
#ifdef __APPLE__
        int count = sprintf(buffer + offset, "%02x", input[i]);
#elif defined(_WIN32) || defined(_WIN64)
        int count = sprintf_s(buffer + offset, *outputLength, "%02x", input[i]);
#endif
        if (count == -1) {
            return NULL;
        }
        offset += count;
    }

    buffer[*outputLength] = '\0';

    _OutputDebugString(L"[ANX] output: %s with length: %i", buffer, *outputLength);

    return (unsigned char*)buffer;
}

unsigned char* ANXOpenSSL::hexDecodeString(const unsigned char* input, uint32_t inputLength, uint32_t* outputLength) {
    _OutputDebugString(L"[ANX] input: %s", input);

    if (inputLength % 2 != 0) {
        _OutputDebugString(L"[ANX] input has odd length, return NULL");
        return NULL;
    }

    char* string = (char*)input;

    *outputLength = inputLength / 2;
    char* output = (char*)malloc(sizeof(char) * (*outputLength));

    for (int i = 0; i < *outputLength; i++) {
#ifdef __APPLE__
        int result = sscanf(string, "%2hhx", &output[i]);
#elif defined(_WIN32) || defined(_WIN64)
        int result = sscanf_s(string, "%2hhx", &output[i]);
#endif
        if (result == -1) {
            _OutputDebugString(L"[ANX] OF received");
            return NULL;
        }
        string += 2;
    }

    return (unsigned char*)output;
}

#pragma endregion
