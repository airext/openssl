/**
 * Created by max.rozdobudko@gmail.com on 29.02.2020.
 */
package {
import com.github.airext.flexunit.listener.CIFileListener;
import com.github.airext.openssl.test.Tests;
import com.github.airext.openssl.test.helper.Variants;
import com.github.airext.openssl.test.suite.rsa.RSATestSuite;

import flash.desktop.NativeApplication;

import flash.display.Sprite;
import flash.events.InvokeEvent;
import flash.events.UncaughtErrorEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.text.TextField;

import org.flexunit.internals.TraceListener;
import org.flexunit.runner.FlexUnitCore;

public class TestRunner extends Sprite {

    private var core: FlexUnitCore;

    public function TestRunner() {
        super();

        Variants.generatingDataCount = 256;

        var tf: TextField = new TextField();
        tf.x = 0;
        tf.y = 0;
        tf.width = stage.stageWidth;
        tf.height = stage.stageHeight;
        addChild(tf);

        var logFile: File;

        var log: Function = function(...args): void {
            trace(args);
            tf.text += args + "\n";
            tf.scrollV = tf.maxScrollV;

            if (logFile) {
                var fs: FileStream = new FileStream();
                fs.open(logFile, FileMode.APPEND);
                fs.writeUTFBytes(String(args) + "\n");
                fs.close();
            }
        };

        core = new FlexUnitCore();

        core.addListener(new CIFileListener(log));
        core.addListener(new TraceListener());

        core.run(Tests);

        log("Tests started");

        loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, function(event: UncaughtErrorEvent): void {
            log("ERROR: " + event.error);
        });

        NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, function(event: InvokeEvent): void {
            logFile = new File(event.arguments[0]).resolvePath("tests_log.txt")
        });

    }
}
}
