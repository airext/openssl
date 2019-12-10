//
//  ANXOpenSSLUtils.c
//  ANXOpenSSLTest
//
//  Created by Max Rozdobudko on 04.12.2019.
//

#import "ANXOpenSSLUtils.h"
#import <assert.h>
#import <CoreFoundation/CoreFoundation.h>

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

#pragma mark - Base64

// Implementation based on https://github.com/mkontsek/openGalaxy (https://github.com/mkontsek/openGalaxy/blob/f2b9e745fef5e5b452c86aa6810abfa2a8698c16/0.14/source/src/common/ssl_evp.c)

int anx_base64_encode(const unsigned char* in, size_t in_len, char**out, size_t *out_len) {
    BIO *b64;
    BIO *mem;
    BUF_MEM *ptr;

    // sanity check input
    if (!in || !in_len || !out || !out_len) {
        return 0;
    }

    // setup BIO's
    b64 = BIO_new(BIO_f_base64());
    mem = BIO_new(BIO_s_mem());

    if (!b64 || !mem) {
        if(b64) {
            BIO_free_all(b64);
        }
        if(mem) {
            BIO_free_all(mem);
        }
        return 0;
    }

    mem = BIO_push(b64, mem);
    BIO_set_flags(mem, BIO_FLAGS_BASE64_NO_NL);

    #pragma GCC diagnostic push
    #pragma GCC diagnostic ignored "-Wunused-value"
    (void)BIO_set_close(mem, BIO_CLOSE); // allways returns 1
    #pragma GCC diagnostic pop

    // encode the input
    if (in_len != BIO_write(mem, in, (int)in_len)) {
        BIO_free_all(mem);
        return 0;
    }

    #pragma GCC diagnostic push
    #pragma GCC diagnostic ignored "-Wunused-value"
    (void)BIO_flush(mem); // not a blocking BIO, safe to ignore
    #pragma GCC diagnostic pop

    // copy encoded output to a memory block
    BIO_get_mem_ptr(mem, &ptr);
    *out_len = ptr->length;
    *out = OPENSSL_malloc(((*out_len) + 1) * sizeof(char));

    if (!*out) {
        BIO_free_all(mem);
        return 0;
    }
    memcpy(*out, ptr->data, *out_len);

    // properly terminate the C string
    *(*out + (*out_len * sizeof(char))) = 0;

    // cleanup and report success to caller
    BIO_free_all(mem);

    return 1;
}

int anx_base64_decode(const char* in, size_t in_len, unsigned char** out, size_t* out_len) {
    BIO *b64;
    BIO *mem;

    // sanity check input
    if (!in || !in_len || !out || !out_len) {
        return 0;
    }

    // setup BIO's
    b64 = BIO_new(BIO_f_base64());
    mem = BIO_new_mem_buf((void *)in, (int)in_len);

    if (!b64 || !mem) {
        if(b64) {
            BIO_free_all(b64);
        }
        if (mem) {
            BIO_free_all(mem);
        }
        return 0;
    }

    mem = BIO_push(b64, mem);
    BIO_set_flags(mem, BIO_FLAGS_BASE64_NO_NL);

    #pragma GCC diagnostic push
    #pragma GCC diagnostic ignored "-Wunused-value"
    (void)BIO_set_close(mem, BIO_CLOSE); // allways returns 1
    #pragma GCC diagnostic pop

    // allocate output buffer
    *out = OPENSSL_malloc(in_len * sizeof(unsigned char));

    // decode input
    if ((*out_len = BIO_read(mem, *out, (int)in_len)) < 1) {
        BIO_free_all(mem);
        return 0;
    }

    // shrink output to fit the reduced size
    *out = OPENSSL_realloc((void *)*out, *out_len * sizeof(unsigned char));

    // cleanup and report success to caller
    BIO_free_all(mem);

    return 1;
}
