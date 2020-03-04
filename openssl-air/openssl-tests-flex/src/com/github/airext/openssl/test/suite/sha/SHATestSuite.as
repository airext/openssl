/**
 * Created by max.rozdobudko@gmail.com on 19.02.2020.
 */
package com.github.airext.openssl.test.suite.sha {
import com.github.airext.openssl.test.suite.sha.test.SpecialCases;
import com.github.airext.openssl.test.suite.sha.theory.SamplesTheory;

[Suite]
[RunWith("org.flexunit.runners.Suite")]
public class SHATestSuite {

    public var test: SpecialCases;

    public var theory: SamplesTheory;
}
}
