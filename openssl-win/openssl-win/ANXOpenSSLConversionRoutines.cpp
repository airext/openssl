#include "pch.h"
#include "ANXOpenSSLConversionRoutines.h"

FREObject ANXOpenSSLConversionRoutines::convertBoolToFREObject(BOOL value)
{
    FREObject result = NULL;

    if (value)
        FRENewObjectFromBool((uint32_t)1, &result);
    else
        FRENewObjectFromBool((uint32_t)0, &result);

    return result;
}

BOOL ANXOpenSSLConversionRoutines::convertFREObjectToBool(FREObject value)
{
    uint32_t tempValue;

    FREResult result = FREGetObjectAsBool(value, &tempValue);

    if (result != FRE_OK)
        return false;

    return tempValue > 0;
}

FREObject ANXOpenSSLConversionRoutines::convertCharArrayToFREObject(const char* utf8String)
{
    size_t length = strlen(utf8String);

    FREObject converted;

    switch (FRENewObjectFromUTF8((uint32_t)length, (const uint8_t*)utf8String, &converted))
    {
        case FRE_OK: return converted;
        default: return NULL;
    }

    return converted;
}

FREObject ANXOpenSSLConversionRoutines::createByteArrayWithLength(uint32_t length)
{
    FREObject result;
    if (FRENewObject((const uint8_t*)"flash.utils.ByteArray", 0, NULL, &result, NULL) != FRE_OK) {
        return NULL;
    }

    FREObject l;
    if (FRENewObjectFromInt32(length, &l) != FRE_OK) {
        return NULL;
    }

    if (FRESetObjectProperty(result, (const uint8_t*)"length", l, NULL) != FRE_OK) {
        return NULL;
    }

    return result;
}
