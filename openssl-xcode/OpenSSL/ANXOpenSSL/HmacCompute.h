#pragma once
#include "FlashRuntimeExtensions.h"
class HmacCompute
{
public:
	FREObject hmacCompute(FREObject data, FREObject key);
private:
	FREObject hmacFromBytes(const unsigned char * bytes, uint32_t bytesLength, const unsigned char * key, uint32_t keyLength);
};

