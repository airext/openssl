//
//  ANXOpenSSL+SHA.m
//  OpenSSL
//
//  Created by Max Rozdobudko on 19.01.2020.
//

#import "ANXOpenSSL+SHA.h"
#import "ANXOpenSSLDefer.h"
#import "ANXOpenSSLConversionRoutines.h"

@implementation ANXOpenSSL (SHA)

- (FREObject)computeSHA256:(FREObject)bytes {

    NSLog(@"[ANX] Attempt to acquire input byte array");

    FREByteArray input;
    if (FREAcquireByteArray(bytes, &input) != FRE_OK) {
        return NULL;
    }

    NSLog(@"[ANX] Attempt to compute SHA256 from %s", input.bytes);

    unsigned char* sha = [self sha256FromString:input.bytes];

    int length = (int)strlen((char*)sha);
    unsigned char* digest = [self hexEncodeString:sha inputLength:(int)strlen((char*)sha) outputLength:&length];

    NSLog(@"[ANX] digest computed '%s' with length '%i'", digest, length);

    NSLog(@"[ANX] Attempt to release input byte array");

    if (FREReleaseByteArray(bytes) != FRE_OK) {
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
