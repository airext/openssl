//
//  ANXOpenSSLFacade.m
//  OpenSSL
//
//  Created by Max Rozdobudko on 02.12.2019.
//

#import "ANXOpenSSLFacade.h"
#import "FlashRuntimeExtensions.h"
#import "ANXOpenSSL.h"
#import "ANXOpenSSLConversionRoutines.h"

@implementation ANXOpenSSLFacade

@end

#pragma mark API

FREObject ANXOpenSSLIsSupported(FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
    NSLog(@"ANXOpenSSLIsSupported");
    FREObject result;
    FRENewObjectFromBool(YES, &result);
    return result;
}

FREObject ANXOpenSSLVersion(FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
    NSLog(@"ANXOpenSSLVersion");
    return [ANXOpenSSLConversionRoutines convertNSStringToFREObject:ANXOpenSSL.sharedInstance.version];
}

#pragma mark ContextInitialize/ContextFinalizer

void ANXOpenSSLContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToSet, const FRENamedFunction** functionsToSet) {
    NSLog(@"ANXOpenSSLContextInitializer");

    *numFunctionsToSet = 2;

    FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * (*numFunctionsToSet));

    // functions

    func[0].name = (const uint8_t*) "isSupported";
    func[0].functionData = NULL;
    func[0].function = &ANXOpenSSLIsSupported;

    func[1].name = (const uint8_t*) "version";
    func[1].functionData = NULL;
    func[1].function = &ANXOpenSSLVersion;

    *functionsToSet = func;

    // Store reference to the context

//    ANXOpenSSL.sharedInstance.context = ctx;
}

void ANXOpenSSLContextFinalizer(FREContext ctx) {
    NSLog(@"ANXOpenSSLContextFinalizer");
//    ANXOpenSSL.sharedInstance.context = nil;
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
