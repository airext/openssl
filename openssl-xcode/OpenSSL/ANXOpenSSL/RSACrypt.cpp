
#include "RSACrypt.h"
#include <openssl/opensslv.h>
#include <openssl/pem.h>
#include <openssl/ssl.h>
#include <openssl/rsa.h>
#include <openssl/evp.h>
#include <openssl/bio.h>
#include <openssl/err.h>
#include "Utils.h"
#include <os/log.h>


FREObject RSACrypt::RSAEncrypt(FREObject data, FREObject key)
{
    os_log(OS_LOG_DEFAULT, "[ANX] RSACrypt::RSAEncrypt");

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

    os_log(OS_LOG_DEFAULT, "[ANX] before RSAEncrypt");
	FREObject o = RSAEncrypt((unsigned char *)dataByteArray.bytes, (int) dataByteArray.length, (unsigned char *)keyByteArray.bytes , (int)keyByteArray.length);
    os_log(OS_LOG_DEFAULT, "[ANX] after RSAEncrypt");

	return o;
}

FREObject RSACrypt::RSADecrypt(FREObject data, FREObject key)
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
		
	
	FREObject o = RSADecrypt((unsigned char *)dataByteArray.bytes, (int)dataByteArray.length, (unsigned char *)keyByteArray.bytes, (int)keyByteArray.length);

	return o;
}

FREObject RSACrypt::RSAEncrypt(unsigned char * data, int datalen, unsigned char * key, int keyLen)
{
    os_log(OS_LOG_DEFAULT, "[ANX] 1");
	unsigned char *chPublicKey = const_cast<unsigned char *>(key);
	BIO *bio = BIO_new_mem_buf(key, -1); // -1: assume string is null terminated

	BIO_set_flags(bio, BIO_FLAGS_BASE64_NO_NL); // NO NL

	RSA *rsa = PEM_read_bio_RSA_PUBKEY(bio, NULL, NULL, NULL);
    os_log(OS_LOG_DEFAULT, "[ANX] 2");
	if (rsa == NULL) {
		BIO_free(bio);
		return NULL;
	}

    os_log(OS_LOG_DEFAULT, "[ANX] 2.1");

	BIO_free(bio);

	int rsaSize = RSA_size(rsa);

	unsigned char* output = (unsigned char*)malloc(rsaSize);
    os_log(OS_LOG_DEFAULT, "[ANX] 3");
	int res = RSA_public_encrypt(datalen, data, output, rsa, RSA_PKCS1_PADDING);
    os_log(OS_LOG_DEFAULT, "[ANX] 3.1");
	if (res <= 0) {
		free(output);
		RSA_free(rsa);
		return NULL;
	}
	os_log(OS_LOG_DEFAULT, "[ANX] 4");
	RSA_free(rsa);
	FREObject o = Utils::getByteByfferFromCharPointer((char *)output, res);
	free(output);
    os_log(OS_LOG_DEFAULT, "[ANX] 5");
	return o;
}

FREObject RSACrypt::RSADecrypt(unsigned char * data, int datalen, unsigned char * key, int keyLen)
{

	unsigned char *chPublicKey = const_cast<unsigned char *>(key);
	BIO *bio = BIO_new_mem_buf(key, -1); // -1: assume string is null terminated

	RSA *rsa = PEM_read_bio_RSAPrivateKey(bio, NULL, NULL, NULL);

	if (rsa == NULL) {
		BIO_free(bio);
		return NULL;
	}


	BIO_free(bio);

	int rsaSize = RSA_size(rsa);

	unsigned char* output = (unsigned char*)malloc(rsaSize);

	int res = RSA_private_decrypt(datalen, data, output, rsa, RSA_PKCS1_PADDING);

	if (res <= 0) {
		free(output);
		RSA_free(rsa);
		return NULL;
	}
	
	RSA_free(rsa);
	FREObject o = Utils::getByteByfferFromCharPointer((char *)output, res);
	free(output);

	return o;
}
