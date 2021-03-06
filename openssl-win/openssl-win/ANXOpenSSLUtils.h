#include <openssl/opensslv.h>
#include <openssl/pem.h>
#include <openssl/ssl.h>
#include <openssl/rsa.h>
#include <openssl/evp.h>
#include <openssl/bio.h>
#include <openssl/err.h>

#pragma once
extern "C" {
	RSA* anx_create_rsa_with_public_key(const unsigned char* key);
	RSA* anx_create_rsa_with_private_key(const unsigned char* key);

	char* anx_retrieve_openssl_error_queue(void);

	int anx_base64_encode(const unsigned char* in, size_t in_len, char** out, size_t* out_len);
	int anx_base64_decode(const char* in, size_t in_len, unsigned char** out, size_t* out_len);

#if defined(_WIN32) || defined(_WIN64)
	static void _OutputDebugString(LPCTSTR lpOutputString, ...)
	{
		TCHAR OutMsg[4096];

		va_list argptr;
		va_start(argptr, lpOutputString);

		wvsprintf(OutMsg, lpOutputString, argptr);
		OutputDebugString(OutMsg);

		va_end(argptr);
	}
#else
    static void _OutputDebugString(const wchar_t* lpOutputString, ...) {
        
    }
#endif

}

