/**
 * Created by max.rozdobudko@gmail.com on 19.02.2020.
 */
package com.github.airext.openssl.test.suite.base64.theory {
import com.github.airext.OpenSSL;
import com.github.airext.openssl.test.helper.StringGenerator;
import com.github.airext.openssl.test.helper.Variants;

import flash.debugger.enterDebugger;

import org.flexunit.asserts.assertEquals;

[RunWith("org.flexunit.experimental.theories.Theories")]
public class Base64StringTheory {

    [DataPoints]
    [ArrayElementType("String")]
    public static var data: Array = StringGenerator.generateMany(Variants.generatingDataCount, 32, 245);

    [Theory]
    public function run(input: String): void {
        var encoded: String = OpenSSL.shared.base64FromString(input);
        var decoded: String = OpenSSL.shared.base64ToString(encoded);

        assertEquals(input, decoded);
    }
}
}
