//
//  BytesGenerator.h
//  ANXOpenSSLTest
//
//  Created by Max Rozdobudko on 04.03.2020.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BytesGenerator : NSObject

+ (unsigned char*)generateBytesWithLength:(size_t)length;

@end

NS_ASSUME_NONNULL_END
