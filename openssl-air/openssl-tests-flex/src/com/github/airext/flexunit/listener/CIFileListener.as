/**
 * Created by max.rozdobudko@gmail.com on 01.03.2020.
 */
package com.github.airext.flexunit.listener {
import flash.desktop.NativeApplication;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import flash.events.InvokeEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

import org.flexunit.runner.IDescription;
import org.flexunit.runner.Result;
import org.flexunit.runner.notification.Failure;

import org.flexunit.runner.notification.IAsyncCompletionRunListener;

public class CIFileListener extends EventDispatcher implements IAsyncCompletionRunListener {

    private var successFileName: String;
    private var failureFileName: String;

    private var currentDirectory: File;

    public var handler: Function;

    // MARK: Constructor

    public function CIFileListener(handler: Function, successFileName: String = "tests_success.txt", failureFileName: String = "tests_failure.txt") {
        super();
        this.handler = handler;
        this.successFileName = successFileName;
        this.failureFileName = failureFileName;

        NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, onInvoke);
    }

    // MARK: - Files

    private function writeToSuccessResultFile(content: String): void {
        try {
            writeToFile(currentDirectory.resolvePath(successFileName), content);
        } catch (error: Error) {
            handler("error: " + error);
        }

    }

    private function writeToFailureResultFile(content: String): void {
        try {
            writeToFile(currentDirectory.resolvePath(failureFileName), content);
        } catch (error: Error) {
            handler("error: " + error);
        }
    }

    private function writeToFile(file: File, content: String): void {
        var fs: FileStream = new FileStream();
        fs.open(file, FileMode.WRITE);
        fs.writeUTFBytes(content);
        fs.close();
    }

    // MARK: - IAsyncCompletionRunListener

    public function testRunStarted(description: IDescription): void {
        handler("test run started: " + description.displayName);
    }

    public function testRunFinished(result: Result): void {
        if (result.failureCount == 0) {
            writeToSuccessResultFile("OK");
        } else {
            var failureContent: String = "";
            for each (var failure: Failure in result.failures) {
                failureContent += failure.message + "\n";
            }
            writeToFailureResultFile(failureContent);
        }

        NativeApplication.nativeApplication.exit();
    }

    public function testStarted(description: IDescription): void {
        handler("started: " + description.displayName);
    }

    public function testFinished(description: IDescription): void {
        handler("finished: " + description.displayName);
    }

    public function testFailure(failure: Failure): void {
        handler("test failure: " + failure.message);
    }

    public function testAssumptionFailure(failure: Failure): void {
        handler("test failure: " + failure.message);
    }

    public function testIgnored(description: IDescription): void {
        handler("test ignored: " + description.displayName);
    }

    public function get complete(): Boolean {
        return false;
    }

    // MARK: - Handlers

    private function onInvoke(event: InvokeEvent): void {
        handler("currentDirectory: " + event.currentDirectory.nativePath);
        currentDirectory = event.currentDirectory;
    }
}
}
