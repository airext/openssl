//
//  ANXOpenSSLDefer.m
//  OpenSSL
//
//  Created by Max Rozdobudko on 05.12.2019.
//

#import "ANXOpenSSLDefer.h"

@implementation ANXOpenSSLDefer

+ (instancetype)defer:(void (^)(void))block {
    ANXOpenSSLDefer* defer =  [[ANXOpenSSLDefer alloc] init];
    defer.block = block;
    return defer;
}

- (void)dealloc {
    if (_block) {
        _block();
    }
}

@end

void anx_defer(void (^block)(void)) {
    // Fool the compiler into not releasing the AIDefer object immediately
    static ANXOpenSSLDefer* __weak d;
    d = [ANXOpenSSLDefer defer:block];
}
