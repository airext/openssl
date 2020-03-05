//
//  TestHex.m
//  ANXOpenSSLTest
//
//  Created by Max Rozdobudko on 08.12.2019.
//

#import "TestHex.h"
#import "BytesGenerator.h"

static NSTimer* _timer;

@implementation TestHex

+ (void)test_ane {

    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    } else {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.001 repeats:YES block:^(NSTimer * _Nonnull timer) {
            for (NSInteger i = 0; i < 200; i++) {

                unsigned char* bytes = [BytesGenerator generateBytesWithLength:1024];

                uint32_t encodedLength;
                unsigned char* encoded = [ANXOpenSSL.sharedInstance hexEncodeString:(unsigned char*)bytes inputLength:(int)strlen((const char*)bytes) outputLength:&encodedLength];

                uint32_t decodedLength;
                unsigned char* decoded = [ANXOpenSSL.sharedInstance hexDecodeString:encoded inputLength:(int)strlen((const char*)encoded) outputLength:&decodedLength];

                if (encoded) {
                    free(encoded);
                } else {
                    NSLog(@"encoded is NULL");
                }

                if (decoded) {
                    free(decoded);
                } else {
                    NSLog(@"decoded is NULL");
                }

                free(bytes);
            }
            NSLog(@"tick");
        }];
    }
}

@end
