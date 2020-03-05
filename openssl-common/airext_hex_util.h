//
//  airext_hex_util.h
//  OpenSSL
//
//  Created by Max Rozdobudko on 05.03.2020.
//

#ifndef airext_hex_util_h
#define airext_hex_util_h

#include <stdio.h>

char* airext_bin2hex(const unsigned char *bin, size_t len);

size_t airext_hex2bin(const char *hex, unsigned char **out);

#endif /* airext_hex_util_h */
