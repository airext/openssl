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
//            result[result.length] = generate(length);
            result[result.length] = generateByteArray(minLength, maxLength);
        }
        return result;
    }

    public static function generate(length: int): ByteArray {
        var bytes: ByteArray = new ByteArray();
        while (length--) {
            bytes.writeByte(Math.random() * 0xFF);
        }
        bytes.position = 0;
        return bytes;
    }

    public static function generateByteArray(minLength: int, maxLength: int): ByteArray {
        var cLength:int = minLength + int(Math.random()*(maxLength - minLength));

        var bArray:ByteArray = new ByteArray();

        while(bArray.length < cLength){
            bArray.writeFloat(Math.random())
        }

        if(bArray.length > cLength) bArray.length = cLength;

        return bArray
    }
}
}
