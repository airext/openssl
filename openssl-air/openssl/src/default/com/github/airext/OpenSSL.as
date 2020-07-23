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
    //  buildNumber
    //-------------------------------------

    public static function get buildNumber(): String {
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

    public function getOpenSSLVersion():String{
        trace("OpenSSL is not supported on " + Capabilities.os);
        return null;
    }

    public function extractPublicKey(certificate: ByteArray): ByteArray {
        trace("OpenSSL is not supported on " + Capabilities.os);
        return null;
    }

    public function parseCertificate(certificate: ByteArray): ByteArray {
        trace("OpenSSL is not supported on " + Capabilities.os);
        return null;
    }

    public function parseCertificateSerial(certificate: ByteArray): ByteArray {
        trace("OpenSSL is not supported on " + Capabilities.os);
        return null;
    }

    public  function pbkdf2Compute(password: ByteArray, salt: ByteArray, iterations: int, length: int): ByteArray {
        trace("OpenSSL is not supported on " + Capabilities.os);
        return null;
    }

    public function verifyCertificate(rootCA: ByteArray, certificate: ByteArray): Boolean {
        trace("OpenSSL is not supported on " + Capabilities.os);
        return null;
    }

    //-------------------------------------
    //  RSA
    //-------------------------------------

    public function rsaEncrypt(data: ByteArray, publicKey: ByteArray): ByteArray {
        trace("OpenSSL is not supported on " + Capabilities.os);
        return null;
    }

    public function rsaDecrypt(data: ByteArray, privateKey: ByteArray): ByteArray {
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
    //  HMAC
    //-------------------------------------

    public function hmacCompute(data: ByteArray, key: ByteArray): ByteArray {
        trace("OpenSSL is not supported on " + Capabilities.os);
        return null;
    }
}
}
