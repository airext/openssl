//
//  ANXOpenSSL+HMAC.m
//  OpenSSL
//
//  Created by Max Rozdobudko on 21.01.2020.
//

#import "ANXOpenSSL+HMAC.h"
#import "ANXOpenSSLConversionRoutines.h"

@implementation ANXOpenSSL (HMAC)

- (FREObject)hmacCompute:(FREObject)data withHashFunction:(FREObject)hashFunction withKey:(FREObject)keyParam {

    NSLog(@"[ANX] Attempt to acquire input byte array");

    FREByteArray input;
    if (FREAcquireByteArray(data, &input) != FRE_OK) {
        return NULL;
    }

    NSLog(@"[ANX] Attempt to acquire key byte array");

    FREByteArray key;
    if (FREAcquireByteArray(keyParam, &key) != FRE_OK) {
        return NULL;
    }

    NSLog(@"[ANX] Attempt to compute HMAC from '%s' with key '%s'", input.bytes, key.bytes);

    unsigned char* hmac = [self hmacForBytes:input.bytes withLength:input.length withKey:key.bytes withKeyLength:key.length];

    NSLog(@"[ANX] Attempt to convert bytes to HEX string.");

    int length = (int)strlen((char*)hmac);
    unsigned char* digest = [self hexEncodeString:hmac inputLength:length outputLength:&length];

    NSLog(@"[ANX] Attempt to release input byte array");

    if (FREReleaseByteArray(data) != FRE_OK) {
        return NULL;
    }

    NSLog(@"[ANX] Attempt to release key byte array");

    if (FREReleaseByteArray(keyParam) != FRE_OK) {
        return NULL;
    }

    NSLog(@"[ANX] Attempt to create output byte array");

    FREObject result = [ANXOpenSSLConversionRoutines createByteArrayWithLength:length];
    if (result == NULL) {
        return NULL;
    }

    NSLog(@"[ANX] Attempt to acquire output byte array");

    FREByteArray output;
    if (FREAcquireByteArray(result, &output) != FRE_OK) {
        return NULL;
    }

    NSLog(@"[ANX] Attempt to copy encrypted data into output byte array");

    memcpy(output.bytes, digest, length);

    NSLog(@"[ANX] attempt to release output byte array");

    if (FREReleaseByteArray(result) != FRE_OK) {
        return NULL;
    }

    NSLog(@"[ANX] all operations are done");

    return result;
}

@end
