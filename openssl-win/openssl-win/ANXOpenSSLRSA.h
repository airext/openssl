#include "FlashRuntimeExtensions.h"

#pragma once
class ANXOpenSSLRSA
{
public:
	static FREObject rsaEncryptWithPublicKey(FREObject data, FREObject key);
	static FREObject rsaDecryptWithPrivateKey(FREObject data, FREObject key);
};

