/**
 * Created by max.rozdobudko@gmail.com on 19.02.2020.
 */
package com.github.airext.openssl.test.helper {
public class StringGenerator {

    private static const chars: String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

    public static function generateMany(count: int, minLength: int, maxLength: int): Array {
        var result: Array = [];
        while (count--) {
            var length: int = minLength + (maxLength - minLength) * Math.random();
            result[result.length] = generate(length);
        }
        return result;
    }

    public static function generate(length: int): String {
        var string: String = "";

        var numChars: int = (chars.length - 1);

        while (length--) {
            string += chars.charAt(Math.floor(Math.random() * numChars));
        }

        return string;
    }
}
}
