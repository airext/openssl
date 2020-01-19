#include "FlashRuntimeExtensions.h"
#pragma once
class ANXOpenSSLBase64
{
public:
	static FREObject base64EncodeString(FREObject string);
	static FREObject base64DecodeString(FREObject string);

	static FREObject base64EncodeBytes(FREObject bytes);
	static FREObject base64DecodeBytes(FREObject bytes);
};
