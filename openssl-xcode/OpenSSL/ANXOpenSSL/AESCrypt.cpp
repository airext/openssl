#include "AESCrypt.h"
#include "Utils.h"
#include <openssl/conf.h>
#include <openssl/evp.h>
#include <openssl/err.h>

FREObject AESCrypt::AesEncrypt(FREObject data, FREObject key, FREObject iv)
{
	FREByteArray dataByteArray;
	FREByteArray keyByteArray;
	FREByteArray ivByteArray;
	int retVal;

	retVal = FREAcquireByteArray(data, &dataByteArray);
	if ((FRE_OK != retVal))
		return NULL;
	retVal = FREAcquireByteArray(key, &keyByteArray);
	if ((FRE_OK != retVal))
		return NULL;
	retVal = FREAcquireByteArray(iv, &ivByteArray);
	if ((FRE_OK != retVal))
		return NULL;

	

	FREReleaseByteArray(data);
	FREReleaseByteArray(key);
	FREReleaseByteArray(iv);
	FREObject o = this->AesEncrypt(dataByteArray.bytes, dataByteArray.length, keyByteArray.bytes, ivByteArray.bytes);
	//free(dataByteArray.bytes);
	//free(keyByteArray.bytes);
	//free(ivByteArray.bytes);
	return o;
}

FREObject AESCrypt::AesDecrypt(FREObject data, FREObject key, FREObject iv)
{
	FREByteArray dataByteArray;
	FREByteArray keyByteArray;
	FREByteArray ivByteArray;
	int retVal;

	retVal = FREAcquireByteArray(data, &dataByteArray);
	if ((FRE_OK != retVal))
		return NULL;
	retVal = FREAcquireByteArray(key, &keyByteArray);
	if ((FRE_OK != retVal))
		return NULL;
	retVal = FREAcquireByteArray(iv, &ivByteArray);
	if ((FRE_OK != retVal))
		return NULL;



	FREReleaseByteArray(data);
	FREReleaseByteArray(key);
	FREReleaseByteArray(iv);

	FREObject o = this->AesDecrypt(dataByteArray.bytes, dataByteArray.length, keyByteArray.bytes, ivByteArray.bytes);
	//free(dataByteArray.bytes);
	//free(keyByteArray.bytes);
	//free(ivByteArray.bytes);
	return o;
}

FREObject AESCrypt::AesEncrypt(unsigned char * data, int datalen, unsigned char * key, unsigned char * iv)
{
	EVP_CIPHER_CTX *ctx;

	int len;
	int CipherTextLength = datalen + 16;
	unsigned char * ciphertext  = (unsigned char *)malloc(CipherTextLength);
	int ciphertext_len;

	/* Create and initialise the context */
	if (!(ctx = EVP_CIPHER_CTX_new()))
	{
		free(ciphertext);
		return NULL;
	}

	/*
	 * Initialise the encryption operation. IMPORTANT - ensure you use a key
	 * and IV size appropriate for your cipher
	 * In this example we are using 256 bit AES (i.e. a 256 bit key). The
	 * IV size for *most* modes is the same as the block size. For AES this
	 * is 128 bits
	 */
	if (1 != EVP_EncryptInit_ex(ctx, EVP_aes_256_cbc(), NULL, key, iv))
	{
		free(ciphertext);
		EVP_CIPHER_CTX_free(ctx);
		return NULL;
	}

	/*
	 * Provide the message to be encrypted, and obtain the encrypted output.
	 * EVP_EncryptUpdate can be called multiple times if necessary
	 */
	if (1 != EVP_EncryptUpdate(ctx, ciphertext, &len, data, datalen))
	{
		free(ciphertext);
		EVP_CIPHER_CTX_free(ctx);
		return NULL;
	}

	ciphertext_len = len;

	/*
	 * Finalise the encryption. Further ciphertext bytes may be written at
	 * this stage.
	 */
	if (1 != EVP_EncryptFinal_ex(ctx, ciphertext + len, &len))
	{
		free(ciphertext);
		EVP_CIPHER_CTX_free(ctx);
		return NULL;
	}

	ciphertext_len += len;

	/* Clean up */
	EVP_CIPHER_CTX_free(ctx);

	FREObject obj = Utils::getByteByfferFromCharPointer((char *)ciphertext, ciphertext_len);
	free(ciphertext);

	return obj;
}

FREObject AESCrypt::AesDecrypt(unsigned char * data, int datalen, unsigned char * key, unsigned char * iv)
{
	EVP_CIPHER_CTX *ctx;

	unsigned char *plaintext = (unsigned char *)malloc(datalen + 16);
	int len;

	int plaintext_len;

	/* Create and initialise the context */
	if (!(ctx = EVP_CIPHER_CTX_new()))
	{
		free(plaintext);
		return NULL;
	}

	/*
	 * Initialise the decryption operation. IMPORTANT - ensure you use a key
	 * and IV size appropriate for your cipher
	 * In this example we are using 256 bit AES (i.e. a 256 bit key). The
	 * IV size for *most* modes is the same as the block size. For AES this
	 * is 128 bits
	 */
	if (1 != EVP_DecryptInit_ex(ctx, EVP_aes_256_cbc(), NULL, key, iv))
	{
		free(plaintext);
		EVP_CIPHER_CTX_free(ctx);
		return NULL;
	}

	/*
	 * Provide the message to be decrypted, and obtain the plaintext output.
	 * EVP_DecryptUpdate can be called multiple times if necessary.
	 */
	if (1 != EVP_DecryptUpdate(ctx, plaintext, &len, data, datalen))
	{
		free(plaintext);
		EVP_CIPHER_CTX_free(ctx);
		return NULL;
	}

	plaintext_len = len;

	/*
	 * Finalise the decryption. Further plaintext bytes may be written at
	 * this stage.
	 */
	if (1 != EVP_DecryptFinal_ex(ctx, plaintext + len, &len))
	{
		free(plaintext);
		EVP_CIPHER_CTX_free(ctx);
		return NULL;
	}

	plaintext_len += len;

	/* Clean up */
	EVP_CIPHER_CTX_free(ctx);

	FREObject obj = Utils::getByteByfferFromCharPointer((char *)plaintext, plaintext_len);

	free(plaintext);

	return obj;
}
