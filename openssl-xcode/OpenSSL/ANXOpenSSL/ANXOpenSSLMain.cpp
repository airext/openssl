//
//  ANXOpenSSLMain.cpp
//  OpenSSL
//
//  Created by Max Rozdobudko on 6/21/20.
//

#include "ANXOpenSSLMain.h"
#include "RSACrypt.h"
#include "AESCrypt.h"
#include "DigestSha256.h"
#include "HmacCompute.h"
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

    FREObject ANXOpenSSLMain_aesEncrypt(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
        os_log(OS_LOG_DEFAULT, "[ANX] ANXOpenSSLMain_aesEncrypt");
        AESCrypt *ac = new AESCrypt();
        FREObject o = ac->AesEncrypt(argv[0], argv[1], argv[2]);
        delete ac;
        return o;
    }

    FREObject ANXOpenSSLMain_aesDecrypt(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
        os_log(OS_LOG_DEFAULT, "[ANX] ANXOpenSSLMain_aesDecrypt");
        AESCrypt *ac = new AESCrypt();
        FREObject o = ac->AesDecrypt(argv[0], argv[1], argv[2]);
        delete ac;
        return o;
    }

#pragma mark - SHA

    FREObject ANXOpenSSLMain_computeSha256(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
        os_log(OS_LOG_DEFAULT, "[ANX] ANXOpenSSLMain_computeSha256");
        //memcpy(byteArray.bytes, nativeString, 12);
        DigestSha256 *dig = new DigestSha256();
        FREObject o = dig->computeSHA256(argv[0]);
        delete dig;
        return o;
    }

#pragma mark - HMAC

    FREObject ANXOpenSSLMain_hmacCompute(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
        os_log(OS_LOG_DEFAULT, "[ANX] ANXOpenSSLMain_hmacCompute");
        HmacCompute *hc = new HmacCompute();
        FREObject o = hc->hmacCompute(argv[0], argv[1]);
        delete hc;
        return o;
    }

#pragma mark - Utils

    FREObject ANXOpenSSLMain_getOpenSSLVersion(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
        os_log(OS_LOG_DEFAULT, "[ANX] ANXOpenSSLMain_getOpenSSLVersion");
        return Utils::getOpenSSLVersion();
    }

    FREObject ANXOpenSSLMain_verifyCertificate(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
        os_log(OS_LOG_DEFAULT, "[ANX] ANXOpenSSLMain_verifyCertificate");
        FREObject o = Utils::verifyCertificate(argv[1], argv[0]);
        return o;
    }

    FREObject ANXOpenSSLMain_extractPublicKey(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
        os_log(OS_LOG_DEFAULT, "[ANX] ANXOpenSSLMain_extractPublicKey");
        return Utils::extractPublicKey(argv[0]);
    }

    FREObject ANXOpenSSLMain_parseCertificate(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
        os_log(OS_LOG_DEFAULT, "[ANX] ANXOpenSSLMain_parseCertificate");
        return Utils::parseCertificate(argv[0]);

    }

    FREObject ANXOpenSSLMain_parseCertificateSerial(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
        os_log(OS_LOG_DEFAULT, "[ANX] ANXOpenSSLMain_parseCertificateSerial");
        return Utils::parseCertificateSerial(argv[0]);
    }

    FREObject ANXOpenSSLMain_PBKDF2_HMAC_SHA_256(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
        os_log(OS_LOG_DEFAULT, "[ANX] ANXOpenSSLMain_PBKDF2_HMAC_SHA_256");
        FREByteArray pass;
        FREByteArray salt;
        FREByteArray ivByteArray;
        int retVal;

        retVal = FREAcquireByteArray(argv[0], &pass);
        if ((FRE_OK != retVal))
            return NULL;
        retVal = FREAcquireByteArray(argv[1], &salt);
        if ((FRE_OK != retVal))
            return NULL;
        FREReleaseByteArray(argv[0]);
        FREReleaseByteArray(argv[1]);
        uint32_t iterationCount;
        uint32_t outputCount;

        FREResult result = FREGetObjectAsUint32(argv[2], &iterationCount);
        if ((FRE_OK != retVal))
            return NULL;
        result = FREGetObjectAsUint32(argv[3], &outputCount);
        if ((FRE_OK != retVal))
            return NULL;

        return Utils::PBKDF2_HMAC_SHA_256((const char *)pass.bytes,pass.length,salt.bytes,salt.length,iterationCount,outputCount);
    }

}
