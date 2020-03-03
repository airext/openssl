/**
 * Created by max.rozdobudko@gmail.com on 03.03.2020.
 */
package com.github.airext.openssl.test.suite.hex.test {
import com.github.airext.OpenSSL;

import org.flexunit.asserts.assertNull;

public class DecodeOddString {

    [Test]
    public function test(): void {
        var input: String = "Hello world!";
        var encoded: String = OpenSSL.shared.hexFromString(input);
        encoded += "x";
        var decoded: String = OpenSSL.shared.hexToString(encoded);

        assertNull(decoded);
    }

}
}
