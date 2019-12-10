//
//  ANXOpenSSLUtils.h
//  ANXOpenSSLTest
//
//  Created by Max Rozdobudko on 04.12.2019.
//

#ifndef ANXOpenSSLUtils_h
#define ANXOpenSSLUtils_h

#import <openssl/opensslv.h>
#import <openssl/pem.h>
#import <openssl/ssl.h>
#import <openssl/rsa.h>
#import <openssl/evp.h>
#import <openssl/bio.h>
#import <openssl/err.h>

RSA* anx_create_rsa_with_public_key(const unsigned char *key);
RSA* anx_create_rsa_with_private_key(const unsigned char *key);

char* anx_retrieve_openssl_error_queue (void);

int anx_base64_encode(const unsigned char* in, size_t in_len, char**out, size_t *out_len);
int anx_base64_decode(const char* in, size_t in_len, unsigned char** out, size_t* out_len);

#endif /* ANXOpenSSLUtils_h */
