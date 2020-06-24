package com.airext.openssl.demo.utils {
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.utils.ByteArray;

    public function getBytes(file:File):ByteArray {
        var fileStream:FileStream = new FileStream()
        fileStream.open(file, FileMode.READ)
        var data:ByteArray = new ByteArray()
        fileStream.readBytes(data, 0, file.size)
        fileStream.close()
        return data
    }
}
