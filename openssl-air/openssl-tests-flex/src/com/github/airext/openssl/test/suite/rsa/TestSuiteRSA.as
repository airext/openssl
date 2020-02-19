/**
 * Created by max.rozdobudko@gmail.com on 02.02.2020.
 */
package com.github.airext.openssl.test.suite.rsa {
import com.github.airext.openssl.test.suite.rsa.test.TestRSA;
import com.github.airext.openssl.test.suite.rsa.theory.EncryptDecryptTheory;

[Suite]
[RunWith("org.flexunit.runners.Suite")]
public class TestSuiteRSA {

    public var rsa: TestRSA;

    public var encryptDecryptTheory: EncryptDecryptTheory;
}
}
