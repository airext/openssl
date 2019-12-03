//
//  ANXOpenSSL.m
//  OpenSSL
//
//  Created by Max Rozdobudko on 02.12.2019.
//

#import "ANXOpenSSL.h"

@implementation ANXOpenSSL

#pragma mark - Shared Instance

static ANXOpenSSL* _sharedInstance = nil;
+ (ANXOpenSSL*)sharedInstance {
    if (_sharedInstance == nil) {
        _sharedInstance = [[super allocWithZone:NULL] init];

    }
    return _sharedInstance;
}

@end
