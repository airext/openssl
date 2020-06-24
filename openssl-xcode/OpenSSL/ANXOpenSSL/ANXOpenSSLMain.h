//
//  ANXOpenSSLMain.hpp
//  OpenSSL
//
//  Created by Max Rozdobudko on 6/21/20.
//

#ifndef ANXOpenSSLMain_hpp
#define ANXOpenSSLMain_hpp

#include <stdio.h>
#include "FlashRuntimeExtensions.h"

#ifdef __cplusplus
extern "C" {
#endif

FREObject ANXOpenSSLMain_rsaEncrypt(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject ANXOpenSSLMain_rsaDecrypt(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);

FREObject ANXOpenSSLMain_aesEncrypt(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject ANXOpenSSLMain_aesDecrypt(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);

FREObject ANXOpenSSLMain_computeSha256(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);

FREObject ANXOpenSSLMain_hmacCompute(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);

FREObject ANXOpenSSLMain_getOpenSSLVersion(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject ANXOpenSSLMain_verifyCertificate(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);

#ifdef __cplusplus
}
#endif

#endif /* ANXOpenSSLMain_hpp */
