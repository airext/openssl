//
//  ANXOpenSSL+Utils.m
//  OpenSSL
//
//  Created by Max Rozdobudko on 05.12.2019.
//

#import "ANXOpenSSL+Utils.h"
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

@implementation ANXOpenSSL (Utils)

- (FREObject)base64EncodeString:(FREObject)string {
    uint32_t inputLength;
    const uint8_t *input;
    if (FREGetObjectAsUTF8(string, &inputLength, &input) != FRE_OK) {
        return nil;
    }

    NSLog(@"[ANX] input: %s", input);

    NSLog(@"[ANX] attempt to encode an input");

    char *base64;
    size_t outputLength;

    int result = anx_base64_encode(input, strlen((const char*)input) + 1, &base64, &outputLength);
    if (!result) {
        return NULL;
    }

    NSLog(@"[ANX] encoded: %s with result: %i", base64, result);

    defer(^{
        free(base64);
    });

    FREObject output;
    if (FRENewObjectFromUTF8((uint32_t)outputLength, (const uint8_t *)base64, &output) != FRE_OK) {
        return NULL;
    }

    NSLog(@"[ANX] output length: %lu", outputLength);

    return output;
}

- (FREObject)base64decodeString:(FREObject)string {
    uint32_t inputLength;
    const uint8_t *input;
    if (FREGetObjectAsUTF8(string, &inputLength, &input) != FRE_OK) {
        return nil;
    }

    NSLog(@"[ANX] input: %s", input);

    NSLog(@"[ANX] attempt to decode an input");

    size_t outputLength;

    unsigned char *decoded = NULL;

    int result = anx_base64_decode((const char*)input, strlen((const char*)input), &decoded, &outputLength);
    if (!result) {
        return NULL;
    }

    NSLog(@"[ANX] decoded: %s with result: %i", decoded, result);

    defer(^{
        free(decoded);
    });

    FREObject output;
    if (FRENewObjectFromUTF8((uint32_t)outputLength, (const uint8_t *)decoded, &output) != FRE_OK) {
        return NULL;
    }

    NSLog(@"[ANX] output length: %lu", outputLength);

    return output;
}

- (FREObject)base64EncodeBytes:(FREObject)bytes {

    NSLog(@"[ANX] Attempt to acquire input byte array");

    FREByteArray input;
    if (FREAcquireByteArray(bytes, &input) != FRE_OK) {
        return NULL;
    }

    NSLog(@"[ANX] attempt to encode an input");

    char *base64;
    size_t outputLength;

    int result = anx_base64_encode(input.bytes, strlen((const char*)input.bytes) + 1, &base64, &outputLength);
    if (!result) {
        return NULL;
    }

    NSLog(@"[ANX] encoded: %s with result: %i", base64, result);

    defer(^{
        free(base64);
    });

    NSLog(@"[ANX] Attempt to release input byte array");

    if (FREReleaseByteArray(bytes) != FRE_OK) {
        return NULL;
    }

    NSLog(@"[ANX] Attempt to create output FREObject from base64 string");

    FREObject output;
    if (FRENewObjectFromUTF8((uint32_t)outputLength, (const uint8_t *)base64, &output) != FRE_OK) {
        return NULL;
    }

    NSLog(@"[ANX] output length: %lu", outputLength);

    return output;
}

- (FREObject)base64DecodeBytes:(FREObject)string {
    uint32_t inputLength;
    const uint8_t *input;
    if (FREGetObjectAsUTF8(string, &inputLength, &input) != FRE_OK) {
        return nil;
    }

    NSLog(@"[ANX] input: %s", input);

    NSLog(@"[ANX] attempt to decode an input");

    size_t outputLength;

    unsigned char *decoded = NULL;

    int decodeResult = anx_base64_decode((const char*)input, strlen((const char*)input), &decoded, &outputLength);
    if (!decodeResult) {
        return NULL;
    }

    NSLog(@"[ANX] decoded: %s with result: %i", decoded, decodeResult);

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

#pragma mark Hex

- (FREObject)hexEncodeString:(FREObject)string {
    const unsigned char* input;
    uint32_t inputLength;
    if (FREGetObjectAsUTF8(string, &inputLength, &input) != FRE_OK) {
        return NULL;
    }

    NSLog(@"[ANX] input: %s", input);

    uint32_t outputLength;
    unsigned char* output = [self hexEncodeString:input inputLength:inputLength outputLength:&outputLength];

    defer(^{
        free(output);
    });

    FREObject result;
    if (FRENewObjectFromUTF8(outputLength, output, &result) != FRE_OK) {
        return NULL;
    }

    return result;

//    NSMutableString *hex = [NSMutableString new];
//    for (NSInteger i = 0; i < inputLength; i++) {
//        [hex appendFormat:@"%02x", input[i]];
//        NSLog(@"[ANX] input[i]=%c", input[i]);
//        NSLog(@"[ANX] hex so far: %@", hex);
//    }
//
//    NSLog(@"[ANX converted: %@]", hex);
//
//    return [ANXOpenSSLConversionRoutines convertNSStringToFREObject:hex];
}

- (FREObject)hexDecodeString:(FREObject)string {
    const unsigned char* input;
    uint32_t inputLength;
    if (FREGetObjectAsUTF8(string, &inputLength, &input) != FRE_OK) {
        return NULL;
    }

    uint32_t outputLength;

    unsigned char *output = [self hexDecodeString:input inputLength:inputLength outputLength:&outputLength];

    defer(^{
        free(output);
    });

    FREObject result;
    if (FRENewObjectFromUTF8(outputLength, output, &result) != FRE_OK) {
        return NULL;
    }

    return result;
}

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

    NSLog(@"[ANX] Decoded");

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
