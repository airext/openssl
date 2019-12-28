#include <openssl/opensslv.h>
#include <openssl/pem.h>
#include <openssl/ssl.h>
#include <openssl/rsa.h>
#include <openssl/evp.h>
#include <openssl/bio.h>
#include <openssl/err.h>
#include <stdio.h>
#include <stdarg.h>
#include <ctype.h>
#pragma once
extern "C" {
	RSA* anx_create_rsa_with_public_key(const unsigned char* key);
	RSA* anx_create_rsa_with_private_key(const unsigned char* key);

	char* anx_retrieve_openssl_error_queue(void);

	static void _OutputDebugString(LPCTSTR lpOutputString, ...)
	{
		TCHAR OutMsg[4096];

		va_list argptr;
		va_start(argptr, lpOutputString);

		wvsprintf(OutMsg, lpOutputString, argptr);
		OutputDebugString(OutMsg);

		va_end(argptr);
	}
}

