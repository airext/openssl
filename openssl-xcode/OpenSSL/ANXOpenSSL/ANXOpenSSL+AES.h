//
//  ANXOpenSSL+AES.h
//  OpenSSL
//
//  Created by Max Rozdobudko on 14.01.2020.
//

#import "ANXOpenSSL.h"
#import "FlashRuntimeExtensions.h"

NS_ASSUME_NONNULL_BEGIN

@interface ANXOpenSSL (AES)

- (FREObject)aesEncrypt:(FREObject)data withKey:(FREObject)key withInitialisationVector:(FREObject)iv;
- (FREObject)aesDecrypt:(FREObject)data withKey:(FREObject)key withInitialisationVector:(FREObject)iv;

@end

NS_ASSUME_NONNULL_END
