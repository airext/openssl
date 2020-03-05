#pragma once

char* airext_bin2hex(const unsigned char* bin, size_t len);

size_t airext_hex2bin(const char* hex, unsigned char** out);