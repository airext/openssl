/**
 * Created by max.rozdobudko@gmail.com on 19.02.2020.
 */
package com.github.airext.openssl.test.suite.hex.theory {
import com.github.airext.OpenSSL;
import com.github.airext.openssl.test.helper.ByteArrayGenerator;
import com.github.airext.openssl.test.helper.StringGenerator;
import com.github.airext.openssl.test.helper.Variants;

import flash.debugger.enterDebugger;
import flash.utils.ByteArray;

import org.flexunit.asserts.assertEquals;

[RunWith("org.flexunit.experimental.theories.Theories")]
public class TheoryBytesHEX {

    [DataPoints]
    [ArrayElementType("flash.utils.ByteArray")]
    public static var data: Array = ByteArrayGenerator.generateMany(Variants.generatingDataCount, 256, 2048);

    [Theory]
    public function run(input: ByteArray): void {
        var encoded: String = OpenSSL.shared.hexFromBytes(input);
        var decoded: ByteArray = OpenSSL.shared.hexToBytes(encoded);

        input.position = 0;
        decoded.position = 0;

        assertEquals(input.readUTFBytes(input.length), decoded.readUTFBytes(decoded.length));
    }
}
}