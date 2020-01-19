//
//  ANXOpenSSLHEX.h
//  openssl-win-debug
//
//  Created by Max Rozdobudko on 19.01.2020.
//

#include "pch.h"
#include "FlashRuntimeExtensions.h"

#pragma once

class ANXOpenSSLHEX
{
public:
    static FREObject hexEncodeString(FREObject string);
    static FREObject hexDecodeString(FREObject string);

    static FREObject hexEncodeBytes(FREObject bytes);
    static FREObject hexDecodeBytes(FREObject bytes);
};

