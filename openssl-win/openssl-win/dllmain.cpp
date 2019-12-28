// dllmain.cpp : Defines the entry point for the DLL application.
#include "pch.h"
#include "FlashRuntimeExtensions.h"
#include "ANXOpenSSLConversionRoutines.h"
#include "ANXOpenSSL.h"
#include "ANXOpenSSLRSA.h"

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

    #pragma endregion

    #pragma region ContextInitialize/ContextFinalizer

    void ANXOpenSSLContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToSet, const FRENamedFunction** functionsToSet) {
        OutputDebugString(L"ANXOpenSSLContextInitializer");

        static FRENamedFunction functions[] = {
            { (const uint8_t*)"isSupported", NULL, &ANXOpenSSLIsSupported },
            { (const uint8_t*)"version", NULL, &ANXOpenSSLVersion },
            { (const uint8_t*)"rsaEncryptWithPublicKey", NULL, &ANXOpenSSLEncryptWithPublicKey },
            { (const uint8_t*)"rsaDecryptWithPrivateKey", NULL, &ANXOpenSSLDecryptWithPrivateKey },
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

