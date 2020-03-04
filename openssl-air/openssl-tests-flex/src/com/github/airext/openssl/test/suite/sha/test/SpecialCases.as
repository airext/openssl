/**
 * Created by max.rozdobudko@gmail.com on 19.02.2020.
 */
package com.github.airext.openssl.test.suite.sha.test {
import com.github.airext.OpenSSL;

import flash.utils.ByteArray;

import org.flexunit.asserts.assertEquals;

public class SpecialCases {

    // MARK: - Data

    public static const data: Array = [
        { text: "abc123abc123abc123abc123abc123abc123abc123abc123", hash: "1d1f0a87ab72051cc800fe24892731d837edfc036a42dea66e54e69c96fd933f" }
    ];

    // MARK: - Tests

    [Test]
    public function test(): void {
        for each (var item: Object in data) {
            var input: ByteArray = new ByteArray();
            input.writeUTFBytes(item.text);
            var digest: ByteArray = OpenSSL.shared.sha256Compute(input);
            assertEquals(item.hash, digest.readUTFBytes(digest.length));
        }
    }
}
}
