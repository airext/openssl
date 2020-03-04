//
//  ANXOpenSSL+HEX.m
//  OpenSSL
//
//  Created by Max Rozdobudko on 03.03.2020.
//

#import "ANXOpenSSL+HEX.h"
#import "ANXOpenSSLUtils.h"
#import "ANXOpenSSLDefer.h"
#import "ANXOpenSSLConversionRoutines.h"

#import <openssl/opensslv.h>
#import <openssl/pem.h>
#import <openssl/ssl.h>
#import <openssl/rsa.h>
#import <openssl/evp.h>
#import <openssl/bio.h>
#import <openssl/err.h>

@implementation ANXOpenSSL (HEX)

#pragma mark - Encode/Decode String

- (FREObject)hexEncodeString:(FREObject)string {
    const unsigned char* input;
    uint32_t inputLength;
    if (FREGetObjectAsUTF8(string, &inputLength, &input) != FRE_OK) {
        return NULL;
    }

    NSLog(@"[ANX] input: %s", input);

    uint32_t outputLength;
    unsigned char* output = [self hexEncodeString:input inputLength:inputLength outputLength:&outputLength];

    NSLog(@"[ANX] Encoded: %s", output);

    if (!output) {
        return NULL;
    }

    defer(^{
        free(output);
    });

    FREObject result;
    if (FRENewObjectFromUTF8(outputLength, output, &result) != FRE_OK) {
        return NULL;
    }

    return result;
}

- (FREObject)hexDecodeString:(FREObject)string {
    const unsigned char* input;
    uint32_t inputLength;
    if (FREGetObjectAsUTF8(string, &inputLength, &input) != FRE_OK) {
        return NULL;
    }

    uint32_t outputLength;
    unsigned char *output = [self hexDecodeString:input inputLength:inputLength outputLength:&outputLength];

    NSLog(@"[ANX] Decoded: %s", output);

    if (!output) {
        return NULL;
    }

    defer(^{
        free(output);
    });

    FREObject result;
    if (FRENewObjectFromUTF8(outputLength, output, &result) != FRE_OK) {
        return NULL;
    }

    return result;
}

#pragma mark - Encode/Decode Bytes

- (FREObject)hexEncodeBytes:(FREObject)bytes {

    NSLog(@"[ANX] Attempt to acquire input byte array");

    FREByteArray input;
    if (FREAcquireByteArray(bytes, &input) != FRE_OK) {
        return NULL;
    }

    NSLog(@"[ANX] attempt to encode an input");

    uint32_t outputLength;
    unsigned char* output = [self hexEncodeString:input.bytes inputLength:input.length outputLength:&outputLength];

    NSLog(@"[ANX] Encoded: %s", output);

    if (!output) {
        return NULL;
    }

    defer(^{
        free(output);
    });

    NSLog(@"[ANX] Attempt to release input byte array");

    if (FREReleaseByteArray(bytes) != FRE_OK) {
        return NULL;
    }

    NSLog(@"[ANX] Attempt to convert encoded string to output FREObject");

    FREObject result;
    if (FRENewObjectFromUTF8(outputLength, output, &result) != FRE_OK) {
        return NULL;
    }

    return result;
}

- (FREObject)hexDecodeBytes:(FREObject)string {
    const unsigned char* input;
    uint32_t inputLength;
    if (FREGetObjectAsUTF8(string, &inputLength, &input) != FRE_OK) {
        return NULL;
    }

    NSLog(@"[ANX] Attempt to decode string: %s", input);

    uint32_t outputLength;
    unsigned char *decoded = [self hexDecodeString:input inputLength:inputLength outputLength:&outputLength];

    if (!decoded) {
        return NULL;
    }

    NSLog(@"[ANX] Decoded: %s", decoded);

    defer(^{
        free(decoded);
    });

    NSLog(@"[ANX] Attempt to create output byte array");

    FREObject result = [ANXOpenSSLConversionRoutines createByteArrayWithLength:(int32_t)outputLength];
    if (result == NULL) {
        return NULL;
    }

    NSLog(@"[ANX] Attempt to acquire output byte array");

    FREByteArray output;
    if (FREAcquireByteArray(result, &output) != FRE_OK) {
        return NULL;
    }

    NSLog(@"[ANX] Attempt to copy encrypted data into output byte array");

    memcpy(output.bytes, decoded, outputLength);

    NSLog(@"[ANX] attempt to release output byte array");

    if (FREReleaseByteArray(result) != FRE_OK) {
        return NULL;
    }

    NSLog(@"[ANX] all operations are done");

    return result;
}

@end
