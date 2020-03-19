//
//  ANXOpenSSL+AES.m
//  OpenSSL
//
//  Created by Max Rozdobudko on 14.01.2020.
//

#import "ANXOpenSSL+AES.h"
#import "ANXOpenSSLConversionRoutines.h"
#import "ANXOpenSSLUtils.h"
#import "ANXOpenSSLDefer.h"

@implementation ANXOpenSSL (AES)

- (FREObject)aesEncrypt:(FREObject)data withKey:(FREObject)keyParam withInitialisationVector:(FREObject)ivParam {

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

    NSLog(@"[ANX] Attempt to acquire iv byte array");

    FREByteArray iv;
    if (FREAcquireByteArray(ivParam, &iv) != FRE_OK) {
        return NULL;
    }

    NSLog(@"[ANX] Attempt to encrypt data '%s' with key '%s' and with iv '%s'", input.bytes, key.bytes, iv.bytes);

    uint32_t length;
    unsigned char *encrypted = [self aesEncryptBytes:input.bytes withLength:input.length withKey:key.bytes withIV:iv.bytes outLength:&length];

    NSLog(@"[ANX] Attempt to release input byte array");

    if (FREReleaseByteArray(data) != FRE_OK) {
        return NULL;
    }

    NSLog(@"[ANX] Attempt to release key byte array");

    if (FREReleaseByteArray(keyParam) != FRE_OK) {
        return NULL;
    }

    NSLog(@"[ANX] Attempt to release iv byte array");

    if (FREReleaseByteArray(ivParam) != FRE_OK) {
        return NULL;
    }

    if (!encrypted) {
        NSLog(@"[ANX] Encryption failed with error: %s", anx_retrieve_openssl_error_queue());
        return NULL;
    }

    defer(^{
        free(encrypted);
    });

    NSLog(@"[ANX] data encrypted '%s' with length: %i", encrypted, length);

    NSLog(@"[ANX] Attempt to create output byte array");

    FREObject result = [ANXOpenSSLConversionRoutines createByteArrayWithLength:(int32_t)length];
    if (result == NULL) {
        return NULL;
    }

    NSLog(@"[ANX] Attempt to acquire output byte array");

    FREByteArray output;
    if (FREAcquireByteArray(result, &output) != FRE_OK) {
        return NULL;
    }

    NSLog(@"[ANX] Attempt to copy encrypted data into output byte array");

    memcpy(output.bytes, encrypted, length);

    NSLog(@"[ANX] attempt to release output byte array");

    if (FREReleaseByteArray(result) != FRE_OK) {
        return NULL;
    }

    NSLog(@"[ANX] all operations are done");

    return result;
}

- (FREObject)aesDecrypt:(FREObject)data withKey:(FREObject)keyParam withInitialisationVector:(FREObject)ivParam {

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

    NSLog(@"[ANX] Attempt to acquire iv byte array");

    FREByteArray iv;
    if (FREAcquireByteArray(ivParam, &iv) != FRE_OK) {
        return NULL;
    }

    NSLog(@"[ANX] Attempt to decrypt data '%s' with key '%s' and with iv '%s'", input.bytes, key.bytes, iv.bytes);

    uint32_t length;
    unsigned char *decrypted = [self aesDecryptBytes:input.bytes withLength:input.length withKey:key.bytes withIV:iv.bytes outLength:&length];

    NSLog(@"[ANX] Attempt to release input byte array");

    if (FREReleaseByteArray(data) != FRE_OK) {
        return NULL;
    }

    NSLog(@"[ANX] Attempt to release key byte array");

    if (FREReleaseByteArray(keyParam) != FRE_OK) {
        return NULL;
    }

    NSLog(@"[ANX] Attempt to release iv byte array");

    if (FREReleaseByteArray(ivParam) != FRE_OK) {
        return NULL;
    }

    if (!decrypted) {
        NSLog(@"[ANX] decryption failed with error: %s", anx_retrieve_openssl_error_queue());
        return NULL;
    }

    defer(^{
        free(decrypted);
    });

    NSLog(@"[ANX] data decrypted '%s' with length: %i", decrypted, length);

    NSLog(@"[ANX] Attempt to create output byte array");

    FREObject result = [ANXOpenSSLConversionRoutines createByteArrayWithLength:(int32_t)length];
    if (result == NULL) {
        return NULL;
    }

    NSLog(@"[ANX] Attempt to acquire output byte array");

    FREByteArray output;
    if (FREAcquireByteArray(result, &output) != FRE_OK) {
        return NULL;
    }

    NSLog(@"[ANX] Attempt to copy encrypted data into output byte array");

    memcpy(output.bytes, decrypted, length);

    NSLog(@"[ANX] attempt to release output byte array");

    if (FREReleaseByteArray(result) != FRE_OK) {
        return NULL;
    }

    NSLog(@"[ANX] all operations are done");

    return result;
}

@end
