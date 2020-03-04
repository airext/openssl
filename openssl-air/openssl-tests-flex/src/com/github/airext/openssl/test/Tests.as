/**
 * Created by max.rozdobudko@gmail.com on 02.02.2020.
 */
package com.github.airext.openssl.test {
import com.github.airext.openssl.test.suite.base64.Base64TestSuite;
import com.github.airext.openssl.test.suite.hex.HEXTestSuite;
import com.github.airext.openssl.test.suite.issue.IssuesTestSuite;
import com.github.airext.openssl.test.suite.rsa.RSATestSuite;
import com.github.airext.openssl.test.suite.sha.SHATestSuite;

[Suite]
[RunWith("org.flexunit.runners.Suite")]
public class Tests {

    public function Tests() {
        super();
    }

    public var rsa: RSATestSuite;

    public var sha: SHATestSuite;

    public var hex: HEXTestSuite;

    public var base64: Base64TestSuite;

    public var issues: IssuesTestSuite;
}
}
