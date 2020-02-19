/**
 * Created by max.rozdobudko@gmail.com on 19.02.2020.
 */
package com.github.airext.openssl.test.suite.hex.theory {
import com.github.airext.OpenSSL;
import com.github.airext.openssl.test.helper.StringGenerator;

import org.flexunit.asserts.assertEquals;

[RunWith("org.flexunit.experimental.theories.Theories")]
public class EncodeDecodeTheory {

    [DataPoints]
    [ArrayElementType("String")]
    public static var data: Array = StringGenerator.generateMany(1000, 32, 245);

    [Theory]
    public function run(input: String): void {
        var encoded: String = OpenSSL.shared.hexFromString(input);
        var decoded: String = OpenSSL.shared.hexToString(encoded);

        assertEquals(input, decoded);
    }
}
}
