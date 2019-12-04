//
//  ANXOpenSSLUtils.c
//  ANXOpenSSLTest
//
//  Created by Max Rozdobudko on 04.12.2019.
//

#include "ANXOpenSSLUtils.h"

RSA* anx_create_rsa_with_public_key(const unsigned char *key) {
    RSA *rsa= NULL;
    BIO *keybio ;
    keybio = BIO_new_mem_buf(key, -1);

    if (keybio == NULL) {
        printf( "Failed to create key BIO");
        return 0;
    }

    rsa = PEM_read_bio_RSA_PUBKEY(keybio, &rsa,NULL, NULL);

    return rsa;
}

RSA* anx_create_rsa_with_private_key(const unsigned char *key) {
    RSA *rsa= NULL;
    BIO *keybio ;
    keybio = BIO_new_mem_buf(key, -1);

    if (keybio == NULL) {
        printf( "Failed to create key BIO");
        return 0;
    }

    rsa = PEM_read_bio_RSAPrivateKey(keybio, &rsa,NULL, NULL);

    return rsa;
}
