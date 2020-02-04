/**
 * Created by max.rozdobudko@gmail.com on 03.02.2020.
 */
package com.github.airext.openssl.test.suite.rsa.theory {
import com.github.airext.OpenSSL;
import com.github.airext.openssl.test.data.KeyPair;
import com.github.airext.openssl.test.data.TestData;
import com.github.airext.openssl.test.helper.ByteArrayGenerator;

import flash.utils.ByteArray;

import org.flexunit.asserts.assertEquals;

[RunWith("org.flexunit.experimental.theories.Theories")]
public class EncryptDecryptTheory {

    [DataPoints]
    [ArrayElementType("flash.utils.ByteArray")]
    public static var data: Array = ByteArrayGenerator.generateMany(10000, 32, 245);

    [DataPoints]
    [ArrayElementType("com.github.airext.openssl.test.data.KeyPair")]
    public static var keyPairs: Array = [
        TestData.keyPairs4096[0]
    ];

    [Theory]
    public function encryptDecrypt(data: ByteArray, keyPair: KeyPair): void {
        var encrypted: ByteArray = OpenSSL.shared.rsaEncrypt(data, keyPair.publicKey);
        var decrypted: ByteArray = OpenSSL.shared.rsaDecrypt(encrypted, keyPair.privateKey);

        assertEquals(data.readUTFBytes(data.length), decrypted.readUTFBytes(decrypted.length));
    }
}
}
