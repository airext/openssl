//
//  TestHMAC.m
//  ANXOpenSSLTest
//
//  Created by Max Rozdobudko on 21.01.2020.
//

#import "TestHMAC.h"
#import "ANXOpenSSL.h"

@implementation TestHMAC

+ (void)test_ane {
    unsigned char *plaintext = (unsigned char *)"The quick brown fox jumps over the lazy dog";

    unsigned char *key = (void*)"secret";

    unsigned char* hmac = [ANXOpenSSL.sharedInstance hmacForBytes:plaintext withLength:(int)strlen((const char*)plaintext) withKey:key withKeyLength:(int)strlen((const char*)key)];

    int length = (int)strlen((char*)hmac);
    unsigned char* digest = [ANXOpenSSL.sharedInstance hexEncodeString:hmac inputLength:(int)strlen((char*)hmac) outputLength:&length];

    NSLog(@"hmac = '%s'", digest);
}

@end
