#include "FlashRuntimeExtensions.h"

#pragma once
class ANXOpenSSLAES
{
public:
    static FREObject aesEncrypt(FREObject data, FREObject key, FREObject iv);
    static FREObject aesDecrypt(FREObject data, FREObject key, FREObject iv);
};

