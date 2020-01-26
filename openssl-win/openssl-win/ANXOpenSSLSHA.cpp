//
//  ANXOpenSSLSHA.cpp
//  openssl-win-debug
//
//  Created by Max Rozdobudko on 19.01.2020.
//

#include "pch.h"
#include "ANXOpenSSLSHA.h"
#include "ANXOpenSSL.h"
#include "ANXOpenSSLUtils.h"
#include "ANXOpenSSLConversionRoutines.h"

FREObject ANXOpenSSLSHA::computeSHA256(FREObject bytes) {

    _OutputDebugString(L"[ANX] Attempt to acquire input byte array");

    FREByteArray input;
    if (FREAcquireByteArray(bytes, &input) != FRE_OK) {
        return NULL;
    }

    _OutputDebugString(L"[ANX] Attempt to compute SHA256 from %s", input.bytes);

    unsigned char* sha = ANXOpenSSL::getInstance().sha256FromString(input.bytes);

    uint32_t length = (uint32_t)strlen((char*)sha);
    unsigned char* digest = ANXOpenSSL::getInstance().hexEncodeString(sha, length, &length);

    _OutputDebugString(L"[ANX] digest computed '%s' with length '%i'", digest, length);

    _OutputDebugString(L"[ANX] Attempt to release input byte array");

    if (FREReleaseByteArray(bytes) != FRE_OK) {
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
