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

#pragma mark - Information

-(NSString*)version;

#pragma mark

- (void)rsaEncryptString:(nonnull const unsigned char *)input withPrivateKey:(const unsigned char *)key output:(unsigned char*)output;
- (void)rsaDecryptString:(nonnull const unsigned char *)input withPublicKey:(const unsigned char*)key output:(unsigned char*)output;

@end

NS_ASSUME_NONNULL_END
