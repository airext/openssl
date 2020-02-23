#include "pch.h"
#include "FlashRuntimeExtensions.h"

#pragma once
class ANXOpenSSLConversionRoutines
{
public:
	static FREObject convertBoolToFREObject(BOOL value);
	static BOOL convertFREObjectToBool(FREObject value);

	static FREObject convertCharArrayToFREObject(const char* string);
	static FREObject createByteArrayWithLength(uint32_t length);
};

