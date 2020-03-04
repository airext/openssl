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

import org.flexunit.experimental.theories.internals.ParameterizedAssertionError;

import org.flexunit.runner.IDescription;
import org.flexunit.runner.Result;
import org.flexunit.runner.notification.Failure;

import org.flexunit.runner.notification.IAsyncCompletionRunListener;

import skein.utils.delay.callLater;
import skein.utils.delay.delayToTimeout;

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
            handler("Error: " + error);
        }

    }

    private function writeToFailureResultFile(content: String): void {
        try {
            writeToFile(currentDirectory.resolvePath(failureFileName), content);
        } catch (error: Error) {
            handler("Error: " + error);
        }
    }

    private static function writeToFile(file: File, content: String): void {
        var fs: FileStream = new FileStream();
        fs.open(file, FileMode.WRITE);
        fs.writeUTFBytes(content);
        fs.close();
    }

    // MARK: - IAsyncCompletionRunListener

    public function testRunStarted(description: IDescription): void {
        handler("test run started: " + (description ? description.displayName : null));
    }

    public function testRunFinished(result: Result): void {
        if (result.failureCount == 0) {
            writeToSuccessResultFile("OK");
            handler("SUCCESS: All Tests Passed");
        } else {
            var failureContent: String = "";
            for each (var failure: Failure in result.failures) {
                failureContent += failure.testHeader + "\n";
                failureContent += "\t" + failure.message + "\n";
                failureContent += "\t\t" + (failure.exception is ParameterizedAssertionError ? ParameterizedAssertionError(failure.exception).targetException.message : failure.exception.message) + "\n";
            }
            writeToFailureResultFile(failureContent);
            handler("FAILURE: " + failureContent);
        }

//        NativeApplication.nativeApplication.exit();
    }

    public function testStarted(description: IDescription): void {
        handler("started: " + (description ? description.displayName : null));
    }

    public function testFinished(description: IDescription): void {
        handler("finished: " + (description ? description.displayName : null));
    }

    public function testFailure(failure: Failure): void {
        handler("test failure: " + (failure ? failure.message : null));
    }

    public function testAssumptionFailure(failure: Failure): void {
        handler("test failure: " + (failure ? failure.message : null));
    }

    public function testIgnored(description: IDescription): void {
        handler("test ignored: " + (description ? description.displayName : null));
    }

    public function get complete(): Boolean {
        return false;
    }

    // MARK: - Handlers

    private function onInvoke(event: InvokeEvent): void {
        handler("invoke arguments: " + event.arguments);
        handler("invoke argument count: " + event.arguments.length);
        currentDirectory = new File(event.arguments[0]);
    }
}
}
