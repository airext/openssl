package com.github.airext.openssl.test.helper {
import flash.utils.ByteArray;

public class Compare {

    public static function bytes(ba1:ByteArray, ba2:ByteArray):Boolean
    {
        if (ba1 == null && ba2 == null) return true;

        if (ba1 == null || ba2 == null) return false;

        if (ba1.length != ba2.length) return false;

        var result: Boolean = true;

        while (ba1.bytesAvailable) {
            if (ba1.readByte() != ba2.readByte()) {
                result = false;
                break;
            }
        }

        ba1.position = 0;
        ba2.position = 0;

        return result;
    }
}
}
