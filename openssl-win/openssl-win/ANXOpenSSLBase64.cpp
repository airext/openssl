#include "pch.h"
#include "ANXOpenSSLBase64.h"
#include "ANXOpenSSL.h"
#include "ANXOpenSSLConversionRoutines.h"
#include "ANXOpenSSLDefer.h"
#include "ANXOpenSSLUtils.h"

FREObject ANXOpenSSLBase64::base64EncodeString(FREObject string)
{
    uint32_t inputLength;
    const uint8_t* input;
    if (FREGetObjectAsUTF8(string, &inputLength, &input) != FRE_OK) {
        return NULL;
    }

    _OutputDebugString(L"[ANX] input: %s", input);

    _OutputDebugString(L"[ANX] attempt to encode an input");

    char* base64;
    size_t outputLength;

    int result = anx_base64_encode(input, strlen((const char*)input) + 1, &base64, &outputLength);
    if (!result) {
        return NULL;
    }

    _OutputDebugString(L"[ANX] encoded: %s with result: %i", base64, result);

    FREObject output;
    if (FRENewObjectFromUTF8((uint32_t)outputLength, (const uint8_t*)base64, &output) != FRE_OK) {
        return NULL;
    }

    _OutputDebugString(L"[ANX] output length: %lu", outputLength);

    return output;
}

FREObject ANXOpenSSLBase64::base64DecodeString(FREObject string)
{
    uint32_t inputLength;
    const uint8_t* input;
    if (FREGetObjectAsUTF8(string, &inputLength, &input) != FRE_OK) {
        return NULL;
    }

    _OutputDebugString(L"[ANX] input: %s", input);

    _OutputDebugString(L"[ANX] attempt to decode an input");

    size_t outputLength;

    unsigned char* decoded = NULL;

    int result = anx_base64_decode((const char*)input, strlen((const char*)input), &decoded, &outputLength);
    if (!result) {
        return NULL;
    }

    _OutputDebugString(L"[ANX] decoded: %s with result: %i", decoded, result);

    FREObject output;
    if (FRENewObjectFromUTF8((uint32_t)outputLength, (const uint8_t*)decoded, &output) != FRE_OK) {
        return NULL;
    }

    _OutputDebugString(L"[ANX] output length: %lu", outputLength);

    return output;
}

FREObject ANXOpenSSLBase64::base64EncodeBytes(FREObject bytes)
{
    _OutputDebugString(L"[ANX] Attempt to acquire input byte array");

    FREByteArray input;
    if (FREAcquireByteArray(bytes, &input) != FRE_OK) {
        return NULL;
    }

    _OutputDebugString(L"[ANX] attempt to encode an input");

    char* base64;
    size_t outputLength;

    int result = anx_base64_encode(input.bytes, strlen((const char*)input.bytes) + 1, &base64, &outputLength);
    if (!result) {
        return NULL;
    }

    _OutputDebugString(L"[ANX] encoded: %s with result: %i", base64, result);

    defer {
        _OutputDebugString(L"[ANX] Freeing base64 string buffer");
        free(base64);
    };

    _OutputDebugString(L"[ANX] Attempt to release input byte array");

    if (FREReleaseByteArray(bytes) != FRE_OK) {
        return NULL;
    }

    _OutputDebugString(L"[ANX] Attempt to create output FREObject from base64 string");

    FREObject output;
    if (FRENewObjectFromUTF8((uint32_t)outputLength, (const uint8_t*)base64, &output) != FRE_OK) {
        return NULL;
    }

    _OutputDebugString(L"[ANX] output length: %lu", outputLength);

    return output;
}

FREObject ANXOpenSSLBase64::base64DecodeBytes(FREObject bytes)
{
    uint32_t inputLength;
    const uint8_t* input;
    if (FREGetObjectAsUTF8(bytes, &inputLength, &input) != FRE_OK) {
        return NULL;
    }

    _OutputDebugString(L"[ANX] input: %s", input);

    _OutputDebugString(L"[ANX] attempt to decode an input");

    size_t outputLength;

    unsigned char* decoded = NULL;

    int decodeResult = anx_base64_decode((const char*)input, strlen((const char*)input), &decoded, &outputLength);
    if (!decodeResult) {
        return NULL;
    }

    _OutputDebugString(L"[ANX] decoded: %s with result: %i", decoded, decodeResult);

    defer {
        _OutputDebugString(L"[ANX] Freeing decoded bytes");
        free(decoded);
    };

    _OutputDebugString(L"[ANX] Attempt to create output byte array");

    FREObject result = ANXOpenSSLConversionRoutines::createByteArrayWithLength((uint32_t)outputLength);
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
