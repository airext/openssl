// dllmain.cpp : Defines the entry point for the DLL application.
#include "pch.h"
#include "FlashRuntimeExtensions.h"
#include "ANXOpenSSLConversionRoutines.h"
#include "ANXOpenSSL.h"
#include "ANXOpenSSLRSA.h"
#include "ANXOpenSSLAES.h"
#include "ANXOpenSSLBase64.h"

extern "C" {

    #pragma region Common

    FREObject ANXOpenSSLIsSupported(FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
        OutputDebugString(L"ANXOpenSSLIsSupported");
        FREObject result;
        FRENewObjectFromBool(1, &result);
        return result;
    }

    FREObject ANXOpenSSLVersion(FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
        OutputDebugString(L"ANXOpenSSLVersion");
        return ANXOpenSSLConversionRoutines::convertCharArrayToFREObject(ANXOpenSSL::getInstance().version());
    }

    #pragma endregion

    #pragma region RSA

    FREObject ANXOpenSSLEncryptWithPublicKey(FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
        OutputDebugString(L"ANXOpenSSLEncryptWithPublicKey");

        if (argc < 2) {
            return NULL;
        }

        return ANXOpenSSLRSA::rsaEncryptWithPublicKey(argv[0], argv[1]);
    }

    FREObject ANXOpenSSLDecryptWithPrivateKey(FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
        OutputDebugString(L"ANXOpenSSLDecryptWithPrivateKey");

        if (argc < 2) {
            return NULL;
        }

        return ANXOpenSSLRSA::rsaDecryptWithPrivateKey(argv[0], argv[1]);
    }

    FREObject ANXOpenSSLVerifyCertificate(FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
        _OutputDebugString(L"ANXOpenSSLVerifyCertificate");

        if (argc < 2) {
            return NULL;
        }

        return ANXOpenSSLRSA::verifyCertificate(argv[1], argv[0]);
    }

    #pragma endregion

    #pragma region AES

    FREObject ANXOpenSSLAESEncrypt(FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
        _OutputDebugString(L"ANXOpenSSLAESEncrypt");

        if (argc < 3) {
            return NULL;
        }

        return ANXOpenSSLAES::aesEncrypt(argv[0], argv[1], argv[2]);
    }

    FREObject ANXOpenSSLAESDecrypt(FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
        _OutputDebugString(L"ANXOpenSSLAESDecrypt");

        if (argc < 3) {
            return NULL;
        }

        return ANXOpenSSLAES::aesDecrypt(argv[0], argv[1], argv[2]);
    }

    #pragma endregion

    #pragma region Base64

    FREObject ANXOpenSSLBase64EncodeString(FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
        _OutputDebugString(L"ANXOpenSSLBase64EncodeString");

        if (argc < 1) {
            return NULL;
        }

        return ANXOpenSSLBase64::base64EncodeString(argv[0]);
    }

    FREObject ANXOpenSSLBase64DecodeString(FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
        _OutputDebugString(L"ANXOpenSSLBase64DecodeString");

        if (argc < 1) {
            return NULL;
        }

        return ANXOpenSSLBase64::base64DecodeString(argv[0]);
    }

    FREObject ANXOpenSSLBase64EncodeBytes(FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
        _OutputDebugString(L"ANXOpenSSLBase64EncodeBytes");

        if (argc < 1) {
            return NULL;
        }

        return ANXOpenSSLBase64::base64EncodeBytes(argv[0]);
    }

    FREObject ANXOpenSSLBase64DecodeBytes(FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
        _OutputDebugString(L"ANXOpenSSLBase64DecodeBytes");

        if (argc < 1) {
            return NULL;
        }

        return ANXOpenSSLBase64::base64DecodeBytes(argv[0]);
    }

    #pragma endregion

    #pragma region Debug

    FREObject ANXOpenSSLTest(FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
        _OutputDebugString(L"ANXOpenSSLEncryptWithPrivateKey");
        return NULL;
    }

    FREObject ANXOpenBuildVersion(FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
        return ANXOpenSSLConversionRoutines::convertCharArrayToFREObject("2");
    }

    #pragma endregion

    #pragma region ContextInitialize/ContextFinalizer

    void ANXOpenSSLContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToSet, const FRENamedFunction** functionsToSet) {
        OutputDebugString(L"ANXOpenSSLContextInitializer");

        static FRENamedFunction functions[] = {
            { (const uint8_t*)"isSupported", NULL, &ANXOpenSSLIsSupported },
            { (const uint8_t*)"version", NULL, &ANXOpenSSLVersion },

            { (const uint8_t*)"rsaEncryptWithPublicKey", NULL, &ANXOpenSSLEncryptWithPublicKey },
            { (const uint8_t*)"rsaDecryptWithPrivateKey", NULL, &ANXOpenSSLDecryptWithPrivateKey },
            { (const uint8_t*)"verifyCertificate", NULL, &ANXOpenSSLVerifyCertificate },


            { (const uint8_t*)"aesEncrypt", NULL, &ANXOpenSSLAESEncrypt },
            { (const uint8_t*)"aesDecrypt", NULL, &ANXOpenSSLAESDecrypt },

            { (const uint8_t*)"base64EncodeString", NULL, &ANXOpenSSLBase64EncodeString },
            { (const uint8_t*)"base64DecodeString", NULL, &ANXOpenSSLBase64DecodeString },
            { (const uint8_t*)"base64EncodeBytes", NULL, &ANXOpenSSLBase64EncodeBytes },
            { (const uint8_t*)"base64DecodeBytes", NULL, &ANXOpenSSLBase64DecodeBytes },

            { (const uint8_t*)"buildVersion", NULL, &ANXOpenBuildVersion },
            { (const uint8_t*)"test", NULL, &ANXOpenSSLTest },
        };

        *numFunctionsToSet = sizeof(functions) / sizeof(FRENamedFunction);

        *functionsToSet = functions;
    }

    void ANXOpenSSLContextFinalizer(FREContext ctx) {
        OutputDebugString(L"ANXOpenSSLContextFinalizer");
    }

    #pragma endregion

    #pragma region Initializer/Finalizer

	__declspec(dllexport) void ANXOpenSSLInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet) {
        OutputDebugString(L"ANXOpenSSLInitializer");

        *extDataToSet = NULL;

        *ctxInitializerToSet = &ANXOpenSSLContextInitializer;
        *ctxFinalizerToSet = &ANXOpenSSLContextFinalizer;
    }

    __declspec(dllexport) void ANXOpenSSLFinalizer(void* extData) {
        OutputDebugString(L"ANXOpenSSLFinalizer");
    }

    #pragma endregion
}

