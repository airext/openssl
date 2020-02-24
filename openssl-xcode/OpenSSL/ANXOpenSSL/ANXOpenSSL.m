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
        OpenSSL_add_all_algorithms();
        OpenSSL_add_all_ciphers();
        OpenSSL_add_all_digests();
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

- (BOOL)verifyCertificate:(const char*)certificate withCertificateAuthorityCertificate:(const char*)caCertificate {

    BIO *b = BIO_new(BIO_s_mem());
    BIO_puts(b, caCertificate);
    X509 * issuer = PEM_read_bio_X509(b, NULL, NULL, NULL);
    EVP_PKEY *signing_key=X509_get_pubkey(issuer);

    BIO *c = BIO_new(BIO_s_mem());
    BIO_puts(c, certificate);
    X509 * x509 = PEM_read_bio_X509(c, NULL, NULL, NULL);

    int result = X509_verify(x509, signing_key);

    EVP_PKEY_free(signing_key);
    BIO_free(b);
    BIO_free(c);
    X509_free(x509);
    X509_free(issuer);

    return result > 0;
}

#pragma mark - AES

- (unsigned char*)aesEncryptBytes:(nonnull const unsigned char*)input withKey:(const unsigned char*)key withIV:(const unsigned char*)iv outLength:(int*)outLength {

    int inputLength = (int)strlen((char*)input);

    EVP_CIPHER_CTX *ctx;

    int len;

    int ciphertext_len;

    unsigned char ciphertext[128];

    /* Create and initialise the context */
    if (!(ctx = EVP_CIPHER_CTX_new())) {
        NSLog(@"[ANX] ERROR: aesEncryptBytes: %s", ERR_error_string(ERR_get_error(), NULL));
    }

    /*
     * Initialise the encryption operation. IMPORTANT - ensure you use a key
     * and IV size appropriate for your cipher
     * In this example we are using 256 bit AES (i.e. a 256 bit key). The
     * IV size for *most* modes is the same as the block size. For AES this
     * is 128 bits
     */
    if (EVP_EncryptInit_ex(ctx, EVP_aes_256_cbc(), NULL, key, iv) != 1) {
        NSLog(@"[ANX] ERROR: aesEncryptBytes: %s", ERR_error_string(ERR_get_error(), NULL));
    }

    /*
     * Provide the message to be encrypted, and obtain the encrypted output.
     * EVP_EncryptUpdate can be called multiple times if necessary
     */
    if (EVP_EncryptUpdate(ctx, ciphertext, &len, input, inputLength) != 1) {
        NSLog(@"[ANX] ERROR: aesEncryptBytes: %s", ERR_error_string(ERR_get_error(), NULL));
    }

    ciphertext_len = len;

    /*
     * Finalise the encryption. Further ciphertext bytes may be written at
     * this stage.
     */
    if (EVP_EncryptFinal_ex(ctx, ciphertext + len, &len) != 1) {
        NSLog(@"[ANX] ERROR: aesEncryptBytes: %s", ERR_error_string(ERR_get_error(), NULL));
    }

    ciphertext_len += len;

    /* Clean up */
    EVP_CIPHER_CTX_free(ctx);

    *outLength = ciphertext_len;

    unsigned char* returnValue = malloc(ciphertext_len);
    memcpy(returnValue, ciphertext, ciphertext_len);

    return returnValue;
}

- (unsigned char*)aesDecryptBytes:(nonnull const unsigned char*)input withKey:(const unsigned char*)key withIV:(const unsigned char*)iv outLength:(int*)outLength {

    int inputLength = (int)strlen((char*)input);

    EVP_CIPHER_CTX *ctx;

    int len;

    int plaintext_len;

    unsigned char plaintext[128];

    /* Create and initialise the context */
    if (!(ctx = EVP_CIPHER_CTX_new())) {
        NSLog(@"[ANX] ERROR: aesDecryptBytes: %s", ERR_error_string(ERR_get_error(), NULL));
    }

    /*
     * Initialise the decryption operation. IMPORTANT - ensure you use a key
     * and IV size appropriate for your cipher
     * In this example we are using 256 bit AES (i.e. a 256 bit key). The
     * IV size for *most* modes is the same as the block size. For AES this
     * is 128 bits
     */
    if (EVP_DecryptInit_ex(ctx, EVP_aes_256_cbc(), NULL, key, iv) != 1) {
        NSLog(@"[ANX] ERROR: aesDecryptBytes: %s", ERR_error_string(ERR_get_error(), NULL));
    }

    /*
     * Provide the message to be decrypted, and obtain the plaintext output.
     * EVP_DecryptUpdate can be called multiple times if necessary.
     */
    if (EVP_DecryptUpdate(ctx, plaintext, &len, input, inputLength) != 1) {
        NSLog(@"[ANX] ERROR: aesDecryptBytes: %s", ERR_error_string(ERR_get_error(), NULL));
    }

    plaintext_len = len;

    /*
     * Finalise the decryption. Further plaintext bytes may be written at
     * this stage.
     */
    if (EVP_DecryptFinal_ex(ctx, plaintext + len, &len) != 1) {
        NSLog(@"[ANX] ERROR: aesDecryptBytes: %s", ERR_error_string(ERR_get_error(), NULL));
    }

    plaintext_len += len;

    /* Clean up */
    EVP_CIPHER_CTX_free(ctx);

    *outLength = plaintext_len;

    unsigned char* returnValue = malloc(plaintext_len);
    memcpy(returnValue, plaintext, plaintext_len);

    return returnValue;
}

#pragma mark - SHA

- (unsigned char*)sha256FromBytes:(nonnull unsigned const char*)input inputLength:(size_t)inputLength outputLength:(uint32_t*)outputLength {
    unsigned char md_value[SHA256_DIGEST_LENGTH];
    unsigned int md_len;

    const EVP_MD *md = EVP_sha256();

    EVP_MD_CTX* ctx = EVP_MD_CTX_create();
    EVP_DigestInit_ex(ctx, md, NULL);
    EVP_DigestUpdate(ctx, input, inputLength);
    EVP_DigestFinal_ex(ctx, md_value, &md_len);
    EVP_MD_CTX_cleanup(ctx);

    *outputLength = SHA256_DIGEST_LENGTH * 2;

    char* buffer = malloc(sizeof(unsigned char*) * (*outputLength));

    unsigned int i, j;
    for (i = 0, j = 0; i < md_len; i++, j+=2) {
        sprintf(buffer + j, "%02x", md_value[i]);
    }

    return (unsigned char*)buffer;
}

- (unsigned char*)sha256FromString:(nonnull const unsigned char*)string {

    unsigned char md_value[SHA256_DIGEST_LENGTH];
    unsigned int md_len;

    const EVP_MD *md = EVP_sha256();

    EVP_MD_CTX* ctx = EVP_MD_CTX_create();
    EVP_DigestInit_ex(ctx, md, NULL);
    EVP_DigestUpdate(ctx, string, strlen((char*)string));
    EVP_DigestFinal_ex(ctx, md_value, &md_len);
    EVP_MD_CTX_cleanup(ctx);

    char* buffer = malloc(sizeof(unsigned char*) * SHA256_DIGEST_LENGTH * 2);

    unsigned int i, j;
    for (i = 0, j = 0; i < md_len; i++, j+=2) {
        sprintf(buffer + j, "%02x", md_value[i]);
    }

    return (unsigned char*)buffer;
}

#pragma mark - HMAC

- (unsigned char*)hmacForBytes:(nonnull const unsigned char*)bytes withLength:(int)bytesLength withKey:(const void *)key withKeyLength:(int)keyLength {
    return HMAC(EVP_sha1(), key, keyLength, bytes, bytesLength, NULL, NULL);
}

#pragma mark - HEX

- (unsigned char*)hexEncodeString:(nonnull const unsigned char*)input inputLength:(uint32_t)inputLength outputLength:(uint32_t*)outputLength {
    NSLog(@"[ANX] input: %s", input);

    *outputLength = inputLength * 2;

    char* output = malloc(sizeof(unsigned char*) * (*outputLength));

    unsigned int i, j;
    for (i = 0, j = 0; i < inputLength; i++, j+=2) {
        sprintf(output + j, "%02x", input[i]);
    }

    NSLog(@"[ANX] output: %s", output);

    return (unsigned char*)output;
}

- (unsigned char*)hexDecodeString:(nonnull const unsigned char*)input inputLength:(uint32_t)inputLength outputLength:(uint32_t*)outputLength {

    NSLog(@"[ANX] input: %s", input);

    if (inputLength % 2 != 0) {
        NSLog(@"[ANX] input has odd length, return NULL");
        return NULL;
    }

    *outputLength = inputLength / 2;
    unsigned char* output = malloc(sizeof(unsigned char*) * (*outputLength));

    char buffer[2];

    for (int i = 0, j = 0; i < *outputLength; i++, j += 2) {
        buffer[0] = input[j];
        buffer[1] = input[j+1];
        int hex = 0;
        sscanf(buffer, "%x", &hex);
        output[i] = (unsigned char)hex;
    }

    NSLog(@"[ANX] output: %s", output);

    return output;
}

@end
