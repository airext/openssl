//
//  ANXOpenSSL+RSA.h
//  OpenSSL
//
//  Created by Max Rozdobudko on 05.12.2019.
//

#import "ANXOpenSSL.h"
#import "FlashRuntimeExtensions.h"

NS_ASSUME_NONNULL_BEGIN

@interface ANXOpenSSL (RSA)

- (FREObject)rsaEncrypt:(FREObject)data withPublicKey:(FREObject)key;
- (FREObject)rsaDecrypt:(FREObject)data withPrivateKey:(FREObject)key;

- (FREObject)verifyCertificate:(FREObject)certificateObject withCertificateFromCertificateAuthority:(FREObject)caCertificateObject;

@end

NS_ASSUME_NONNULL_END
