#pragma once
#include "FlashRuntimeExtensions.h"
#include <openssl/err.h>
#include<string>
class Utils
{

public:

	static FREObject getByteByfferFromCharPointer(char *buffer , int len);
	static FREObject verifyCertificate(FREObject cert1, FREObject cert2);
	static FREObject getOpenSSLVersion();
	static FREObject parseCertificate(FREObject cert);
	static FREObject parseCertificateSerial(FREObject cert);
	static FREObject extractPublicKey(FREObject cert);
	static int Base64Encode(const unsigned char* buffer, int length, char** b64text);
	static FREObject PBKDF2_HMAC_SHA_256(const char* pass, int passSize, const unsigned char* salt, int saltSize, int32_t iterations, uint32_t outputBytes);

private:
	static std::string asn1int(ASN1_INTEGER *bs);
	static std::string asn1string(ASN1_STRING *d);

};
