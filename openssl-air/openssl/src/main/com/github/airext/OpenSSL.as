/**
 * Created by max.rozdobudko@gmail.com on 02.12.2019.
 */
package com.github.airext {
import com.github.airext.core.openssl;

import flash.events.EventDispatcher;
import flash.events.StatusEvent;
import flash.external.ExtensionContext;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.utils.ByteArray;

use namespace openssl;

public class OpenSSL extends EventDispatcher {

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    openssl static const EXTENSION_ID:String = "com.github.airext.OpenSSL";

    //--------------------------------------------------------------------------
    //
    //  Class properties
    //
    //--------------------------------------------------------------------------

    //-------------------------------------
    //  context
    //-------------------------------------

    private static var _context: ExtensionContext;
    openssl static function get context(): ExtensionContext {
        if (_context == null) {
            _context = ExtensionContext.createExtensionContext(EXTENSION_ID, null);
        }
        return _context;
    }

    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------

    //-------------------------------------
    //  isSupported
    //-------------------------------------

    public static function get isSupported(): Boolean {
        return context != null && context.call("isSupported");
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

    private static var _extensionVersion: String = null;

    /**
     * Returns version of extension
     * @return extension version
     */
    public static function get extensionVersion(): String {
        if (_extensionVersion == null) {
            try {
                var extension_xml: File = ExtensionContext.getExtensionDirectory(EXTENSION_ID).resolvePath("META-INF/ANE/extension.xml");
                if (extension_xml.exists) {
                    var stream: FileStream = new FileStream();
                    stream.open(extension_xml, FileMode.READ);

                    var extension: XML = new XML(stream.readUTFBytes(stream.bytesAvailable));
                    stream.close();

                    var ns:Namespace = extension.namespace();

                    _extensionVersion = extension.ns::versionNumber;
                }
            } catch (error:Error) {
                // ignore
            }
        }

        return _extensionVersion;
    }

    //-------------------------------------
    //  buildNumber
    //-------------------------------------

    private static var _buildNumber: String;

    public static function get buildNumber(): String {
        if (_buildNumber == null) {
            try {
                var extension_xml: File = ExtensionContext.getExtensionDirectory(EXTENSION_ID).resolvePath("META-INF/ANE/extension.xml");
                if (extension_xml.exists) {
                    var stream: FileStream = new FileStream();
                    stream.open(extension_xml, FileMode.READ);

                    var extension: XML = new XML(stream.readUTFBytes(stream.bytesAvailable));
                    stream.close();

                    var ns:Namespace = extension.namespace();

                    _buildNumber = extension.ns::description;
                }
            } catch (error:Error) {
                // ignore
            }
        }

        return _buildNumber;
    }

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function OpenSSL() {
        super();
        instance = this;
        context.addEventListener(StatusEvent.STATUS, statusHandler);
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    public function getOpenSSLVersion():String{
        return context.call("getOpenSSLVersion") as String;
    }

    public function extractPublicKey(certificate: ByteArray): ByteArray {
        var data: ByteArray = new ByteArray();
        var enc:ByteArray = context.call("extractPublicKey", certificate) as ByteArray;
        data.writeUTFBytes("-----BEGIN PUBLIC KEY-----\r\n" + enc.toString().replace(/\n/g, "\r\n") + "-----END PUBLIC KEY-----\r\n")
        enc.clear();
        data.position = 0;
        return data;
    }

    public function parseCertificate(certificate: ByteArray): ByteArray {
        return context.call("parseCertificate", certificate) as ByteArray;
    }

    public function parseCertificateSerial(certificate: ByteArray): ByteArray {
        return context.call("parseCertificateSerial", certificate) as ByteArray;
    }

    public  function pbkdf2Compute(password: ByteArray, salt: ByteArray, iterations: int, length: int): ByteArray {
        return context.call("pbkdf2Compute", password, salt, iterations, length) as ByteArray;
    }

    public function verifyCertificate(rootCA: ByteArray, certificate: ByteArray): Boolean {
        return context.call("verifyCertificate", rootCA, certificate) as Boolean;
    }

    //-------------------------------------
    //  RSA
    //-------------------------------------

    public function rsaEncrypt(data: ByteArray, publicKey: ByteArray): ByteArray {
        return context.call("rsaEncrypt", data, publicKey) as ByteArray;
    }

    public function rsaDecrypt(data: ByteArray, privateKey: ByteArray): ByteArray {
        return context.call("rsaDecrypt", data, privateKey) as ByteArray;
    }

    //-------------------------------------
    //  AES
    //-------------------------------------

    public function aesEncrypt(data: ByteArray, key: ByteArray, iv: ByteArray): ByteArray {
        if (key.length != 32) {
            throw new Error("Key must be 32 bytes long");
        }
        if (iv.length != 16) {
            throw new Error("IV must be 16 bytes long");
        }
        return context.call("aesEncrypt", data, key, iv) as ByteArray;
    }

    public function aesDecrypt(data: ByteArray, key: ByteArray, iv: ByteArray): ByteArray {
        if (key.length != 32) {
            throw new Error("Key must be 32 bytes long");
        }
        if (iv.length != 16) {
            throw new Error("IV must be 16 bytes long");
        }
        return context.call("aesDecrypt", data, key, iv) as ByteArray;
    }

    //-------------------------------------
    //  SHA
    //-------------------------------------

    public function sha256Compute(data: ByteArray): ByteArray {
        return context.call("computeSHA256", data) as ByteArray;
    }

    //-------------------------------------
    //  HMAC
    //-------------------------------------

    public function hmacCompute(data: ByteArray, key: ByteArray): ByteArray {
        return context.call("hmacCompute", data, key) as ByteArray;
    }

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    private function statusHandler(event: StatusEvent):void {
        trace("OpenSSL.status: ", event.code, event.level);
    }
}
}
