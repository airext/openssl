//
//  ANXOpenSSL+SHA.h
//  OpenSSL
//
//  Created by Max Rozdobudko on 19.01.2020.
//

#import <Foundation/Foundation.h>

#import "ANXOpenSSL.h"
#import "FlashRuntimeExtensions.h"

NS_ASSUME_NONNULL_BEGIN

@interface ANXOpenSSL (SHA)

- (FREObject)computeSHA256:(FREObject)bytes;

@end

NS_ASSUME_NONNULL_END
