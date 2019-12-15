//
//  ANXOpenSSLFacade.m
//  OpenSSL
//
//  Created by Max Rozdobudko on 02.12.2019.
//

#import "ANXOpenSSLFacade.h"
#import "FlashRuntimeExtensions.h"
#import "ANXOpenSSL.h"
#import "ANXOpenSSL+RSA.h"
#import "ANXOpenSSL+Utils.h"
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

#pragma mark RSA

FREObject ANXOpenSSLEncryptWithPrivateKey(FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
    NSLog(@"ANXOpenSSLEncryptWithPrivateKey");

    if (argc < 1) {
        return NULL;
    }

    unsigned char privateKey[]="-----BEGIN RSA PRIVATE KEY-----\n"\
    "MIIEowIBAAKCAQEAy8Dbv8prpJ/0kKhlGeJYozo2t60EG8L0561g13R29LvMR5hy\n"\
    "vGZlGJpmn65+A4xHXInJYiPuKzrKUnApeLZ+vw1HocOAZtWK0z3r26uA8kQYOKX9\n"\
    "Qt/DbCdvsF9wF8gRK0ptx9M6R13NvBxvVQApfc9jB9nTzphOgM4JiEYvlV8FLhg9\n"\
    "yZovMYd6Wwf3aoXK891VQxTr/kQYoq1Yp+68i6T4nNq7NWC+UNVjQHxNQMQMzU6l\n"\
    "WCX8zyg3yH88OAQkUXIXKfQ+NkvYQ1cxaMoVPpY72+eVthKzpMeyHkBn7ciumk5q\n"\
    "gLTEJAfWZpe4f4eFZj/Rc8Y8Jj2IS5kVPjUywQIDAQABAoIBADhg1u1Mv1hAAlX8\n"\
    "omz1Gn2f4AAW2aos2cM5UDCNw1SYmj+9SRIkaxjRsE/C4o9sw1oxrg1/z6kajV0e\n"\
    "N/t008FdlVKHXAIYWF93JMoVvIpMmT8jft6AN/y3NMpivgt2inmmEJZYNioFJKZG\n"\
    "X+/vKYvsVISZm2fw8NfnKvAQK55yu+GRWBZGOeS9K+LbYvOwcrjKhHz66m4bedKd\n"\
    "gVAix6NE5iwmjNXktSQlJMCjbtdNXg/xo1/G4kG2p/MO1HLcKfe1N5FgBiXj3Qjl\n"\
    "vgvjJZkh1as2KTgaPOBqZaP03738VnYg23ISyvfT/teArVGtxrmFP7939EvJFKpF\n"\
    "1wTxuDkCgYEA7t0DR37zt+dEJy+5vm7zSmN97VenwQJFWMiulkHGa0yU3lLasxxu\n"\
    "m0oUtndIjenIvSx6t3Y+agK2F3EPbb0AZ5wZ1p1IXs4vktgeQwSSBdqcM8LZFDvZ\n"\
    "uPboQnJoRdIkd62XnP5ekIEIBAfOp8v2wFpSfE7nNH2u4CpAXNSF9HsCgYEA2l8D\n"\
    "JrDE5m9Kkn+J4l+AdGfeBL1igPF3DnuPoV67BpgiaAgI4h25UJzXiDKKoa706S0D\n"\
    "4XB74zOLX11MaGPMIdhlG+SgeQfNoC5lE4ZWXNyESJH1SVgRGT9nBC2vtL6bxCVV\n"\
    "WBkTeC5D6c/QXcai6yw6OYyNNdp0uznKURe1xvMCgYBVYYcEjWqMuAvyferFGV+5\n"\
    "nWqr5gM+yJMFM2bEqupD/HHSLoeiMm2O8KIKvwSeRYzNohKTdZ7FwgZYxr8fGMoG\n"\
    "PxQ1VK9DxCvZL4tRpVaU5Rmknud9hg9DQG6xIbgIDR+f79sb8QjYWmcFGc1SyWOA\n"\
    "SkjlykZ2yt4xnqi3BfiD9QKBgGqLgRYXmXp1QoVIBRaWUi55nzHg1XbkWZqPXvz1\n"\
    "I3uMLv1jLjJlHk3euKqTPmC05HoApKwSHeA0/gOBmg404xyAYJTDcCidTg6hlF96\n"\
    "ZBja3xApZuxqM62F6dV4FQqzFX0WWhWp5n301N33r0qR6FumMKJzmVJ1TA8tmzEF\n"\
    "yINRAoGBAJqioYs8rK6eXzA8ywYLjqTLu/yQSLBn/4ta36K8DyCoLNlNxSuox+A5\n"\
    "w6z2vEfRVQDq4Hm4vBzjdi3QfYLNkTiTqLcvgWZ+eX44ogXtdTDO7c+GeMKWz4XX\n"\
    "uJSUVL5+CVjKLjZEJ6Qc2WZLl94xSwL71E41H4YciVnSCQxVc4Jw\n"\
    "-----END RSA PRIVATE KEY-----\n";

    FREByteArray input;
    if (FREAcquireByteArray(argv[0], &input) != FRE_OK) {
        return NULL;
    }

    NSLog(@"ANX input acquired");

    unsigned char encrypted[4098] = {};

    int len = [ANXOpenSSL.sharedInstance rsaEncryptString:(const unsigned char *)input.bytes withPrivateKey:privateKey output:encrypted];

    NSLog(@"ANX input encrypted with length: %i", len);

    if (FREReleaseByteArray(argv[0]) != FRE_OK) {
        return NULL;
    }

    NSLog(@"ANX input released");

    FREObject result;
    FRENewObject((const uint8_t *)"flash.utils.ByteArray", 0, NULL, &result, NULL);
    FREObject length;
    FRENewObjectFromInt32((int)strlen((const char*)encrypted), &length);
    FRESetObjectProperty(result, (const uint8_t *)"length", length, NULL);

    NSLog(@"ANX bytearray created");

    FREByteArray output;
    if (FREAcquireByteArray(result, &output) != FRE_OK) {
        return NULL;
    }

    NSLog(@"ANX output acquired");

    memcpy(output.bytes, encrypted, strlen((const char*)encrypted));

    NSLog(@"ANX memcpy done");

    if (FREReleaseByteArray(result) != FRE_OK) {
        return NULL;
    }

    NSLog(@"ANX output released");

    return result;
}

FREObject ANXOpenSSLDecryptWithPublicKey(FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
    NSLog(@"ANXOpenSSLDecryptWithPublicKey");
    return [ANXOpenSSLConversionRoutines convertNSStringToFREObject:ANXOpenSSL.sharedInstance.version];
}


FREObject ANXOpenSSLEncryptWithPublicKey(FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
    NSLog(@"ANXOpenSSLEncryptWithPublicKey");

    if (argc < 2) {
        return NULL;
    }

    return [ANXOpenSSL.sharedInstance rsaEncrypt:argv[0] withPublicKey:argv[1]];
}

FREObject ANXOpenSSLDecryptWithPrivateKey(FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
    NSLog(@"ANXOpenSSLDecryptWithPrivateKey");

    if (argc < 2) {
        return NULL;
    }

    return [ANXOpenSSL.sharedInstance rsaDecrypt:argv[0] withPrivateKey:argv[1]];
}

#pragma mark Base64

FREObject ANXOpenSSLBase64EncodeString(FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
    NSLog(@"ANXOpenSSLBase64EncodeString");

    if (argc < 1) {
        return NULL;
    }

    return [ANXOpenSSL.sharedInstance base64EncodeString:argv[0]];
}

FREObject ANXOpenSSLBase64DecodeString(FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
    NSLog(@"ANXOpenSSLBase64DecodeString");

    if (argc < 1) {
        return NULL;
    }

    return [ANXOpenSSL.sharedInstance base64decodeString:argv[0]];
}

FREObject ANXOpenSSLBase64EncodeBytes(FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
    NSLog(@"ANXOpenSSLBase64EncodeBytes");

    if (argc < 1) {
        return NULL;
    }

    return [ANXOpenSSL.sharedInstance base64EncodeBytes:argv[0]];
}

FREObject ANXOpenSSLBase64DecodeBytes(FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
    NSLog(@"ANXOpenSSLBase64DecodeBytes");

    if (argc < 1) {
        return NULL;
    }

    return [ANXOpenSSL.sharedInstance base64DecodeBytes:argv[0]];
}

#pragma mark Hex

FREObject ANXOpenSSLHexEncodeString(FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
    NSLog(@"ANXOpenSSLHexEncodeString");

    if (argc < 1) {
        return NULL;
    }

    return [ANXOpenSSL.sharedInstance hexEncodeString:argv[0]];
}

FREObject ANXOpenSSLHexDecodeString(FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
    NSLog(@"ANXOpenSSLHexDecodeString");

    if (argc < 1) {
        return NULL;
    }

    return [ANXOpenSSL.sharedInstance hexDecodeString:argv[0]];
}

#pragma mark Debug

FREObject ANXOpenSSLTest(FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
    NSLog(@"ANXOpenSSLEncryptWithPrivateKey");

    FREByteArray byteArray;
    int retVal;

    retVal = FREAcquireByteArray(argv[0], &byteArray);
    uint8_t* nativeString = (uint8_t*) "Hello from C";
    memcpy (byteArray.bytes, nativeString, 12);
    retVal = FREReleaseByteArray(argv[0]);

    FREObject result;
    FRENewObject((const uint8_t *)"flash.utils.ByteArray", 0, NULL, &result, NULL);
    FREObject length;
    FRENewObjectFromInt32((int)strlen((const char*)nativeString), &length);
    FRESetObjectProperty(result, (const uint8_t *)"length", length, NULL);

    FREByteArray output;
    FREAcquireByteArray(result, &output);
    memcpy(output.bytes, nativeString, strlen((const char*)nativeString));
    FREReleaseByteArray(result);

    return result;
}

FREObject ANXOpenBuildVersion(FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
    return [ANXOpenSSLConversionRoutines convertNSStringToFREObject:@"27"];
}

#pragma mark - ContextInitialize/ContextFinalizer

void ANXOpenSSLContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToSet, const FRENamedFunction** functionsToSet) {
    NSLog(@"ANXOpenSSLContextInitializer");

    *numFunctionsToSet = 14;

    FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * (*numFunctionsToSet));

    // functions

    func[0].name = (const uint8_t*) "isSupported";
    func[0].functionData = NULL;
    func[0].function = &ANXOpenSSLIsSupported;

    func[1].name = (const uint8_t*) "version";
    func[1].functionData = NULL;
    func[1].function = &ANXOpenSSLVersion;

    func[2].name = (const uint8_t*) "rsaEncryptWithPrivateKey";
    func[2].functionData = NULL;
    func[2].function = &ANXOpenSSLEncryptWithPrivateKey;

    func[3].name = (const uint8_t*) "rsaDecryptWithPublicKey";
    func[3].functionData = NULL;
    func[3].function = &ANXOpenSSLDecryptWithPublicKey;

    func[4].name = (const uint8_t*) "rsaEncryptWithPublicKey";
    func[4].functionData = NULL;
    func[4].function = &ANXOpenSSLEncryptWithPublicKey;

    func[5].name = (const uint8_t*) "rsaDecryptWithPrivateKey";
    func[5].functionData = NULL;
    func[5].function = &ANXOpenSSLDecryptWithPrivateKey;

    func[6].name = (const uint8_t*) "base64EncodeString";
    func[6].functionData = NULL;
    func[6].function = &ANXOpenSSLBase64EncodeString;

    func[7].name = (const uint8_t*) "base64DecodeString";
    func[7].functionData = NULL;
    func[7].function = &ANXOpenSSLBase64DecodeString;

    func[8].name = (const uint8_t*) "base64EncodeBytes";
    func[8].functionData = NULL;
    func[8].function = &ANXOpenSSLBase64EncodeBytes;

    func[9].name = (const uint8_t*) "base64DecodeBytes";
    func[9].functionData = NULL;
    func[9].function = &ANXOpenSSLBase64DecodeBytes;

    func[10].name = (const uint8_t*) "hexEncodeString";
    func[10].functionData = NULL;
    func[10].function = &ANXOpenSSLHexEncodeString;

    func[11].name = (const uint8_t*) "hexDecodeString";
    func[11].functionData = NULL;
    func[11].function = &ANXOpenSSLHexDecodeString;

    // debug

    func[12].name = (const uint8_t*) "test";
    func[12].functionData = NULL;
    func[12].function = &ANXOpenSSLTest;

    func[13].name = (const uint8_t*) "buildVersion";
    func[13].functionData = NULL;
    func[13].function = &ANXOpenBuildVersion;

    *functionsToSet = func;
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
