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

#pragma mark Base64

- (FREObject)base64EncodeString:(FREObject)string;
- (FREObject)base64decodeString:(FREObject)string;

- (FREObject)base64EncodeBytes:(FREObject)bytes;
- (FREObject)base64DecodeBytes:(FREObject)string;

#pragma mark Hex

- (FREObject)hexEncodeString:(FREObject)string;
- (FREObject)hexDecodeString:(FREObject)string;

- (FREObject)hexEncodeBytes:(FREObject)bytes;
- (FREObject)hexDecodeBytes:(FREObject)string;

@end

NS_ASSUME_NONNULL_END
