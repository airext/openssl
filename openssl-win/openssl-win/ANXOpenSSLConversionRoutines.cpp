#include "pch.h"
#include "ANXOpenSSLConversionRoutines.h"

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
