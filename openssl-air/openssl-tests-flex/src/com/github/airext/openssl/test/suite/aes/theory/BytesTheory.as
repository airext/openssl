/**
 * Created by max.rozdobudko@gmail.com on 19.03.2020.
 */
package com.github.airext.openssl.test.suite.aes.theory {
import com.github.airext.OpenSSL;
import com.github.airext.openssl.test.helper.ByteArrayGenerator;
import com.github.airext.openssl.test.helper.Variants;

import flash.utils.ByteArray;

import org.flexunit.asserts.assertEquals;

[RunWith("org.flexunit.experimental.theories.Theories")]
public class BytesTheory {

    [DataPoints]
    [ArrayElementType("flash.utils.ByteArray")]
    public static var data: Array = ByteArrayGenerator.generateMany(Variants.generatingDataCount, 256, 4096);

    [Theory]
    public function run(input: ByteArray): void {
        var key: ByteArray = new ByteArray();
        key.writeUTFBytes("01234567890123456789012345678901");
        var iv: ByteArray = new ByteArray();
        iv.writeUTFBytes("0123456789012345");

        var encoded: ByteArray = OpenSSL.shared.aesEncrypt(input, key, iv);
        var decoded: ByteArray = OpenSSL.shared.aesDecrypt(encoded, key, iv);

        input.position = 0;
        decoded.position = 0;

        assertEquals(input.readUTFBytes(input.length), decoded.readUTFBytes(decoded.length));
    }
}
}
