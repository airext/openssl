// dllmain.cpp : Defines the entry point for the DLL application.
#include "pch.h"
#include "FlashRuntimeExtensions.h"
#include "ANXOpenSSLConversionRoutines.h"
#include "ANXOpenSSL.h"

extern "C" {

    #pragma mark API

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

    #pragma mark - ContextInitialize/ContextFinalizer

    void ANXOpenSSLContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToSet, const FRENamedFunction** functionsToSet) {
        OutputDebugString(L"ANXOpenSSLContextInitializer");

        static FRENamedFunction functions[] = {
            { (const uint8_t*)"isSupported", NULL, &ANXOpenSSLIsSupported },
            { (const uint8_t*)"version", NULL, &ANXOpenSSLVersion }
        };

        *numFunctionsToSet = sizeof(functions) / sizeof(FRENamedFunction);

        *functionsToSet = functions;
    }

    void ANXOpenSSLContextFinalizer(FREContext ctx) {
        OutputDebugString(L"ANXOpenSSLContextFinalizer");
    }

    #pragma mark Initializer/Finalizer

	__declspec(dllexport) void ANXOpenSSLInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet) {
        OutputDebugString(L"ANXOpenSSLInitializer");

        *extDataToSet = NULL;

        *ctxInitializerToSet = &ANXOpenSSLContextInitializer;
        *ctxFinalizerToSet = &ANXOpenSSLContextFinalizer;
    }

    __declspec(dllexport) void ANXOpenSSLFinalizer(void* extData) {
        OutputDebugString(L"ANXOpenSSLFinalizer");
    }
}

