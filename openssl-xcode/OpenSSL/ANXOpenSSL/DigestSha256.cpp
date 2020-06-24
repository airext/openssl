#include "DigestSha256.h"
#include <openssl/sha.h>
#include "Utils.h"
#include <cstdio>
#pragma warning(disable:4996)

FREObject DigestSha256::computeSHA256(FREObject fobject)
{
	FREByteArray byteArray;
	int retVal;

	retVal = FREAcquireByteArray(fobject, &byteArray);
	if ((FRE_OK != retVal))
		return NULL;

	uint8_t* hash = (uint8_t*)malloc(65);

	this->computeSHA256((char *)byteArray.bytes, byteArray.length, (char *)hash);
	FREReleaseByteArray(fobject);
	FREObject f = Utils::getByteByfferFromCharPointer((char *)hash, 64);
	free(hash);
	//free(byteArray.bytes);
	return f;
	
}

FREObject DigestSha256::computeSHA256(char * str, int len, char *out)
{
	unsigned char hash[SHA256_DIGEST_LENGTH];
	
	SHA256_CTX sha256;
	SHA256_Init(&sha256);
	SHA256_Update(&sha256, str, len);
	SHA256_Final(hash, &sha256);

	int i = 0;
	for (i = 0; i < SHA256_DIGEST_LENGTH; i++)
	{
		sprintf(out + (i * 2), "%02x", hash[i]);
	}
	out[64] = 0;

	return nullptr;
}
