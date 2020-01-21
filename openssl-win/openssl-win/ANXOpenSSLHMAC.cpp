//
//  ANXOpenSSLHMAC.cpp
//  openssl-win-debug
//
//  Created by Max Rozdobudko on 21.01.2020.
//

#include "ANXOpenSSLHMAC.h"
#include "ANXOpenSSL.h"
#include "ANXOpenSSLUtils.h"
#include "ANXOpenSSLConversionRoutines.h"

FREObject ANXOpenSSLHMAC::hmacCompute(FREObject data, FREObject hashFunction, FREObject keyParam) {

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

    _OutputDebugString(L"[ANX] Attempt to compute HMAC from '%s' with key '%s'", input.bytes, key.bytes);

    unsigned char* hmac = ANXOpenSSL::getInstance().hmacFromBytes(input.bytes, input.length, key.bytes, key.length);

    _OutputDebugString(L"[ANX] Attempt to convert bytes to HEX string.");

    uint32_t length = (uint32_t)strlen((char*)hmac);
    unsigned char* digest = ANXOpenSSL::getInstance().hexEncodeString(hmac, length, &length);

    _OutputDebugString(L"[ANX] Computed HMAC is '%s'", digest);

    _OutputDebugString(L"[ANX] Attempt to release input byte array");

    if (FREReleaseByteArray(data) != FRE_OK) {
        return NULL;
    }

    _OutputDebugString(L"[ANX] Attempt to release key byte array");

    if (FREReleaseByteArray(keyParam) != FRE_OK) {
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

    memcpy(output.bytes, digest, length);

    _OutputDebugString(L"[ANX] attempt to release output byte array");

    if (FREReleaseByteArray(result) != FRE_OK) {
        return NULL;
    }

    _OutputDebugString(L"[ANX] all operations are done");

    return result;
}
