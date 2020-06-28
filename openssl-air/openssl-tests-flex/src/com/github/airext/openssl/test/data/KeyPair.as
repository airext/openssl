/**
 * Created by max.rozdobudko@gmail.com on 26.01.2020.
 */
package com.github.airext.openssl.test.data {
import flash.utils.ByteArray;

public class KeyPair {

    public function KeyPair(publicKey: ByteArray, privateKey: ByteArray) {
        super();
        this.publicKey = publicKey;
        this.privateKey = privateKey;
    }

    public var publicKey: ByteArray;
    public var privateKey: ByteArray;
}
}
