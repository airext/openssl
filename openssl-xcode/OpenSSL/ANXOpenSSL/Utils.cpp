
#include "Utils.h"
#include <openssl/opensslv.h>
#include <openssl/pem.h>
#include <openssl/ssl.h>
#include <openssl/rsa.h>
#include <openssl/evp.h>
#include <openssl/bio.h>
#include <openssl/err.h>
#include <openssl/x509.h>
#include <openssl/x509v3.h>
#pragma warning(disable:4996)
FREObject Utils::PBKDF2_HMAC_SHA_256(const char* pass, int passSize,const unsigned char* salt, int saltSize, int32_t iterations, uint32_t outputBytes)
{
	unsigned int i;
	char *hexResult = (char *)malloc(2 * outputBytes + 1);
	unsigned char *digest = (unsigned char *)malloc(outputBytes);
	int res = PKCS5_PBKDF2_HMAC(pass, passSize, salt, saltSize, iterations, EVP_sha256(), outputBytes, digest);
	if (res == 0) {
		free(hexResult);
		free(digest);
		return NULL;
	}
	for (i = 0; i < outputBytes; i++)
	{
		sprintf(hexResult + (i * 2), "%02x", 255 & digest[i]);
		
	};

	FREObject retObj = nullptr;

	retObj = Utils::getByteByfferFromCharPointer((char *)hexResult, 2 * outputBytes);
	free(hexResult);
	free(digest);
	return retObj;

}
FREObject Utils::getByteByfferFromCharPointer(char * buffer, int len)
{

	const uint8_t * byteArray = (uint8_t*) "flash.utils.ByteArray";
	FREObject byteArrayObj;
	FREObject l;

	FREResult status = FRENewObject(byteArray, 0, NULL, &byteArrayObj, NULL);

	if (FRENewObjectFromInt32(len, &l) != FRE_OK) {
		return NULL;
	}

	if (FRESetObjectProperty(byteArrayObj, (const uint8_t*)"length", l, NULL) != FRE_OK) {
		return NULL;
	}

	if ((FRE_OK == status))
	{
		FREByteArray byteArray;
		FREAcquireByteArray(byteArrayObj, &byteArray);

		memcpy(byteArray.bytes, buffer, len);
		//free(buffer);

		if (FREReleaseByteArray(byteArrayObj) != FRE_OK) {
			return NULL;
		}

		return byteArrayObj;
	}

	return NULL;
}
int Utils::Base64Encode(const unsigned char* buffer, int length, char** b64text) { //Encodes a binary safe base 64 string
	BIO *bio, *b64;
	BUF_MEM *bufferPtr;

	b64 = BIO_new(BIO_f_base64());
	bio = BIO_new(BIO_s_mem());
	bio = BIO_push(b64, bio);

	//BIO_set_flags(bio, BIO_FLAGS_BASE64_NO_NL); //Ignore newlines - write everything in one line
	BIO_write(bio, buffer, length);
	BIO_flush(bio);
	BIO_get_mem_ptr(bio, &bufferPtr);
	BIO_set_close(bio, BIO_NOCLOSE);
	BIO_free_all(bio);
	//BIO_free(b64);

	*b64text = (*bufferPtr).data;
	

	return (int)(*bufferPtr).length; //success
}
FREObject Utils::extractPublicKey(FREObject cert)
{

	FREByteArray dataByteArray;

	int retVal;

	retVal = FREAcquireByteArray(cert, &dataByteArray);
	if ((FRE_OK != retVal))
		return NULL;

	FREReleaseByteArray(cert);

	char* pemCertString = (char *)dataByteArray.bytes;
	size_t certLen = dataByteArray.length;

	BIO* certBio = BIO_new(BIO_s_mem());
	BIO_write(certBio, pemCertString, certLen);
	X509* certX509 = PEM_read_bio_X509(certBio, NULL, NULL, NULL);
	if (!certX509) {
		BIO_free(certBio);
		return NULL;
	}


	RSA *rsa = EVP_PKEY_get0_RSA(X509_get_pubkey(certX509));
	if (rsa == NULL) {
		BIO_free(certBio);
		X509_free(certX509);
		return NULL;
	}
	unsigned char *pOut, *blah;
	pOut = blah = (unsigned char *)calloc(1,1000);
	int len = i2d_RSA_PUBKEY(rsa, &blah);
	char* base64;

	int ret = Base64Encode(pOut, len,&base64);

 
	BIO_free_all(certBio);
	RSA_free(rsa);


	X509_free(certX509);
	
	if (ret <= 0) {
		return NULL;
	}
	
	FREObject retObj = nullptr;

	retObj = Utils::getByteByfferFromCharPointer((char *)base64, ret);
	free(base64);
	free(pOut);
	
	return retObj;
}
#include<sstream>
using namespace std;

std::string Utils::asn1int(ASN1_INTEGER *bs)
{
	static const char hexbytes[] = "0123456789ABCDEF";
	stringstream ashex;
	for (int i = 0; i < bs->length; i++)
	{
		ashex << hexbytes[(bs->data[i] & 0xf0) >> 4];
		ashex << hexbytes[(bs->data[i] & 0x0f) >> 0];
	}
	return ashex.str();
}
//----------------------------------------------------------------------
string Utils::asn1string(ASN1_STRING *d)
{
	string asn1_string;
	if (ASN1_STRING_type(d) != V_ASN1_UTF8STRING) {
		unsigned char *utf8;
		int length = ASN1_STRING_to_UTF8(&utf8, d);
		asn1_string = string((char*)utf8, length);
		OPENSSL_free(utf8);
	}
	else {
		asn1_string = string((char*)ASN1_STRING_data(d), ASN1_STRING_length(d));
	}
	return asn1_string;
}
#include<string>
FREObject Utils::parseCertificateSerial(FREObject cert)
{
	
	FREByteArray dataByteArray;

	int retVal;

	retVal = FREAcquireByteArray(cert, &dataByteArray);
	if ((FRE_OK != retVal))
		return NULL;

	FREReleaseByteArray(cert);

	char* pemCertString = (char *)dataByteArray.bytes;
	size_t certLen = dataByteArray.length;

	BIO* certBio = BIO_new(BIO_s_mem());
	BIO_write(certBio, pemCertString, certLen);
	X509* certX509 = PEM_read_bio_X509(certBio, NULL, NULL, NULL);
	if (!certX509) {
		BIO_free(certBio);
		return NULL;
	}
	//char * serial_number = new char[5001];
	 
	
	//std::string s = asn1int(X509_get_serialNumber(certX509));
	BIGNUM *serialBigNumber = ASN1_INTEGER_to_BN(X509_get_serialNumber(certX509), NULL);
	char *serialChar = BN_bn2dec(serialBigNumber);
	std::string s(serialChar);
	 
	X509_free(certX509);
	BIO_free(certBio);

	FREObject retObj = nullptr;

	retObj = Utils::getByteByfferFromCharPointer((char *)s.c_str(), s.length());
	free(serialChar);
	return retObj;
}


FREObject Utils::verifyCertificate(FREObject cert1, FREObject cert2)
{

	FREByteArray cert1ByteArray;
	FREByteArray cert2ByteArray;
	int retVal;

	retVal = FREAcquireByteArray(cert1, &cert1ByteArray);
	if ((FRE_OK != retVal))
		return NULL;
	retVal = FREAcquireByteArray(cert2, &cert2ByteArray);


	if ((FRE_OK != retVal))
		return NULL;

	FREReleaseByteArray(cert1);
	FREReleaseByteArray(cert2);

	char* pemCertString = (char *)cert2ByteArray.bytes;
	size_t certLen = cert2ByteArray.length;

	BIO* c = BIO_new(BIO_s_mem());
	BIO_write(c, pemCertString, certLen);
	X509* issuer = PEM_read_bio_X509(c, NULL, NULL, NULL);
	if (!issuer) {
		BIO_free(c);
		return NULL;
	}

	EVP_PKEY* signing_key = X509_get_pubkey(issuer);


	pemCertString = (char *)cert1ByteArray.bytes;
	certLen = cert1ByteArray.length;

	BIO* b = BIO_new(BIO_s_mem());
	BIO_write(b, pemCertString, certLen);

	X509* x509 = PEM_read_bio_X509(b, NULL, NULL, NULL);
	if (!x509) {
		BIO_free(b);
		BIO_free(c);
		EVP_PKEY_free(signing_key);
		X509_free(issuer);
		return NULL;
	}

	int result = X509_verify(x509, signing_key);

	EVP_PKEY_free(signing_key);
	BIO_free(b);
	BIO_free(c);
	X509_free(x509);
	X509_free(issuer);

	FREObject retObj = nullptr;

	if (result <= 0)
		result = 0;
		


	FRENewObjectFromBool((uint32_t)result, &retObj);

	return retObj;
}

FREObject Utils::getOpenSSLVersion()
{
	const char * c = "3.0.0-dev";
	int len = strlen(c);
	FREObject retObj = nullptr;
	FRENewObjectFromUTF8(len, (const uint8_t *)c, &retObj);
	return retObj;
}

FREObject Utils::parseCertificate(FREObject cert)
{
	FREByteArray dataByteArray;
	 
	int retVal;

	retVal = FREAcquireByteArray(cert, &dataByteArray);
	if ((FRE_OK != retVal))
		return NULL;

	FREReleaseByteArray(cert);

	char* pemCertString = (char *)dataByteArray.bytes;
	size_t certLen = dataByteArray.length;

	BIO* certBio = BIO_new(BIO_s_mem());
	BIO_write(certBio, pemCertString, certLen);
	X509* certX509 = PEM_read_bio_X509(certBio, NULL, NULL, NULL);
	if (!certX509) {
		BIO_free(certBio);
		return NULL;
	}
		
	char *subj = X509_NAME_oneline(X509_get_subject_name(certX509), NULL, 0);

	int len = strlen(subj);
	FREObject retObj = Utils::getByteByfferFromCharPointer(subj, len);

	free(subj);
	BIO_free(certBio);
	X509_free(certX509);
	return retObj;

}
