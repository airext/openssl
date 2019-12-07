//
//  ANXOpenSSL+Utils.m
//  OpenSSL
//
//  Created by Max Rozdobudko on 05.12.2019.
//

#import "ANXOpenSSL+Utils.h"
#import "ANXOpenSSLUtils.h"
#import "ANXOpenSSLDefer.h"

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

@end
