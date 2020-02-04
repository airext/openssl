/**
 * Created by max.rozdobudko@gmail.com on 26.01.2020.
 */
package com.github.airext.openssl {
import com.github.airext.openssl.tests.TestSuiteRSA;

[Suite]
[RunWith("org.flexunit.runners.Suite")]
public class Tests {

    public function Tests() {
        super();
    }

    public var rsa: TestSuiteRSA;
}
}
