//
//  ANXOpenSSLDefer.h
//  OpenSSL
//
//  Created by Max Rozdobudko on 05.12.2019.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ANXOpenSSLDefer : NSObject

@property (copy, nonatomic) void (^block)(void);
+ (instancetype)defer:(void (^)(void))block;

@end

void anx_defer(void (^block)(void));

NS_ASSUME_NONNULL_END
