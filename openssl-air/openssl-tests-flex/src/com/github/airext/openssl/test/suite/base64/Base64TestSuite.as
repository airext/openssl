/**
 * Created by max.rozdobudko@gmail.com on 04.03.2020.
 */
package com.github.airext.openssl.test.suite.base64 {
import com.github.airext.openssl.test.suite.base64.theory.Base64BytesTheory;
import com.github.airext.openssl.test.suite.base64.theory.Base64StringTheory;

[Suite]
[RunWith("org.flexunit.runners.Suite")]
public class Base64TestSuite {

    public var stringsTheory: Base64StringTheory;

    public var bytesTheory: Base64BytesTheory;
}
}
