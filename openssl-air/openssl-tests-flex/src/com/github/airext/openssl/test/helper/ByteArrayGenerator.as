/**
 * Created by max.rozdobudko@gmail.com on 03.02.2020.
 */
package com.github.airext.openssl.test.helper {
import flash.utils.ByteArray;

public class ByteArrayGenerator {

    public static function generateMany(count: int, minLength: int, maxLength: int): Array {
        var result: Array = [];
        while (count--) {
            var length: int = minLength + (maxLength - minLength) * Math.random();
            result[result.length] = generate(length);
        }
        return result;
    }

    public static function generate(length: int): ByteArray {
        var bytes: ByteArray = new ByteArray();
        while (length--) {
            bytes.writeByte(0x20 + Math.random() * (0x7E - 0x20));
        }
        bytes.position = 0;
        return bytes;
    }
}
}
