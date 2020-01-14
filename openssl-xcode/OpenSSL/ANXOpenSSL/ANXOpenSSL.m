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

#pragma mark - Hex

- (unsigned char*)hexEncodeString:(nonnull const unsigned char*)input inputLength:(uint32_t)inputLength outputLength:(uint32_t*)outputLength {
    NSLog(@"[ANX] input: %s", input);

    *outputLength = inputLength * 2;
    unsigned char* output = malloc(sizeof(unsigned char*) * *outputLength + 1);

    char character;
    char buffer[3];
//    size_t bufferLength;
//    unsigned int hex;

    for (int i = 0, j = 0; i < inputLength; i++, j += 2) {


        NSLog(@"[ANX] input[i]=%c", input[i]);
//        NSLog(@"[ANX] &input[i]=%s", &input[i]);
//        buffer = strtol((const char*)&input[i], NULL, 16);
        character = input[i];
        NSLog(@"[ANX] character:%s", &character);
//        sscanf(&buffer, "%02x", &hex);
        printf("vvv\n");
        printf("%02x", input[i]);
        printf("^^^\n");
        size_t len = snprintf(buffer, 3, "%02x", input[i]);
        NSLog(@"[ANX] len: %zu", len);
        NSLog(@"[ANX] buffer: %s", buffer);
        NSLog(@"[ANX] buffer: %c", buffer[0]);
        NSLog(@"[ANX] buffer: %c", buffer[1]);
//        NSLog(@"[ANX] hex: %i", hex);
        NSLog(@"[ANX] output so far: %s", output);
        output[j] = buffer[0];
        output[j+1] = buffer[1];
    }

//    NSMutableString *hex = [NSMutableString new];
//    for (NSInteger i = 0; i < inputLength; i++) {
//        [hex appendFormat:@"%02x", input[i]];
//        NSLog(@"[ANX] input[i]=%c", input[i]);
//        NSLog(@"[ANX] hex so far: %@", hex);
//    }

    output[*outputLength] = '\0';

    NSLog(@"[ANX] output: %s", output);

    return output;
}

- (unsigned char*)hexDecodeString:(nonnull const unsigned char*)input inputLength:(uint32_t)inputLength outputLength:(uint32_t*)outputLength {

    NSLog(@"[ANX] input: %s", input);

    if (inputLength % 2 != 0) {
        NSLog(@"[ANX] input has odd length, return NULL");
        return NULL;
    }

    *outputLength = inputLength / 2;
    unsigned char* output = malloc(sizeof(unsigned char*) * *outputLength + 1);

    char buffer[2];

    for (int i = 0, j = 0; i < *outputLength; i++, j += 2) {
        buffer[0] = input[j];
        buffer[1] = input[j+1];
        int hex = 0;
        sscanf(buffer, "%x", &hex);
        output[i] = (unsigned char)hex;
    }

    output[*outputLength] = '\0';

    NSLog(@"[ANX] output: %s", output);

    return output;
}

@end
