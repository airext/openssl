#pragma once
#include "FlashRuntimeExtensions.h"
class RSACrypt
{

public:
	FREObject RSAEncrypt(FREObject data, FREObject key);
	FREObject RSADecrypt(FREObject data, FREObject key);

private:
	FREObject RSAEncrypt(unsigned char * data, int datalen, unsigned char * key, int keyLen);
	FREObject RSADecrypt(unsigned char * data, int datalen, unsigned char * key, int keyLen);

};

