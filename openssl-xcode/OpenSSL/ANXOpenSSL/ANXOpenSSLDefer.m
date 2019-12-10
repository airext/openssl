//
//  ANXOpenSSLDefer.m
//  OpenSSL
//
//  Created by Max Rozdobudko on 05.12.2019.
//

#import "ANXOpenSSLDefer.h"

void __xz_defer__(void (^ _Nonnull * _Nonnull operation)(void)) {
    (*operation)();
}
