//
//  TestSHA.m
//  ANXOpenSSLTest
//
//  Created by Max Rozdobudko on 19.01.2020.
//

#import "TestSHA.h"
#import "ANXOpenSSL.h"
#import "data.bin.h"

static NSTimer* _shaTimer;

@implementation TestSHA

+ (void)test_ane {
    if (_shaTimer) {
        [_shaTimer invalidate];
        _shaTimer = nil;
    } else {
        _shaTimer = [NSTimer scheduledTimerWithTimeInterval:0.001 repeats:YES block:^(NSTimer * _Nonnull timer) {
            for (NSInteger i = 0; i < 200; i++) {
                uint32_t length;
                unsigned char *digest = [ANXOpenSSL.sharedInstance sha256FromBytes:data_bin inputLength:data_bin_len outputLength:&length];
                if (digest) {
                    free(digest);
                }
            }
            NSLog(@"tick");
        }];
    }
}

@end
