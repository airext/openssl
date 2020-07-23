//
//  ANXOpenSSLFacade.m
//  OpenSSL
//
//  Created by Max Rozdobudko on 02.12.2019.
//

#import "ANXOpenSSLFacade.h"
#import "FlashRuntimeExtensions.h"
#import "ANXOpenSSLConversionRoutines.h"
#import "ANXOpenSSLMain.h"

@implementation ANXOpenSSLFacade

@end

#pragma mark - New API

FREObject ANXOpenSSL_isSupported(FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
    NSLog(@"ANXOpenSSL_isSupported");
    FREObject result;
    FRENewObjectFromBool(YES, &result);
    return result;
}

FREObject ANXOpenSSL_rsaEncrypt(FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
    NSLog(@"ANXOpenSSL_rsaEncrypt");
    return ANXOpenSSLMain_rsaEncrypt(context, functionData, argc, argv);
}

FREObject ANXOpenSSL_rsaDecrypt(FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
    NSLog(@"ANXOpenSSL_rsaDecrypt");
    return ANXOpenSSLMain_rsaDecrypt(context, functionData, argc, argv);
}

FREObject ANXOpenSSL_aesEncrypt(FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
    NSLog(@"ANXOpenSSL_aesEncrypt");
    return ANXOpenSSLMain_aesEncrypt(context, functionData, argc, argv);
}

FREObject ANXOpenSSL_aesDecrypt(FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
    NSLog(@"ANXOpenSSL_aesDecrypt");
    return ANXOpenSSLMain_aesDecrypt(context, functionData, argc, argv);
}

FREObject ANXOpenSSL_computeSha256(FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
    NSLog(@"ANXOpenSSL_computeSha256");
    return ANXOpenSSLMain_computeSha256(context, functionData, argc, argv);
}

FREObject ANXOpenSSL_hmacCompute(FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
    NSLog(@"ANXOpenSSL_hmacCompute");
    return ANXOpenSSLMain_hmacCompute(context, functionData, argc, argv);
}

FREObject ANXOpenSSL_getOpenSSLVersion(FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
    NSLog(@"ANXOpenSSL_getOpenSSLVersion");
    return ANXOpenSSLMain_getOpenSSLVersion(context, functionData, argc, argv);
}

FREObject ANXOpenSSL_verifyCertificate(FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
    NSLog(@"ANXOpenSSL_verifyCertificate");
    return ANXOpenSSLMain_verifyCertificate(context, functionData, argc, argv);
}

FREObject ANXOpenSSL_extractPublicKey(FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
    NSLog(@"ANXOpenSSL_extractPublicKey");
    return ANXOpenSSLMain_extractPublicKey(context, functionData, argc, argv);
}

FREObject ANXOpenSSL_parseCertificate(FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
    NSLog(@"ANXOpenSSL_parseCertificate");
    return ANXOpenSSLMain_parseCertificate(context, functionData, argc, argv);
}

FREObject ANXOpenSSL_parseCertificateSerial(FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
    NSLog(@"ANXOpenSSL_parseCertificateSerial");
    return ANXOpenSSLMain_parseCertificateSerial(context, functionData, argc, argv);
}

FREObject ANXOpenSSL_PBKDF2_HMAC_SHA_256(FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
    NSLog(@"ANXOpenSSL_PBKDF2_HMAC_SHA_256");
    return ANXOpenSSLMain_PBKDF2_HMAC_SHA_256(context, functionData, argc, argv);
}

#pragma mark - ContextInitialize/ContextFinalizer

void ANXOpenSSLContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToSet, const FRENamedFunction** functionsToSet) {
    NSLog(@"ANXOpenSSLContextInitializer");

    static FRENamedFunction functions[] = {
        { (const uint8_t*)"isSupported", NULL, &ANXOpenSSL_isSupported },

        { (const uint8_t*)"rsaEncrypt", NULL, &ANXOpenSSL_rsaEncrypt },
        { (const uint8_t*)"rsaDecrypt", NULL, &ANXOpenSSL_rsaDecrypt },
        { (const uint8_t*)"aesEncrypt", NULL, &ANXOpenSSL_aesEncrypt },
        { (const uint8_t*)"aesDecrypt", NULL, &ANXOpenSSL_aesDecrypt },
        { (const uint8_t*)"computeSHA256", NULL, &ANXOpenSSL_computeSha256 },
        { (const uint8_t*)"hmacCompute", NULL, &ANXOpenSSL_hmacCompute },
        { (const uint8_t*)"getOpenSSLVersion", NULL, &ANXOpenSSL_getOpenSSLVersion },
        { (const uint8_t*)"verifyCertificate", NULL, &ANXOpenSSL_verifyCertificate },
        { (const uint8_t*)"extractPublicKey", NULL, &ANXOpenSSL_extractPublicKey },
        { (const uint8_t*)"parseCertificate", NULL, &ANXOpenSSL_parseCertificate },
        { (const uint8_t*)"parseCertificateSerial", NULL, &ANXOpenSSL_parseCertificateSerial },
        { (const uint8_t*)"pbkdf2Compute", NULL, &ANXOpenSSL_PBKDF2_HMAC_SHA_256 },
    };

    *numFunctionsToSet = sizeof(functions) / sizeof(FRENamedFunction);

    *functionsToSet = functions;
}

void ANXOpenSSLContextFinalizer(FREContext ctx) {
    NSLog(@"ANXOpenSSLContextFinalizer");
}

#pragma mark Initializer/Finalizer

void ANXOpenSSLInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet) {
    NSLog(@"ANXOpenSSLInitializer");

    *extDataToSet = NULL;

    *ctxInitializerToSet = &ANXOpenSSLContextInitializer;
    *ctxFinalizerToSet = &ANXOpenSSLContextFinalizer;
}

void ANXOpenSSLFinalizer(void* extData) {
    NSLog(@"ANXOpenSSLFinalizer");
}
