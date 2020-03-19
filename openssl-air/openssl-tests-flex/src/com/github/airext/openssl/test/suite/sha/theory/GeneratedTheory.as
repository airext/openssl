/**
 * Created by max.rozdobudko@gmail.com on 10.03.2020.
 */
package com.github.airext.openssl.test.suite.sha.theory {
import com.github.airext.OpenSSL;
import com.github.airext.openssl.test.helper.ByteArrayGenerator;
import com.github.airext.openssl.test.helper.Variants;

import flash.utils.ByteArray;

import org.flexunit.asserts.assertNotNull;

[RunWith("org.flexunit.experimental.theories.Theories")]
public class GeneratedTheory {

    [DataPoints]
    [ArrayElementType("flash.utils.ByteArray")]
    public static var data: Array = ByteArrayGenerator.generateMany(Variants.generatingDataCount, 1*1024*1024, 1*1024*1024);

    [Theory]
    public function run(input: ByteArray): void {
        var digest: ByteArray = OpenSSL.shared.sha256Compute(input);
        var actual: String = digest.readUTFBytes(digest.length);
        assertNotNull(digest);
    }
}
}
