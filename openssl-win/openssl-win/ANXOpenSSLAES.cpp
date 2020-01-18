#include <stdlib.h>
#include "pch.h"
#include "ANXOpenSSLAES.h"
#include "ANXOpenSSL.h"
#include "ANXOpenSSLConversionRoutines.h"
#include "ANXOpenSSLDefer.h"
#include "ANXOpenSSLUtils.h"

FREObject ANXOpenSSLAES::aesEncrypt(FREObject data, FREObject keyParam, FREObject ivParam) {

    _OutputDebugString(L"[ANX] Attempt to acquire input byte array");

    FREByteArray input;
    if (FREAcquireByteArray(data, &input) != FRE_OK) {
        return NULL;
    }

    _OutputDebugString(L"[ANX] Attempt to acquire key byte array");

    FREByteArray key;
    if (FREAcquireByteArray(keyParam, &key) != FRE_OK) {
        return NULL;
    }

    _OutputDebugString(L"[ANX] Attempt to acquire iv byte array");

    FREByteArray iv;
    if (FREAcquireByteArray(ivParam, &iv) != FRE_OK) {
        return NULL;
    }

    _OutputDebugString(L"[ANX] Attempt to encrypt data '%s' with key '%s' and with iv '%s'", input.bytes, key.bytes, iv.bytes);

    int length;
    unsigned char* encrypted =  ANXOpenSSL::getInstance().aesEncryptBytes(input.bytes, key.bytes, iv.bytes, &length);

    defer {
        free(encrypted);
    };

    _OutputDebugString(L"[ANX] data encrypted '%s' with length: %i", encrypted, length);

    _OutputDebugString(L"[ANX] Attempt to release input byte array");

    if (FREReleaseByteArray(data) != FRE_OK) {
        return NULL;
    }

    _OutputDebugString(L"[ANX] Attempt to release key byte array");

    if (FREReleaseByteArray(keyParam) != FRE_OK) {
        return NULL;
    }

    _OutputDebugString(L"[ANX] Attempt to release iv byte array");

    if (FREReleaseByteArray(ivParam) != FRE_OK) {
        return NULL;
    }

    // check if encryption fails

    if (length == -1) {
        _OutputDebugString(L"[ANX] decryption failed with error: %s", anx_retrieve_openssl_error_queue());
        return NULL;
    }

    _OutputDebugString(L"[ANX] Attempt to create output byte array");

    FREObject result = ANXOpenSSLConversionRoutines::createByteArrayWithLength((int32_t)length);
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

FREObject ANXOpenSSLAES::aesDecrypt(FREObject data, FREObject keyParam, FREObject ivParam) {

    _OutputDebugString(L"[ANX] Attempt to acquire input byte array");

    FREByteArray input;
    if (FREAcquireByteArray(data, &input) != FRE_OK) {
        return NULL;
    }

    _OutputDebugString(L"[ANX] Attempt to acquire key byte array");

    FREByteArray key;
    if (FREAcquireByteArray(keyParam, &key) != FRE_OK) {
        return NULL;
    }

    _OutputDebugString(L"[ANX] Attempt to acquire iv byte array");

    FREByteArray iv;
    if (FREAcquireByteArray(ivParam, &iv) != FRE_OK) {
        return NULL;
    }

    _OutputDebugString(L"[ANX] Attempt to decrypt data '%s' with key '%s' and with iv '%s'", input.bytes, key.bytes, iv.bytes);

    int length;
    unsigned char* decrypted = ANXOpenSSL::getInstance().aesDecryptBytes(input.bytes, key.bytes, iv.bytes, &length);

    defer {
        free(decrypted);
    };

    _OutputDebugString(L"[ANX] data decrypted '%s' with length: %i", decrypted, length);

    _OutputDebugString(L"[ANX] Attempt to release input byte array");

    if (FREReleaseByteArray(data) != FRE_OK) {
        return NULL;
    }

    _OutputDebugString(L"[ANX] Attempt to release key byte array");

    if (FREReleaseByteArray(keyParam) != FRE_OK) {
        return NULL;
    }

    _OutputDebugString(L"[ANX] Attempt to release iv byte array");

    if (FREReleaseByteArray(ivParam) != FRE_OK) {
        return NULL;
    }

    // check if decryption fails

    if (length == -1) {
        _OutputDebugString(L"[ANX] decryption failed with error: %s", anx_retrieve_openssl_error_queue());
        return NULL;
    }

    _OutputDebugString(L"[ANX] Attempt to create output byte array");

    FREObject result = ANXOpenSSLConversionRoutines::createByteArrayWithLength((int32_t)length);
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
