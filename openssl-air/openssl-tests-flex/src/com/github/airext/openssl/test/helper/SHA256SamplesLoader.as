/**
 * Created by max.rozdobudko@gmail.com on 24.02.2020.
 */
package com.github.airext.openssl.test.helper {
import com.github.airext.openssl.test.data.Expectation;

import flash.filesystem.File;

import org.flexunit.runner.external.ExternalDependencyToken;
import org.flexunit.runner.external.IExternalDependencyLoader;

import skein.utils.delay.callLater;

public class SHA256SamplesLoader implements IExternalDependencyLoader {

    public function SHA256SamplesLoader() {
        super();
    }

    public function retrieveDependency(testClass: Class): ExternalDependencyToken {
        var token: ExternalDependencyToken = new ExternalDependencyToken();
        var expectations: Array = [];
        for each (var file: File in File.applicationDirectory.resolvePath("samples/sha256").getDirectoryListing()) {
            expectations.push(new Expectation(FileUtils.readBytes(file), file.name.split(".")[0]));
        }

        callLater(function(): void {
            token.notifyResult(expectations);
        });

        return token;
    }
}
}
