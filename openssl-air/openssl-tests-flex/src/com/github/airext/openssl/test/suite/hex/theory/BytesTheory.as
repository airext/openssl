/**
 * Created by max.rozdobudko@gmail.com on 19.02.2020.
 */
package com.github.airext.openssl.test.suite.hex.theory {
import com.github.airext.OpenSSL;
import com.github.airext.openssl.test.helper.ByteArrayGenerator;
import com.github.airext.openssl.test.helper.Compare;
import com.github.airext.openssl.test.helper.StringGenerator;
import com.github.airext.openssl.test.helper.Variants;

import flash.debugger.enterDebugger;
import flash.utils.ByteArray;

import org.flexunit.asserts.assertEquals;
import org.flexunit.asserts.assertTrue;

[RunWith("org.flexunit.experimental.theories.Theories")]
public class BytesTheory {

    [DataPoints]
    [ArrayElementType("flash.utils.ByteArray")]
    public static var data: Array = ByteArrayGenerator.generateMany(Variants.generatingDataCount, 128, 1024);

    [Theory]
    public function run(input: ByteArray): void {
        var encoded: String = OpenSSL.shared.hexFromBytes(input);
        var decoded: ByteArray = OpenSSL.shared.hexToBytes(encoded);

        if (!Compare.bytes(input, decoded)) {
            enterDebugger();
        }

        assertTrue("Expected and actual values don't match.", Compare.bytes(input, decoded));
    }
}
}
