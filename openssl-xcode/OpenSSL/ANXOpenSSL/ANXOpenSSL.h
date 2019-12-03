//
//  ANXOpenSSL.h
//  OpenSSL
//
//  Created by Max Rozdobudko on 02.12.2019.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ANXOpenSSL : NSObject

#pragma mark - Shared Instance

+ (ANXOpenSSL*)sharedInstance;

@end

NS_ASSUME_NONNULL_END
