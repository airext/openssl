/**
 * Created by max.rozdobudko@gmail.com on 02.02.2020.
 */
package com.github.airext.openssl.test.suite.rsa {
import com.github.airext.openssl.test.suite.rsa.theory.BytesTheory;

[Suite]
[RunWith("org.flexunit.runners.Suite")]
public class RSATestSuite {

    public var encryptDecryptTheory: BytesTheory;
}
}