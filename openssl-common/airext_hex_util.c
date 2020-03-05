//
//  airext_hex_util.c
//  OpenSSL
//
//  Created by Max Rozdobudko on 05.03.2020.
//
//  Copied from https://nachtimwald.com/2017/09/24/hex-encode-and-decode-in-c/
//

#include "airext_hex_util.h"
#include <stdlib.h>
#include <string.h>

char* airext_bin2hex(const unsigned char *bin, size_t len)
{
    char   *output;
    size_t  i;

    if (bin == NULL || len == 0)
        return NULL;

    output = (char*)malloc(len*2+1);
    for (i=0; i<len; i++) {
        output[i*2]   = "0123456789ABCDEF"[bin[i] >> 4];
        output[i*2+1] = "0123456789ABCDEF"[bin[i] & 0x0F];
    }
    output[len*2] = '\0';

    return output;
}

int hexchr2bin(const char hex, char *out)
{
    if (out == NULL)
        return 0;

    if (hex >= '0' && hex <= '9') {
        *out = hex - '0';
    } else if (hex >= 'A' && hex <= 'F') {
        *out = hex - 'A' + 10;
    } else if (hex >= 'a' && hex <= 'f') {
        *out = hex - 'a' + 10;
    } else {
        return 0;
    }

    return 1;
}

size_t airext_hex2bin(const char *hex, unsigned char **out)
{
    size_t len;
    char   b1;
    char   b2;
    size_t i;

    if (hex == NULL || *hex == '\0' || out == NULL)
        return 0;

    len = strlen(hex);
    if (len % 2 != 0)
        return 0;
    len /= 2;

    *out = malloc(len);
    memset(*out, 'A', len);
    for (i=0; i<len; i++) {
        if (!hexchr2bin(hex[i*2], &b1) || !hexchr2bin(hex[i*2+1], &b2)) {
            return 0;
        }
        (*out)[i] = (b1 << 4) | b2;
    }
    return len;
}
