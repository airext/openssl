//
//  ANXOpenSSL+Base64.h
//  OpenSSL
//
//  Created by Max Rozdobudko on 05.12.2019.
//

#import "ANXOpenSSL.h"
#import "FlashRuntimeExtensions.h"

NS_ASSUME_NONNULL_BEGIN

@interface ANXOpenSSL (Base64)

- (FREObject)base64EncodeString:(FREObject)string;
- (FREObject)base64decodeString:(FREObject)string;

- (FREObject)base64EncodeBytes:(FREObject)bytes;
- (FREObject)base64DecodeBytes:(FREObject)string;

@end

NS_ASSUME_NONNULL_END
