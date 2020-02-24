/**
 * Created by max.rozdobudko@gmail.com on 24.02.2020.
 */
package com.github.airext.openssl.test.helper {
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.utils.ByteArray;

public class FileUtils {

    public static function readBytes(file: File): ByteArray {
        var fileStream: FileStream = new FileStream();
        fileStream.open(file, FileMode.READ);
        var data:ByteArray = new ByteArray();
        fileStream.readBytes(data, 0, file.size);
        fileStream.close();
        data.position = 0;
        return data
    }

}
}
