/**
 * Created by max.rozdobudko@gmail.com on 19.02.2020.
 */
package com.github.airext.openssl.test.suite.hex {
import com.github.airext.openssl.test.suite.hex.test.DecodeOddString;
import com.github.airext.openssl.test.suite.hex.theory.SpecialCases;
import com.github.airext.openssl.test.suite.hex.theory.BytesTheory;
import com.github.airext.openssl.test.suite.hex.theory.StringTheory;

[Suite]
[RunWith("org.flexunit.runners.Suite")]
public class HEXTestSuite {

    public var bytesTheory: BytesTheory;

    public var stringsTheory: StringTheory;

    public var specialCases: SpecialCases;

    public var decodeOddString: DecodeOddString;
}
}
