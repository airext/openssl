#include "pch.h"
#include "ANXOpenSSL.h"
#include <version>

const char* ANXOpenSSL::version()
{
	return OPENSSL_VERSION_TEXT;
}
