/**
 * Created by max.rozdobudko@gmail.com on 19.02.2020.
 */
package com.github.airext.openssl.test.suite.sha {
import com.github.airext.openssl.test.suite.sha.test.TestSHA;
import com.github.airext.openssl.test.suite.sha.theory.SamplesSHA256;

[Suite]
[RunWith("org.flexunit.runners.Suite")]
public class TestSuiteSHA {

    public var test: TestSHA;

    public var theory: SamplesSHA256;
}
}
