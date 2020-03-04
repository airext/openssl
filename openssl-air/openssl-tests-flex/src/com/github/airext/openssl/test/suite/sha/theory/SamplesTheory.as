/**
 * Created by max.rozdobudko@gmail.com on 24.02.2020.
 */
package com.github.airext.openssl.test.suite.sha.theory {
import com.github.airext.OpenSSL;
import com.github.airext.openssl.test.data.Expectation;
import com.github.airext.openssl.test.helper.SHA256SamplesLoader;

import flash.utils.ByteArray;

import org.flexunit.asserts.assertEquals;

import org.flexunit.runner.external.IExternalDependencyLoader;

[RunWith("org.flexunit.experimental.theories.Theories")]
public class SamplesTheory {

    public static var samplesLoader: IExternalDependencyLoader = new SHA256SamplesLoader();

    [DataPoints(loader="samplesLoader")]
    [ArrayElementType("com.github.airext.openssl.test.data.Expectation")]
    public static var data: Array;

    [Theory]
    public function test(expectation: Expectation): void {
        var digest: ByteArray = OpenSSL.shared.sha256Compute(expectation.input as ByteArray);
        var actual: String = digest.readUTFBytes(digest.length);
        assertEquals(actual, expectation.expected);
    }
}
}
