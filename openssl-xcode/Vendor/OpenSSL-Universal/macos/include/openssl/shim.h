#ifndef OpenSSLShim_h
#define OpenSSLShim_h

#include <openssl/conf.h>
#include <openssl/evp.h>
#include <openssl/err.h>
#include <openssl/bio.h>
#include <openssl/x509.h>
#include <openssl/cms.h>

// Initialize OpenSSL
static inline void OpenSSL_SSL_init(void) {
    SSL_library_init();
    SSL_load_error_strings();
    OPENSSL_config(NULL);
    OpenSSL_add_all_ciphers();
    OPENSSL_add_all_algorithms_noconf();
}

#endif
