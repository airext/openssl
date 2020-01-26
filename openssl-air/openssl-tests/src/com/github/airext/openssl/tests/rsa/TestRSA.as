/**
 * Created by max.rozdobudko@gmail.com on 26.01.2020.
 */
package com.github.airext.openssl.tests.rsa {
import com.github.airext.OpenSSL;
import com.github.airext.openssl.data.KeyPair;
import com.github.airext.openssl.data.TestData;

import flash.utils.ByteArray;

import org.flexunit.assertThat;
import org.flexunit.asserts.assertEquals;
import org.hamcrest.object.equalTo;

public class TestRSA {

    [BeforeClass]
    public static function setUpBeforeClass():void {
    }

    [AfterClass]
    public static function tearDownAfterClass():void {
    }

    [Before]
    public function setUp():void {

    }

    [After]
    public function tearDown():void {
    }

    [Test(description="Sample test")]
    public function test(): void {
        assertThat(true, equalTo(true));
    }
    
//    [Test(description="Test RSA encrypt/decrypt with 1024-bytes sized keys")]
//    public function test1024PublicEncryptPrivateDecrypt(): void {
//        for each (var keyPair: KeyPair in TestData.keyPairs1024) {
//            testEncrypDecryptWithKeyPair(keyPair);
//        }
//    }
//
//    [Test(description="Test RSA encrypt/decrypt with 2048-bytes sized keys")]
//    public function test2048PublicEncryptPrivateDecrypt(): void {
//        for each (var keyPair: KeyPair in TestData.keyPairs2048) {
//            testEncrypDecryptWithKeyPair(keyPair);
//        }
//    }

    [Test(description="Test RSA encrypt/decrypt with 4096-bytes sized keys")]
    public function test4096PublicEncryptPrivateDecrypt(): void {
        for each (var keyPair: KeyPair in TestData.keyPairs4096) {
            testEncrypDecryptWithKeyPair(keyPair);
        }
    }

    private function testEncrypDecryptWithKeyPair(keyPair: KeyPair): void {
        for each (var phrase: String in TestData.phrases) {
            var data: ByteArray = new ByteArray();
            data.writeUTFBytes(phrase);
            var encrypted: ByteArray = OpenSSL.shared.rsaEncrypt(data, keyPair.publicKey);
            var decrypted: ByteArray = OpenSSL.shared.rsaDecrypt(encrypted, keyPair.privateKey);

            assertEquals(phrase, decrypted.readUTFBytes(decrypted.length));
        }
    }
}
}
