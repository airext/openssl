## openssl-ane ![License MIT](http://img.shields.io/badge/license-MIT-lightgray.svg)

![iOS](https://img.shields.io/badge/iOS-12.0-blue) ![macOS](https://img.shields.io/badge/macOS-10.9-888888) ![macOS](https://img.shields.io/badge/Windows-XP-42AD42)

[AIR Native Extension](http://www.adobe.com/devnet/air/native-extensions-for-air.html) for OpenSSL library that exposes several cryptographic functions of it to AIR. 

## Table of Contents

  - [Setup](#setup)
  - [Usage](#usage)
  - [API](#api)
    - [Shared Instance](#shared-instance)
    - [Hashing](#hashing)
    - [RSA](#rsa)
    - [AES](#aes)
    - [Certificates](#certificates)
    - [Utils](#utils)
    
### Setup

1. Download [com.github.airext.OpenSSL.ane](https://github.com/airext/openssl/releases) ANE and [add it as dependencies](http://bit.ly/2xTSJry) to your project. Optionally you may include corresponded `com.github.airext.OpenSSL.swc` library to your project.
2. Edit your [Application Descriptor](http://help.adobe.com/en_US/air/build/WS5b3ccc516d4fbf351e63e3d118666ade46-7ff1.html) file with registering new native extensions like this:
```xml
<extensions>
    <extensionID>com.github.airext.OpenSSL</extensionID>
</extensions>
```
Set iOS minimum version to 12.0 in iPhone InfoAdditions:
```xml
<iPhone>
    <!-- A list of plist key/value pairs to be added to the application Info.plist -->
    <InfoAdditions>
        <![CDATA[
        <key>MinimumOSVersion</key>
        <string>12.0</string>
        ]]>
    </InfoAdditions>
</iPhone>
```

### Usage

### API

Full documentation can be found [here](https://airext.github.io/openssl/)

#### Shared Instance

Use `OpenSSL.shared` to obtain singleton instance of OpenSSL class.

#### Hashing
* `OpenSSL.shared.sha256Compute(array: ByteArray): ByteArray` hashes the specified `array` using SHA256. Result is the UTF bytes of the hash in hex format.
* `OpenSSL.shared.hmacCompute(data: ByteArray, key: ByteArray): ByteArray` hashes the specified **data** using the specified **key** and SHA256. Result is the UTF bytes of the hash in hex format
* `OpenSSL.shared.pbkdf2Compute(password: ByteArray, salt: ByteArray, iterations: int, length: int): ByteArray` hashes the specified **password** along with the specified **salt**, over the number of **iteraions**. The resulting hash will have the specified **length**. The hashing function used is SHA256. Result is the UTF bytes of the hash in hex format.

#### RSA
* `OpenSSL.shared.rsaEncrypt(data: ByteArray, publicKey: ByteArray): ByteArray` encrypts **data** using the specified **publicKey**. Where **data** must be maximum 245 bytes and **publicKey** is the UTF bytes of the public key in PEM format. The public key can be obtained from a certificate using extractPublicKey() function. Result is an encrypted byte array.
* `OpenSSL.shared.rsaDecrypt(data: ByteArray, privateKey: ByteArray): ByteArray` decrypts **data** using the specified **privateKey**. Where **privateKey** is the UTF bytes of the private key in PEM format. Result is a decrypted byte array.

#### AES
* `OpenSSL.shared.aesEncrypt(data: ByteArray, key: ByteArray, iv: ByteArray): ByteArray` encrypts **data** with the specified **key** and initialization vector **iv**. Where **key** must be 256bit and **iv** must be 128bit. Result is an encrypted byte array.
* `OpenSSL.shared.aesDecrypt(data: ByteArray, key: ByteArray, iv: ByteArray): ByteArray` decrypts **data** with the specified **key** and initialization vector **iv**. Where **key** must be 256bit and **iv** must be 128bit. Result is a decrypted byte array.

#### Certificates
* `OpenSSL.shared.extractPublicKey(certificate: ByteArray): ByteArray` extracts the public key of the specified **certificate**. Where **certificate** is the UTF bytes of the certificate in PEM format. Result is the UTF bytes of the private key in PEM format.
* `OpenSSL.shared.parseCertificate(certificate: ByteArray): ByteArray` extracts the subject of the specified **certificate**. Where **certificate** is the UTF bytes of the certificate in PEM format. Result is the UTF bytes of the certificate subject.
* `OpenSSL.shared.parseCertificateSerial(certificate: ByteArray) : ByteArray` extracts the serial of the specified **certificate**. Where **certificate** is the UTF bytes of the certificate in PEM format. Result is the UTF bytes of the certificate serial in decimal (big integer) format, written as a string.
* `OpenSSL.shared.verifyCertificate(rootCA: ByteArray, certificate: ByteArray): Boolean` verifies the specified **certificate** against the specified **rootCA** certificate. Where **rootCA** is the UTF bytes of the CA (Certification Authority) certificate in PEM format and **certificate** is the UTF bytes of the certificate to be verified in PEM format. Returns true if the **certificate** was issued by **rootCA**.

#### Utils
* `OpenSSL.shared.getOpenSSLVersion()` returns the version of the OpenSSL library used
