#include "HmacCompute.h"
#include "Utils.h"
#include <openssl/opensslv.h>
#include <openssl/pem.h>
#include <openssl/ssl.h>
#include <openssl/rsa.h>
#include <openssl/evp.h>
#include <openssl/bio.h>
#include <openssl/err.h>

FREObject HmacCompute::hmacCompute(FREObject data, FREObject key)
{
	FREByteArray dataByteArray;
	FREByteArray keyByteArray;
	int retVal;

	retVal = FREAcquireByteArray(data, &dataByteArray);
	if ((FRE_OK != retVal))
		return NULL;
	retVal = FREAcquireByteArray(key, &keyByteArray);


	if ((FRE_OK != retVal))
		return NULL;

	FREReleaseByteArray(data);
	FREReleaseByteArray(key);

	return hmacFromBytes((unsigned char *) dataByteArray.bytes, dataByteArray.length, keyByteArray.bytes, keyByteArray.length);
}
#pragma warning(disable:4996)
FREObject HmacCompute::hmacFromBytes(const unsigned char * bytes, uint32_t bytesLength, const unsigned char * key, uint32_t keyLength)
{
 
	unsigned int result_len;
	unsigned char result[EVP_MAX_MD_SIZE];
	 char *out = (char *)malloc(EVP_MAX_MD_SIZE+1);

	HMAC(EVP_sha256(),
		key, keyLength,
		bytes, bytesLength,
		result, &result_len);

	if (result_len > 0) {
	 
		unsigned int i = 0;
		for (i = 0; i < result_len; i++)
		{
			sprintf(out + (i * 2), "%02x", result[i]);
		}
		out[result_len * 2] = 0;
		FREObject o = Utils::getByteByfferFromCharPointer((char *)out, result_len*2);
		free(out);
		return o;
	}
	return NULL;
	


	
}
