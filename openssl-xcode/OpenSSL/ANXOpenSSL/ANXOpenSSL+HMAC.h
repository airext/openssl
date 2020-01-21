//
//  ANXOpenSSL+HMAC.h
//  OpenSSL
//
//  Created by Max Rozdobudko on 21.01.2020.
//

#import <Foundation/Foundation.h>
#import "FlashRuntimeExtensions.h"
#import "ANXOpenSSL.h"

NS_ASSUME_NONNULL_BEGIN

@interface ANXOpenSSL (HMAC)

- (FREObject)hmacCompute:(FREObject)data withHashFunction:(FREObject)hashFunction withKey:(FREObject)key;

@end

NS_ASSUME_NONNULL_END
