//
//  TestSHA.m
//  ANXOpenSSLTest
//
//  Created by Max Rozdobudko on 19.01.2020.
//

#import "TestSHA.h"
#import "ANXOpenSSL.h"
#import "data.bin.h"

@implementation TestSHA

+ (void)test_ane {
    unsigned char *plaintext = (unsigned char *)"abc123abc123abc123abc123abc123abc123abc123abc123";

//    unsigned char *digest = [ANXOpenSSL.sharedInstance sha256FromString:plaintext];
    uint32_t length;
    unsigned char *digest = [ANXOpenSSL.sharedInstance sha256FromBytes:data_bin inputLength:data_bin_len outputLength:&length];

    NSLog(@"digest is %s", digest);
    NSLog(@"digest length is %lu", length);
}

@end
