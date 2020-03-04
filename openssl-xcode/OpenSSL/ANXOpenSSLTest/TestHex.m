//
//  TestHex.m
//  ANXOpenSSLTest
//
//  Created by Max Rozdobudko on 08.12.2019.
//

#import "TestHex.h"

@implementation TestHex

+ (void)test_ane {

    const unsigned char original[] = "Hello World";

    uint32_t encodedLength;

    unsigned char* encoded = [ANXOpenSSL.sharedInstance hexEncodeString:original inputLength:(int)strlen((const char*)original) outputLength:&encodedLength];

    uint32_t decodedLength;
    unsigned char* decoded = [ANXOpenSSL.sharedInstance hexDecodeString:encoded inputLength:(int)strlen((const char*)encoded) outputLength:&decodedLength];

    printf("encoded = %s\n", encoded);
    printf("decoded = %s\n", decoded);
    printf("decodedLength = %i\n", decodedLength);
}

@end
