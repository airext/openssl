//
//  ANXOpenSSLHEX.cpp
//  openssl-win-debug
//
//  Created by Max Rozdobudko on 19.01.2020.
//

#include "pch.h"
#include "ANXOpenSSLHEX.h"
#include "ANXOpenSSL.h"
#include "ANXOpenSSLUtils.h"
#include "ANXOpenSSLDefer.h"
#include "ANXOpenSSLConversionRoutines.h"

FREObject ANXOpenSSLHEX::hexEncodeString(FREObject string) {
    const unsigned char* input;
    uint32_t inputLength;
    if (FREGetObjectAsUTF8(string, &inputLength, &input) != FRE_OK) {
        return NULL;
    }

    _OutputDebugString(L"[ANX] input: %s", input);

    uint32_t outputLength;
    unsigned char* output = ANXOpenSSL::getInstance().hexEncodeString(input, inputLength, &outputLength);

    _OutputDebugString(L"[ANX] Encoded: %s", output);

    if (!output) {
        return NULL;
    }

    defer {
        free(output);
    };

    FREObject result;
    if (FRENewObjectFromUTF8(outputLength, output, &result) != FRE_OK) {
        return NULL;
    }

    return result;
}

FREObject ANXOpenSSLHEX::hexDecodeString(FREObject string) {
    const unsigned char* input;
    uint32_t inputLength;
    if (FREGetObjectAsUTF8(string, &inputLength, &input) != FRE_OK) {
        return NULL;
    }

    uint32_t outputLength;
    unsigned char *output = ANXOpenSSL::getInstance().hexDecodeString(input, inputLength, &outputLength);

    _OutputDebugString(L"[ANX] Decoded: %s", output);

    if (!output) {
        return NULL;
    }

    defer {
        free(output);
    };

    FREObject result;
    if (FRENewObjectFromUTF8(outputLength, output, &result) != FRE_OK) {
        return NULL;
    }

    return result;
}

FREObject ANXOpenSSLHEX::hexEncodeBytes(FREObject bytes) {

    _OutputDebugString(L"[ANX] Attempt to acquire input byte array");

    FREByteArray input;
    if (FREAcquireByteArray(bytes, &input) != FRE_OK) {
        return NULL;
    }

    _OutputDebugString(L"[ANX] attempt to encode an input");

    uint32_t outputLength;
    unsigned char* output = ANXOpenSSL::getInstance().hexEncodeString(input.bytes, input.length, &outputLength);

    _OutputDebugString(L"[ANX] Encoded: %s", output);

    if (!output) {
        return NULL;
    }

    defer {
        free(output);
    };

    _OutputDebugString(L"[ANX] Attempt to release input byte array");

    if (FREReleaseByteArray(bytes) != FRE_OK) {
        return NULL;
    }

    _OutputDebugString(L"[ANX] Attempt to convert encoded string to output FREObject");

    FREObject result;
    if (FRENewObjectFromUTF8(outputLength, output, &result) != FRE_OK) {
        return NULL;
    }

    return result;
}

FREObject ANXOpenSSLHEX::hexDecodeBytes(FREObject bytes) {
    const unsigned char* input;
    uint32_t inputLength;
    if (FREGetObjectAsUTF8(bytes, &inputLength, &input) != FRE_OK) {
        return NULL;
    }

    _OutputDebugString(L"[ANX] Attempt to decode string: %s", input);

    uint32_t outputLength;
    unsigned char *decoded = ANXOpenSSL::getInstance().hexDecodeString(input, inputLength, &outputLength);

    _OutputDebugString(L"[ANX] Decoded: %s", decoded);

    if (!decoded) {
        return NULL;
    }

    defer {
        free(decoded);
    };

    _OutputDebugString(L"[ANX] Attempt to create output byte array");

    FREObject result = ANXOpenSSLConversionRoutines::createByteArrayWithLength(outputLength);
    if (result == NULL) {
        return NULL;
    }

    _OutputDebugString(L"[ANX] Attempt to acquire output byte array");

    FREByteArray output;
    if (FREAcquireByteArray(result, &output) != FRE_OK) {
        return NULL;
    }

    _OutputDebugString(L"[ANX] Attempt to copy encrypted data into output byte array");

    memcpy(output.bytes, decoded, outputLength);

    _OutputDebugString(L"[ANX] attempt to release output byte array");

    if (FREReleaseByteArray(result) != FRE_OK) {
        return NULL;
    }

    _OutputDebugString(L"[ANX] all operations are done");

    return result;
}
