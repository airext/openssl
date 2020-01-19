/**
 * Created by max.rozdobudko@gmail.com on 02.12.2019.
 */
package com.github.airext {
import com.github.airext.core.openssl;

import flash.events.EventDispatcher;
import flash.system.Capabilities;
import flash.utils.ByteArray;

use namespace openssl;

public class OpenSSL extends EventDispatcher {

    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------

    //-------------------------------------
    //  isSupported
    //-------------------------------------

    public static function get isSupported(): Boolean {
        return false;
    }

    //-------------------------------------
    //  sharedInstance
    //-------------------------------------

    private static var instance: OpenSSL;

    public static function get shared(): OpenSSL {
        if (instance == null) {
            new OpenSSL();
        }
        return instance;
    }

    //-------------------------------------
    //  extensionVersion
    //-------------------------------------

    public static function get extensionVersion(): String {
        trace("OpenSSL is not supported on " + Capabilities.os);
        return null;
    }

    //-------------------------------------
    //  nativeVersion
    //-------------------------------------

    public static function get nativeVersion(): String {
        trace("OpenSSL is not supported on " + Capabilities.os);
        return null;
    }

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function OpenSSL() {
        super();
        instance = this;
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    //-------------------------------------
    //  RSA
    //-------------------------------------

    public function rsaEncryptWithPrivateKey(input: ByteArray): ByteArray {
        trace("OpenSSL is not supported on " + Capabilities.os);
        return null;
    }

    public function rsaEncrypt(data: ByteArray, publicKey: String): ByteArray {
        trace("OpenSSL is not supported on " + Capabilities.os);
        return null;
    }

    public function rsaDecrypt(data: ByteArray, privateKey: String): ByteArray {
        trace("OpenSSL is not supported on " + Capabilities.os);
        return null;
    }

    public function verifyCertificate(rootCertificate: String, certificate: String): Boolean {
        trace("OpenSSL is not supported on " + Capabilities.os);
        return null;
    }

    //-------------------------------------
    //  AES
    //-------------------------------------

    public function aesEncrypt(data: ByteArray, key: ByteArray, iv: ByteArray): ByteArray {
        trace("OpenSSL is not supported on " + Capabilities.os);
        return null;
    }

    public function aesDecrypt(data: ByteArray, key: ByteArray, iv: ByteArray): ByteArray {
        trace("OpenSSL is not supported on " + Capabilities.os);
        return null;
    }

    //-------------------------------------
    //  SHA
    //-------------------------------------

    public function sha256Compute(data: ByteArray): ByteArray {
        trace("OpenSSL is not supported on " + Capabilities.os);
        return null;
    }

    //-------------------------------------
    //  Base64
    //-------------------------------------

    public function base64FromString(string: String): String {
        trace("OpenSSL is not supported on " + Capabilities.os);
        return null;
    }

    public function base64ToString(base64: String): String {
        trace("OpenSSL is not supported on " + Capabilities.os);
        return null;

    }

    public function base64FromBytes(bytes: ByteArray): String {
        trace("OpenSSL is not supported on " + Capabilities.os);
        return null;
    }

    public function base64ToBytes(base64: String): ByteArray {
        trace("OpenSSL is not supported on " + Capabilities.os);
        return null;
    }

    //-------------------------------------
    //  Hex
    //-------------------------------------

    public function hexFromString(string: String): String {
        trace("OpenSSL is not supported on " + Capabilities.os);
        return null;
    }

    public function hexToString(string: String): String {
        trace("OpenSSL is not supported on " + Capabilities.os);
        return null;
    }

    public function hexFromBytes(bytes: ByteArray): String {
        trace("OpenSSL is not supported on " + Capabilities.os);
        return null;
    }

    public function hexToBytes(string: String): ByteArray {
        trace("OpenSSL is not supported on " + Capabilities.os);
        return null;
    }

    //-------------------------------------
    //  Debug Utils
    //-------------------------------------

    public function test(bytes: ByteArray): ByteArray {
        trace("OpenSSL is not supported on " + Capabilities.os);
        return null;
    }

    public function getBuildVersion(): String {
        trace("OpenSSL is not supported on " + Capabilities.os);
        return null;
    }
}
}
