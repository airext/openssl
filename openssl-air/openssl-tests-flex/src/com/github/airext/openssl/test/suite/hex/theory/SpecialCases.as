/**
 * Created by max.rozdobudko@gmail.com on 03.03.2020.
 */
package com.github.airext.openssl.test.suite.hex.theory {
import com.github.airext.OpenSSL;

import org.flexunit.asserts.assertEquals;

[RunWith("org.flexunit.experimental.theories.Theories")]
public class SpecialCases {

    [DataPoints]
    [ArrayElementType("String")]
    public static var data: Array = [
        "TMyOe8vK5uPyzlejQcd8cMKxKnIvpPPBh2ypa5S3oRM5Yof06HI",
        "77Y1sJc7Ss5Vuskumg2tiea7jdVUYnRYIg3kGTbnZ03ohRONrdxnnZPTVZp5La78x2wQgl",
        "vxrXS2m514WJ7RAsPEYj3klb0w457yHVZ6NgCqa65jmKUb3zfwIULTTQFd8s0R40HONjxCCZKfRqdHiBPJmPSnX1gPsGM7TwoWZ1VdlSNCmYulf5TBRfV",
        "vxrXS2m514WJ7RAsPEYj3klb0w457yHVZ6NgCqa65jmKUb3zfwIULTTQFd8s0R40HONjxCCZKfRqdHiBPJmPSnX1gPsGM7TwoWZ1VdlSNCmYulf5TBRfV",
    ];

    [Theory]
    public function run(input: String): void {
        var encoded: String = OpenSSL.shared.hexFromString(input);
        var decoded: String = OpenSSL.shared.hexToString(encoded);

        assertEquals(input, decoded);
    }
}
}
