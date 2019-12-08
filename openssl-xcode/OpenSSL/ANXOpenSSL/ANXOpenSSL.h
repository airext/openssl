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

#pragma mark RSA

- (int)rsaEncryptString:(nonnull const unsigned char *)input withPrivateKey:(const unsigned char *)key output:(unsigned char*)output;

- (unsigned char*)rsaEncryptBytes:(nonnull const unsigned char *)input withPublicKey:(const unsigned char*)key outLength:(int*)outLength;
- (unsigned char*)rsaDecryptBytes:(nonnull const unsigned char *)input withPrivateKey:(const unsigned char*)key outLength:(int*)outLength;

- (unsigned char*)hexDecodeString:(nonnull const unsigned char*)input inputLength:(uint32_t)inputLength outputLength:(uint32_t*)outputLength;

@end

NS_ASSUME_NONNULL_END
