#include <stdlib.h>
#include "pch.h"
#include "ANXOpenSSLRSA.h"
#include "ANXOpenSSL.h"
#include "ANXOpenSSLConversionRoutines.h"
#include "ANXOpenSSLDefer.h"
#include "ANXOpenSSLUtils.h"

FREObject ANXOpenSSLRSA::rsaEncryptWithPublicKey(FREObject data, FREObject key)
{
    _OutputDebugString(L"[ANX] Attempt to read publicKey");

    const unsigned char* publicKey;
    uint32_t publicKeyLength;

    if (FREGetObjectAsUTF8(key, &publicKeyLength, &publicKey) != FRE_OK) {
        return NULL;
    }

    _OutputDebugString(L"[ANX] Attempt to acquire input byte array");

    FREByteArray input;
    if (FREAcquireByteArray(data, &input) != FRE_OK) {
        return NULL;
    }

    _OutputDebugString(L"[ANX] Attempt to encrypt data");

    int length;

    unsigned char* encrypted = ANXOpenSSL::getInstance().rsaEncryptBytesWithPublicKey(input.bytes, publicKey, &length);

    defer {
        _OutputDebugString(L"[ANX] Freeing encrypted bytes.");
        free(encrypted);
    };

    _OutputDebugString(L"[ANX] data encrypted with length: %i", length);

    _OutputDebugString(L"[ANX] Attempt to release input byte array");

    if (FREReleaseByteArray(data) != FRE_OK) {
        return NULL;
    }

    if (length == -1) {
        _OutputDebugString(L"[ANX] decryption failed with error: %s", anx_retrieve_openssl_error_queue());
        return NULL;
    }

    _OutputDebugString(L"[ANX] Attempt to create output byte array");

    FREObject result = ANXOpenSSLConversionRoutines::createByteArrayWithLength(length);
    if (result == NULL) {
        return NULL;
    }

    _OutputDebugString(L"[ANX] Attempt to acquire output byte array");

    FREByteArray output;
    if (FREAcquireByteArray(result, &output) != FRE_OK) {
        return NULL;
    }

    _OutputDebugString(L"[ANX] Attempt to copy encrypted data into output byte array");

    memcpy(output.bytes, encrypted, length);

    _OutputDebugString(L"[ANX] attempt to release output byte array");

    if (FREReleaseByteArray(result) != FRE_OK) {
        return NULL;
    }

    _OutputDebugString(L"[ANX] all operations are done");

    return result;
}

FREObject ANXOpenSSLRSA::rsaDecryptWithPrivateKey(FREObject data, FREObject key)
{
    _OutputDebugString(L"[ANX] Attempt to read privateKey");

    const unsigned char* privateKey;
    uint32_t keyLength;

    if (FREGetObjectAsUTF8(key, &keyLength, &privateKey) != FRE_OK) {
        return NULL;
    }

    _OutputDebugString(L"[ANX] Attempt to acquire input byte array");

    FREByteArray input;
    if (FREAcquireByteArray(data, &input) != FRE_OK) {
        return NULL;
    }

    _OutputDebugString(L"[ANX] Attempt to decrypt data");

    int length;

    unsigned char* decrypted = ANXOpenSSL::getInstance().rsaDecryptBytesWithPrivateKey(input.bytes, privateKey, &length);

    defer {
        _OutputDebugString(L"[ANX] Freeing decrypted bytes.");
        free(decrypted);
    };

    _OutputDebugString(L"[ANX] data decrypted with length: %i", length);

    _OutputDebugString(L"[ANX] Attempt to release input byte array");

    if (FREReleaseByteArray(data) != FRE_OK) {
        return NULL;
    }

    if (length == -1) {
        _OutputDebugString(L"[ANX] decryption failed with error: %s", anx_retrieve_openssl_error_queue());
        return NULL;
    }

    _OutputDebugString(L"[ANX] Attempt to create output byte array");

    FREObject result = ANXOpenSSLConversionRoutines::createByteArrayWithLength(length);
    if (result == NULL) {
        return NULL;
    }

    _OutputDebugString(L"[ANX] Attempt to acquire output byte array");

    FREByteArray output;
    if (FREAcquireByteArray(result, &output) != FRE_OK) {
        return NULL;
    }

    _OutputDebugString(L"[ANX] Attempt to copy encrypted data into output byte array");

    memcpy(output.bytes, decrypted, length);

    _OutputDebugString(L"[ANX] attempt to release output byte array");

    if (FREReleaseByteArray(result) != FRE_OK) {
        return NULL;
    }

    _OutputDebugString(L"[ANX] all operations are done");

    return result;
}

FREObject ANXOpenSSLRSA::verifyCertificate(FREObject certificateObject, FREObject caCertificateObject)
{
    _OutputDebugString(L"Attempt to read certificate");

    const unsigned char* certificate;
    uint32_t certificateLength;
    if (FREGetObjectAsUTF8(certificateObject, &certificateLength, &certificate) != FRE_OK) {
        return NULL;
    }

    _OutputDebugString(L"Attempt to read certificate from Certificate Authority");

    const unsigned char* caCertificate;
    uint32_t caCertificateLength;
    if (FREGetObjectAsUTF8(caCertificateObject, &caCertificateLength, &caCertificate) != FRE_OK) {
        return NULL;
    }

    _OutputDebugString(L"Attempt to verify certificate");

    BOOL result = ANXOpenSSL::getInstance().verifyCertificate((const char*)certificate, (const char*)caCertificate);

    return ANXOpenSSLConversionRoutines::convertBoolToFREObject(result);
};
