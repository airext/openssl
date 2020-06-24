//
//  ANXOpenSSLMain.cpp
//  OpenSSL
//
//  Created by Max Rozdobudko on 6/21/20.
//

#include "ANXOpenSSLMain.h"
#include "RSACrypt.h"
#include "AESCrypt.h"
#include "Utils.h"
#include <os/log.h>

extern "C" {

# pragma mark - RSA

    FREObject ANXOpenSSLMain_rsaEncrypt(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
        os_log(OS_LOG_DEFAULT, "[ANX] ANXOpenSSLMain_rsaEncrypt");
        RSACrypt *rs = new RSACrypt();
        os_log(OS_LOG_DEFAULT, "[ANX] rs = %p", rs);
        FREObject o = rs->RSAEncrypt(argv[0], argv[1]);
        os_log(OS_LOG_DEFAULT, "[ANX] o = %p", o);
        printf("[ANX] o = %p", o);
        delete rs;

        return o;

    }

    FREObject ANXOpenSSLMain_rsaDecrypt(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {

        RSACrypt *rs = new RSACrypt();

        FREObject o = rs->RSADecrypt(argv[0], argv[1]);

        delete rs;

        return o;

    }

# pragma mark - AES

    FREObject aesEncrypt(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
        AESCrypt *ac = new AESCrypt();

        FREObject o = ac->AesEncrypt(argv[0], argv[1], argv[2]);
        delete ac;

        return o;
    }

    FREObject aesDecrypt(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {

        AESCrypt *ac = new AESCrypt();
        FREObject o = ac->AesDecrypt(argv[0], argv[1], argv[2]);
        delete ac;

        return o;
    }

}
