//
//  ANXOpenSSL+HEX.h
//  OpenSSL
//
//  Created by Max Rozdobudko on 03.03.2020.
//

#import "ANXOpenSSL.h"
#import "FlashRuntimeExtensions.h"

NS_ASSUME_NONNULL_BEGIN

@interface ANXOpenSSL (HEX)

- (FREObject)hexEncodeString:(FREObject)string;
- (FREObject)hexDecodeString:(FREObject)string;

- (FREObject)hexEncodeBytes:(FREObject)bytes;
- (FREObject)hexDecodeBytes:(FREObject)string;

@end

NS_ASSUME_NONNULL_END
