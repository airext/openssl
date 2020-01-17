//
//  TestAES.m
//  ANXOpenSSLTest
//
//  Created by Max Rozdobudko on 14.01.2020.
//

#import "TestAES.h"

@implementation TestAES

+ (void)test_ane {

    /* A 256 bit key */
    unsigned char *key = (unsigned char *)"01234567890123456789012345678901";

    /* A 128 bit IV */
    unsigned char *iv = (unsigned char *)"0123456789012345";

    /* Message to be encrypted */
    unsigned char *plaintext = (unsigned char *)"The quick brown fox jumps over the lazy dog";

    int encryptedLength;
    unsigned char* encrypted = [ANXOpenSSL.sharedInstance aesEncryptBytes:plaintext withKey:key withIV:iv outLength:&encryptedLength];

    /* Do something useful with the ciphertext here */
    printf("Ciphertext is:\n");

    int decryptedLength;
    unsigned char* decrypted = [ANXOpenSSL.sharedInstance aesDecryptBytes:encrypted withKey:key withIV:iv outLength:&decryptedLength];

    decrypted[decryptedLength] = '\0';

    printf("Decrypted text is:\n");
    printf("%s\n", decrypted);
}

@end
