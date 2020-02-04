/**
 * Created by max.rozdobudko@gmail.com on 26.01.2020.
 */
package com.github.airext.openssl.data {
public class KeyPair {

    public function KeyPair(publicKey: String, privateKey: String) {
        super();
        this.publicKey = publicKey;
        this.privateKey = privateKey;
    }

    public var publicKey: String;
    public var privateKey: String;
}
}
