//
//  TestBase64.m
//  ANXOpenSSLTest
//
//  Created by Max Rozdobudko on 06.12.2019.
//

#import "TestBase64.h"

@implementation TestBase64

+ (void)test_ane {

    const unsigned char original[] = "Hello World";

    size_t base64Length;
    size_t decodedLength;

    char *base64;
    unsigned char *decoded;

    int r1 = anx_base64_encode(original, strlen((char*)original) + 1, &base64, &base64Length);

    int r2 = anx_base64_decode(base64, strlen((char*)base64), &decoded, &decodedLength);

    printf("%s = %s\n", decoded, original);

    if (r1) {
        free(base64);
    }

    if (r2) {
        free(decoded);
    }
}

@end
