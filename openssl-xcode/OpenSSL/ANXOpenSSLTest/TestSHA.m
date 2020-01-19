//
//  TestSHA.m
//  ANXOpenSSLTest
//
//  Created by Max Rozdobudko on 19.01.2020.
//

#import "TestSHA.h"
#import "ANXOpenSSL.h"

@implementation TestSHA

+ (void)test_ane {
    unsigned char *plaintext = (unsigned char *)"The quick brown fox jumps over the lazy dog";

    unsigned char *sha = [ANXOpenSSL.sharedInstance sha256FromString:plaintext];

    int length = (int)strlen((char*)sha);
    unsigned char* digest = [ANXOpenSSL.sharedInstance hexEncodeString:sha inputLength:(int)strlen((char*)sha) outputLength:&length];

    NSLog(@"digest is %s", digest);
}

@end
