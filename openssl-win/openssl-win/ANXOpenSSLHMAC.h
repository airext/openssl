//
//  ANXOpenSSLHMAC.hpp
//  openssl-win-debug
//
//  Created by Max Rozdobudko on 21.01.2020.
//

#include "pch.h"
#include "FlashRuntimeExtensions.h"

#pragma once
class ANXOpenSSLHMAC
{
public:
    static FREObject hmacCompute(FREObject data, FREObject hashFunction, FREObject keyParam);
};

