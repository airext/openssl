/**
 * Created by max.rozdobudko@gmail.com on 19.02.2020.
 */
package com.github.airext.openssl.test.suite.hex {
import com.github.airext.openssl.test.suite.hex.test.DecodeOddString;
import com.github.airext.openssl.test.suite.hex.theory.SpecialCases;
import com.github.airext.openssl.test.suite.hex.theory.TheoryBytesHEX;
import com.github.airext.openssl.test.suite.hex.theory.TheoryStringsHEX;

[Suite]
[RunWith("org.flexunit.runners.Suite")]
public class TestSuiteHEX {

    public var bytesTheory: TheoryBytesHEX;
    public var stringsTheory: TheoryStringsHEX;

    public var specialCases: SpecialCases;

    public var decodeOddString: DecodeOddString;
}
}
