//
//  ANXOpenSSL.h
//  OpenSSL
//
//  Created by Max Rozdobudko on 02.12.2019.
//

#import <Foundation/Foundation.h>
#import <openssl/opensslv.h>
#import <openssl/pem.h>
#import <openssl/ssl.h>
#import <openssl/rsa.h>
#import <openssl/evp.h>
#import <openssl/bio.h>
#import <openssl/err.h>

NS_ASSUME_NONNULL_BEGIN

@interface ANXOpenSSL : NSObject

#pragma mark - Shared Instance

+ (ANXOpenSSL*)sharedInstance;

#pragma mark - Information

-(NSString*)version;

#pragma mark - RSA

- (int)rsaEncryptString:(nonnull const unsigned char *)input withPrivateKey:(const unsigned char *)key output:(unsigned char*)output;

- (unsigned char*)rsaEncryptBytes:(nonnull const unsigned char *)input withPublicKey:(const unsigned char*)key outLength:(int*)outLength;
- (unsigned char*)rsaDecryptBytes:(nonnull const unsigned char *)input withPrivateKey:(const unsigned char*)key outLength:(int*)outLength;

#pragma mark - Certificate Verification

- (BOOL)verifyCertificate:(const char*)certificate withCertificateAuthorityCertificate:(const char*)caCertificate;

#pragma mark - AES

- (unsigned char*)aesEncryptBytes:(nonnull const unsigned char*)input withLength:(uint32_t)inputLength withKey:(const unsigned char*)key withIV:(const unsigned char*)iv outLength:(uint32_t*)outLength;
- (unsigned char*)aesDecryptBytes:(nonnull const unsigned char*)input withLength:(uint32_t)inputLength withKey:(const unsigned char*)key withIV:(const unsigned char*)iv outLength:(uint32_t*)outLength;

#pragma mark - SHA

- (unsigned char*)sha256FromBytes:(nonnull unsigned const char*)input inputLength:(size_t)inputLength outputLength:(uint32_t*)outputLength;
- (unsigned char*)sha256FromString:(nonnull const unsigned char*)string;

#pragma mark - HMAC

- (unsigned char*)hmacForBytes:(nonnull const unsigned char*)bytes withLength:(int)bytesLength withKey:(const void *)key withKeyLength:(int)keyLength;

#pragma mark - HEX

- (unsigned char*)hexEncodeString:(nonnull const unsigned char*)input inputLength:(uint32_t)inputLength outputLength:(uint32_t*)outputLength;
- (unsigned char*)hexDecodeString:(nonnull const unsigned char*)input inputLength:(uint32_t)inputLength outputLength:(uint32_t*)outputLength;

@end

NS_ASSUME_NONNULL_END
