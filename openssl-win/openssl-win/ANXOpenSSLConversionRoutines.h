#include "FlashRuntimeExtensions.h"

#pragma once
class ANXOpenSSLConversionRoutines
{
public:
	static FREObject convertCharArrayToFREObject(const char* string);
	static FREObject createByteArrayWithLength(uint32_t length);
};

