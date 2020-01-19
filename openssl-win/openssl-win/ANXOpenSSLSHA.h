#include "pch.h"
#include "FlashRuntimeExtensions.h"

#pragma once
class ANXOpenSSLSHA
{
public:
    static FREObject computeSHA256(FREObject bytes);
};

