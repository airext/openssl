/**
 * Created by max.rozdobudko@gmail.com on 03.03.2020.
 */
package com.github.airext.openssl.test.suite.issue.test {
import com.github.airext.OpenSSL;
import com.github.airext.openssl.test.helper.FileUtils;

import flash.filesystem.File;

import flash.utils.ByteArray;

import org.flexunit.asserts.assertNull;

public class Issue6 {

    [Test]
    public function test(): void {
        var bytes: ByteArray = FileUtils.readBytes(File.applicationDirectory.resolvePath("samples/sha256/2d3a6ea84a4a919955fb35f179bfce6b376e9a6c8399598fa3320741c64b25a6.bin"));

        //convert to hex
        var hex: String = OpenSSL.shared.hexFromBytes(bytes);

        //add this to freeze and crash the app
        hex = hex + "x";

        //convert back to bytes
        bytes = OpenSSL.shared.hexToBytes(hex);

        assertNull(bytes);
    }
}
}
