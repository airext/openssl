//
//  ANXOpenSSL+RSA.m
//  OpenSSL
//
//  Created by Max Rozdobudko on 05.12.2019.
//

#import "ANXOpenSSL+RSA.h"
#import "ANXOpenSSLConversionRoutines.h"
#import "ANXOpenSSLUtils.h"
#import "ANXOpenSSLDefer.h"

@implementation ANXOpenSSL (RSA)

- (FREObject)rsaEncrypt:(FREObject)data withPublicKey:(FREObject)key {

    NSLog(@"[ANX] Attempt to read publicKey");

    const unsigned char *publicKey;
    uint32_t publicKeyLength;

    if (FREGetObjectAsUTF8(key, &publicKeyLength, &publicKey) != FRE_OK) {
        return NULL;
    }

    NSLog(@"[ANX] Attempt to acquire input byte array");

    FREByteArray input;
    if (FREAcquireByteArray(data, &input) != FRE_OK) {
        return NULL;
    }

    NSLog(@"[ANX] Attempt to encrypt data");

    int length;
    unsigned char *encrypted = [self rsaEncryptBytes:input.bytes withPublicKey:publicKey outLength:&length];

    anx_defer(^{
        free(encrypted);
    });

    NSLog(@"[ANX] data encrypted with length: %i", length);

    NSLog(@"[ANX] Attempt to release input byte array");

    if (FREReleaseByteArray(data) != FRE_OK) {
        return NULL;
    }

    if (length == -1) {
        NSLog(@"[ANX] decryption failed with error: %s", anx_retrieve_openssl_error_queue());
        return NULL;
    }

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

- (FREObject)rsaDecrypt:(FREObject)data withPrivateKey:(FREObject)key {

    NSLog(@"[ANX] Attempt to read privateKey");

    const unsigned char *privateKey;
    uint32_t keyLength;

    if (FREGetObjectAsUTF8(key, &keyLength, &privateKey) != FRE_OK) {
        return NULL;
    }

    NSLog(@"[ANX] Attempt to acquire input byte array");

    FREByteArray input;
    if (FREAcquireByteArray(data, &input) != FRE_OK) {
        return NULL;
    }

    NSLog(@"[ANX] Attempt to decrypt data");

    int length;

    unsigned char *decrypted = [self rsaDecryptBytes:input.bytes withPrivateKey:privateKey outLength:&length];

    anx_defer(^{
        free(decrypted);
    });

    NSLog(@"[ANX] data decrypted with length: %i", length);

    NSLog(@"[ANX] Attempt to release input byte array");

    if (FREReleaseByteArray(data) != FRE_OK) {
        return NULL;
    }

    if (length == -1) {
        NSLog(@"[ANX] decryption failed with error: %s", anx_retrieve_openssl_error_queue());
        return NULL;
    }

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
