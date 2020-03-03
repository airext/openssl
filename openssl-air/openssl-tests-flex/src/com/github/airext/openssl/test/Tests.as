/**
 * Created by max.rozdobudko@gmail.com on 02.02.2020.
 */
package com.github.airext.openssl.test {
import com.github.airext.openssl.test.suite.hex.TestSuiteHEX;
import com.github.airext.openssl.test.suite.issue.IssuesTestSuite;
import com.github.airext.openssl.test.suite.rsa.TestSuiteRSA;
import com.github.airext.openssl.test.suite.sha.TestSuiteSHA;

[Suite]
[RunWith("org.flexunit.runners.Suite")]
public class Tests {

    public function Tests() {
        super();
    }

//    public var rsa: TestSuiteRSA;
//
//    public var sha: TestSuiteSHA;
//
    public var hex: TestSuiteHEX;

    public var issues: IssuesTestSuite;
}
}
