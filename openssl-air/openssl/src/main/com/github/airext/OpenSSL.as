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

    /**
     * Indicates if the ANE is supported on current platform.
     */
    public static function get isSupported(): Boolean {
        return context != null && context.call("isSupported");
    }

    //-------------------------------------
    //  sharedInstance
    //-------------------------------------

    private static var instance: OpenSSL;

    /**
     * Shared instance of OpenSSL class.
     */
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
     * Version of the extension
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

    /**
     * Extension's build number that is usually set on CI side
     */
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

    /**
     * Returns version of OpenSSL library
     * @return Version of OpenSSL on current platform
     */
    public function getOpenSSLVersion(): String {
        return context.call("getOpenSSLVersion") as String;
    }

    /**
     * Extracts public key from the specified <code>certificate</code>
     * @param certificate UTF bytes of the certificate in PEM format
     * @return UTF bytes of the public key in PEM format
     */
    public function extractPublicKey(certificate: ByteArray): ByteArray {
        var data: ByteArray = new ByteArray();
        var enc:ByteArray = context.call("extractPublicKey", certificate) as ByteArray;
        data.writeUTFBytes("-----BEGIN PUBLIC KEY-----\r\n" + enc.toString().replace(/\n/g, "\r\n") + "-----END PUBLIC KEY-----\r\n")
        enc.clear();
        data.position = 0;
        return data;
    }

    /**
     * Extracts the subject of the specified <code>certificate</code>
     * @param certificate is UTF bytes of the certificate in PEM format
     * @return UTF bytes of the certificate subject
     */
    public function parseCertificate(certificate: ByteArray): ByteArray {
        return context.call("parseCertificate", certificate) as ByteArray;
    }

    /**
     * Extracts the serial of the specified <code>certificate</code>
     * @param certificate is UTF bytes of the certificate in PEM format
     * @return UTF bytes of the certificate serial in decimal (big integer) format, written as a string
     */
    public function parseCertificateSerial(certificate: ByteArray): ByteArray {
        return context.call("parseCertificateSerial", certificate) as ByteArray;
    }

    /**
     * Verifies the specified <code>certificate</code> against the specified <code>rootCA</code> certificate
     * @param rootCA UTF bytes of the CA (Certification Authority) certificate in PEM format
     * @param certificate UTF bytes of the certificate to be verified in PEM format
     * @return <code>true</code> if the <code>certificate</code> was issued by <code>rootCA</code> or <code>false</code> otherwise
     */
    public function verifyCertificate(rootCA: ByteArray, certificate: ByteArray): Boolean {
        return context.call("verifyCertificate", rootCA, certificate) as Boolean;
    }

    /**
     * Hashes the specified <code>password</code> along with the specified <code>salt</code>, over the number of <code>iterations</code>.
     * The resulting hash will have the specified <code>length</code>.
     * The hashing function used is SHA256
     * @param password
     * @param salt
     * @param iterations
     * @param length
     * @return UTF bytes of the hash in hex format
     */
    public  function pbkdf2Compute(password: ByteArray, salt: ByteArray, iterations: int, length: int): ByteArray {
        return context.call("pbkdf2Compute", password, salt, iterations, length) as ByteArray;
    }

    //-------------------------------------
    //  RSA
    //-------------------------------------

    /**
     * Encrypts <code>data</code> using the specified <code>publicKey</code>
     * @param data must be maximum 245 bytes
     * @param publicKey UTF bytes of the public key in PEM format. The public key can be obtained from a certificate using <code>extractPublicKey()</code> function
     * @return encrypted byte array
     */
    public function rsaEncrypt(data: ByteArray, publicKey: ByteArray): ByteArray {
        return context.call("rsaEncrypt", data, publicKey) as ByteArray;
    }

    /**
     * decrypts <code>data</code> using the specified <code>privateKey</code>
     * @param data encrypted data
     * @param privateKey UTF bytes of the private key in PEM format
     * @return decrypted byte array
     */
    public function rsaDecrypt(data: ByteArray, privateKey: ByteArray): ByteArray {
        return context.call("rsaDecrypt", data, privateKey) as ByteArray;
    }

    //-------------------------------------
    //  AES
    //-------------------------------------

    /**
     * Encrypts <code>data</code> with the specified <code>key</code> and initialization vector <code>iv</code>
     * @param data data to encrypt
     * @param key must be 256bit
     * @param iv must be 128bit
     * @return encrypted byte array
     */
    public function aesEncrypt(data: ByteArray, key: ByteArray, iv: ByteArray): ByteArray {
        if (key.length != 32) {
            throw new Error("Key must be 32 bytes long");
        }
        if (iv.length != 16) {
            throw new Error("IV must be 16 bytes long");
        }
        return context.call("aesEncrypt", data, key, iv) as ByteArray;
    }

    /**
     * Decrypts <code>data</code> with the specified <code>key</code> and initialization vector <code>iv</code>
     * @param data data to decrypt
     * @param key must be 256bit
     * @param iv must be 128bit
     * @return decrypted byte array
     */
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

    /**
     * Hashes the specified <code>data</code> using SHA256
     * @param data data to hash
     * @return UTF bytes of the hash in hex format
     */
    public function sha256Compute(data: ByteArray): ByteArray {
        return context.call("computeSHA256", data) as ByteArray;
    }

    //-------------------------------------
    //  HMAC
    //-------------------------------------

    /**
     * Hashes the specified <code>data</code> using the specified <code>key</code> and SHA256
     * @param data data to hash
     * @param key
     * @return UTF bytes of the hash in hex format
     */
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
