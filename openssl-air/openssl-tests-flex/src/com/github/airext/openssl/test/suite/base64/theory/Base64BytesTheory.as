/**
 * Created by max.rozdobudko@gmail.com on 04.03.2020.
 */
package com.github.airext.openssl.test.suite.base64.theory {
import com.github.airext.OpenSSL;
import com.github.airext.openssl.test.helper.ByteArrayGenerator;
import com.github.airext.openssl.test.helper.Variants;

import flash.utils.ByteArray;

import org.flexunit.asserts.assertEquals;

[RunWith("org.flexunit.experimental.theories.Theories")]
public class Base64BytesTheory {

    [DataPoints]
    [ArrayElementType("flash.utils.ByteArray")]
    public static var data: Array = ByteArrayGenerator.generateMany(Variants.generatingDataCount, 32, 2048);

    [Theory]
    public function run(input: ByteArray): void {
        var encoded: String = OpenSSL.shared.base64FromBytes(input);
        var decoded: ByteArray = OpenSSL.shared.base64ToBytes(encoded);

        assertEquals(input.readUTFBytes(input.length), decoded.readUTFBytes(decoded.length));
    }
}
}
