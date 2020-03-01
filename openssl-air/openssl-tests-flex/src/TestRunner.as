/**
 * Created by max.rozdobudko@gmail.com on 29.02.2020.
 */
package {
import com.github.airext.flexunit.listener.CIFileListener;
import com.github.airext.openssl.test.Tests;

import flash.display.Sprite;
import flash.events.UncaughtErrorEvent;
import flash.text.TextField;

import org.flexunit.internals.TraceListener;
import org.flexunit.listeners.VisualDebuggerListener;
import org.flexunit.runner.FlexUnitCore;
import org.flexunit.runner.notification.RunListener;

public class TestRunner extends Sprite {

    private var core: FlexUnitCore;

    public function TestRunner() {
        super();

        var handler: Function = function(message: String): void {
            tf.text += message + "\n";
        };

        core = new FlexUnitCore();

        core.addListener(new CIFileListener(handler));
        core.addListener(new TraceListener());
        core.addListener(new RunListener());

        core.run(Tests);

        var tf: TextField = new TextField();
        tf.x = 0;
        tf.y = 0;
        tf.width = stage.stageWidth;
        tf.height = stage.stageHeight;
        addChild(tf);

        tf.text += "Tests started";

        loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, function(event: UncaughtErrorEvent): void {
            tf.text += event.error + "\n";
        });

    }
}
}
