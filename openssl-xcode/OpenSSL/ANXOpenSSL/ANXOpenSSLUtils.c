//
//  ANXOpenSSLUtils.c
//  ANXOpenSSLTest
//
//  Created by Max Rozdobudko on 04.12.2019.
//

#include "ANXOpenSSLUtils.h"

RSA* anx_create_rsa_with_public_key(const unsigned char *key) {
    BIO *bio = BIO_new_mem_buf(key, -1); // -1: assume string is null terminated

    BIO_set_flags(bio, BIO_FLAGS_BASE64_NO_NL); // NO NL

    RSA *rsa = PEM_read_bio_RSA_PUBKEY(bio, NULL, NULL, NULL);
    if (!rsa) {
        printf("[ANX] ERROR: Could not load PUBLIC KEY!  PEM_read_bio_RSA_PUBKEY FAILED: %s", ERR_error_string(ERR_get_error(), NULL)) ;
    }

    BIO_free(bio);

    return rsa;
}

RSA* anx_create_rsa_with_private_key(const unsigned char *key) {
    BIO *bio = BIO_new_mem_buf(key, -1);

    RSA *rsa = PEM_read_bio_RSAPrivateKey(bio, NULL, NULL, NULL);

    if (!rsa) {
        printf("[ANX] ERROR: Could not load PRIVATE KEY!  PEM_read_bio_RSAPrivateKey FAILED: %s", ERR_error_string(ERR_get_error(), NULL));
    }

    BIO_free(bio);

    return rsa;
}

char* anx_retrieve_openssl_error_queue (void) {
    BIO *bio = BIO_new (BIO_s_mem ());
    ERR_print_errors (bio);
    char *buf = NULL;
    size_t len = BIO_get_mem_data (bio, &buf);
    char *ret = (char *) calloc (1, 1 + len);
    if (ret)
    memcpy (ret, buf, len);
    BIO_free (bio);
    return ret;
}
