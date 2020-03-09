//
//  BytesGenerator.m
//  ANXOpenSSLTest
//
//  Created by Max Rozdobudko on 04.03.2020.
//

#import "BytesGenerator.h"

@implementation BytesGenerator

+ (unsigned char*)generateBytesWithLength:(size_t)length {
    unsigned char *buffer = malloc(length);

    for (size_t i = 0; i < length; i++) {
        unsigned char byte = arc4random();
        if (i == 0 && byte == 0) {
            byte = 42;
        }
        buffer[i] = byte;
//        NSLog(@"buffer[%i] = %u", i, buffer[i]);
    }

    return buffer;
}

@end
