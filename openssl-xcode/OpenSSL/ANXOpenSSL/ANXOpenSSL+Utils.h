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

@end

NS_ASSUME_NONNULL_END
