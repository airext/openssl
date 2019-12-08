//
//  ANXOpenSSL+Utils.h
//  OpenSSL
//
//  Created by Max Rozdobudko on 05.12.2019.
//

#import "ANXOpenSSL.h"
#import "FlashRuntimeExtensions.h"

NS_ASSUME_NONNULL_BEGIN

@interface ANXOpenSSL (Utils)

- (FREObject)base64EncodeString:(FREObject)string;
- (FREObject)base64decodeString:(FREObject)string;

- (FREObject)hexEncodeString:(FREObject)string;
- (FREObject)hexDecodeString:(FREObject)string;

@end

NS_ASSUME_NONNULL_END
