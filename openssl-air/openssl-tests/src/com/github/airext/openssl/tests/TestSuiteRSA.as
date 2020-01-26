/**
 * Created by max.rozdobudko@gmail.com on 26.01.2020.
 */
package com.github.airext.openssl.tests {
import com.github.airext.openssl.tests.rsa.TestRSA;

[Suite]
[RunWith("org.flexunit.runners.Suite")]
public class TestSuiteRSA {

    public function TestSuiteRSA() {
        super();
    }

    public var rsa: TestRSA;
}
}
