#pragma once
#include "FlashRuntimeExtensions.h"

class AESCrypt
{
public:
	FREObject AesEncrypt(FREObject data, FREObject key, FREObject iv);
	FREObject AesDecrypt(FREObject data, FREObject key, FREObject iv);
private:
	FREObject AesEncrypt(unsigned char * data, int datalen, unsigned char * key, unsigned char * iv);
	FREObject AesDecrypt(unsigned char * data, int datalen, unsigned char * key, unsigned char * iv);
};

