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
    unsigned char *plaintext = (unsigned char *)"abc123abc123abc123abc123abc123abc123abc123abc123";

    unsigned char *digest = [ANXOpenSSL.sharedInstance sha256FromString:plaintext];

    NSLog(@"digest is %s", digest);
    NSLog(@"digest length is %lu", strlen((char*)digest));
}

@end
