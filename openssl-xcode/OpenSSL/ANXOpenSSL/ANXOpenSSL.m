//
//  ANXOpenSSL.m
//  OpenSSL
//
//  Created by Max Rozdobudko on 02.12.2019.
//

#import "ANXOpenSSL.h"
#import "ANXOpenSSLUtils.h"
#import <openssl/opensslv.h>
#import <openssl/pem.h>
#import <openssl/ssl.h>
#import <openssl/rsa.h>
#import <openssl/evp.h>
#import <openssl/bio.h>
#import <openssl/err.h>

@implementation ANXOpenSSL

#pragma mark - Shared Instance

static ANXOpenSSL* _sharedInstance = nil;
+ (ANXOpenSSL*)sharedInstance {
    if (_sharedInstance == nil) {
        _sharedInstance = [[super allocWithZone:NULL] init];

    }
    return _sharedInstance;
}

#pragma mark - Information

- (NSString*)version {
    return @OPENSSL_VERSION_TEXT;
}

#pragma mark - Tests

- (void)rsaEncryptString:(nonnull const unsigned char *)input withPrivateKey:(const unsigned char *)key output:(unsigned char*)output {
    int inputLength = (int)strlen((const char*)input);

    RSA *rsa = anx_create_rsa_with_private_key(key);

    RSA_private_encrypt(inputLength, input, output, rsa, RSA_PKCS1_PADDING);
}

- (void)rsaDecryptString:(nonnull const unsigned char *)input withPublicKey:(const unsigned char*)key output:(unsigned char*)output {
    int inputLength = (int)strlen((const char*)input);

    RSA *rsa = anx_create_rsa_with_public_key(key);

    RSA_public_decrypt(inputLength, input, output, rsa, RSA_PKCS1_PADDING);
}

@end
