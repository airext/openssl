//
//  ANXOpenSSL.m
//  OpenSSL
//
//  Created by Max Rozdobudko on 02.12.2019.
//

#import "ANXOpenSSL.h"
#import "ANXOpenSSLUtils.h"

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

#pragma mark - RSA

- (int)rsaEncryptString:(nonnull const unsigned char *)input withPrivateKey:(const unsigned char *)key output:(unsigned char*)output {
    int inputLength = (int)strlen((const char*)input);

    RSA *rsa = anx_create_rsa_with_private_key(key);

    return RSA_private_encrypt(inputLength, input, output, rsa, RSA_PKCS1_PADDING);
}


- (unsigned char*)rsaEncryptBytes:(nonnull const unsigned char *)input withPublicKey:(const unsigned char*)key outLength:(int*)outLength {
    RSA *rsa = anx_create_rsa_with_public_key(key);

    int rsaSize = RSA_size(rsa);

    unsigned char *output = malloc(rsaSize);

    *outLength = RSA_public_encrypt((int)strlen((const char*)input), input, output, rsa, RSA_PKCS1_PADDING);

    if (*outLength == -1) {
        NSLog(@"[ANX] ERROR: RSA_public_encrypt: %s", ERR_error_string(ERR_get_error(), NULL));
    }

    RSA_free(rsa);

    return output;
}

- (unsigned char*)rsaDecryptBytes:(nonnull const unsigned char *)input withPrivateKey:(const unsigned char*)key outLength:(int*)outLength {
    RSA *rsa = anx_create_rsa_with_private_key(key);

    int rsaSize = RSA_size(rsa);

    unsigned char *output = malloc(rsaSize);

    *outLength = RSA_private_decrypt(rsaSize, input, output, rsa, RSA_PKCS1_PADDING);

    if (*outLength == -1) {
        NSLog(@"[ANX] ERROR: RSA_private_decrypt: %s", ERR_error_string(ERR_get_error(), NULL));
    }

    RSA_free(rsa);

    return output;
}

@end
