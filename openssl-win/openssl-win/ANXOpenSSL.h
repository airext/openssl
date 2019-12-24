#include "openssl/opensslv.h"
#pragma once
class ANXOpenSSL
{
public:
    static ANXOpenSSL& getInstance()
    {
        static ANXOpenSSL instance; // Guaranteed to be destroyed. Instantiated on first use.
        return instance;
    }

public:
    const char* version();
};

