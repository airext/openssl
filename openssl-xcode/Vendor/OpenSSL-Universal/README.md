# OpenSSL-Universal

OpenSSL CocoaPod and Carthage for iOS and OSX. Complete solution to OpenSSL on iOS and OSX. Package came with precompiled libraries, and include script to build newer version if necessary.

Current version contains binaries build with latest iOS SDK iOS (target 6.0), and latest OSX SDK (target 10.8) for all supported architectures.

### Architectures

- iOS with architectures: armv7, armv7s, arm64 + simulator (x86_64)
- OSX with architectures: x86_64

### Why?

[Apple says](https://developer.apple.com/library/mac/documentation/security/Conceptual/cryptoservices/GeneralPurposeCrypto/GeneralPurposeCrypto.html):
"Although OpenSSL is commonly used in the open source community, OpenSSL does not provide a stable API from version to version. For this reason, although OS X provides OpenSSL libraries, the OpenSSL libraries in OS X are deprecated, and OpenSSL has never been provided as part of iOS."

### Installation

#### CocoaPods

````
pod 'OpenSSL-Universal'
````

#### Carthage

Latest stable version:

```
github "krzyzanowskim/OpenSSL"
```

#### Building and Updating

The latest version of OpenSSL at the time of writing is 1.1.1d. You can change which version to build in `build.sh`, see `OPENSSL_VERSION`. This version requires a small patch to prevent the Xcode error:

> Include of non-modular include in framework module 'OpenSSL.e_os2: ...

This is because `include <inttypes.h>` is not applicable on iOS and OS X, instead `include <stdint.h>` should be used.

##### Building OpenSSL

1. Run `./build.sh` to build OpenSSL.
1. Apply the patch using `apply e_os2.patch`. Note: this step may not be required for future versions of OpenSSL.
1. Run `./create_frameworks.sh`

You should now be able to use those frameworks directly in projects. Once you're happy that it works, you can push to this repo and tag the version. All projects using Carthage can then be updated individually.

### Authors

[Marcin Krzyżanowski](https://twitter.com/krzyzanowskim)

## Tutorial
**This tutorial assumes you want to:** <br>
  - Write a C application.<br>
  - Use OpenSSL libraries for some crypto operation.<br>
  - Use a Mac and Xcode 8+.<br>
  - Use CocoaPods and the OpenSSL-Universal pod as an elegant way to stay updated with the latest libraries and headers.<br>

#### Step 1 - Create your macOS HelloWorld C app
If you have not done this before with Xcode, select  `File / New Project / macOS / Command Line Tool`.  Hit build and run.  You just successfully build the default Hello World C project.

#### Step 2 - Setup Cocoa Pods
Make sure your machine is setup for CocoaPods.
After CocoaPods is setup, open `Terminal` and navigate to your project folder and run `pod init`.
After that has completed, type `open -a Xcode Podfile`.

#### Step 3 - get the OpenSSL-Universal pod
Add `pod 'OpenSSL-Universal'` inside the podfile.
Save the file.
Return to `Terminal` and run `Pod Install`.
After that download completes, make sure to close the C project and open the workspace file that was created.

#### Step 4 - What is inside of the OpenSSL-Universal pod?
Once this successfully completed, you have now got access to a pre-compiled version of the static OpenSSL libraries and the C header files required to call these functions.



## FAQ etc.
#### Where can I use OpenSSL-Universal?#
These libraries work for both iOS and MacOS.  There are two OpenSSL static libraries; `libcrypto.a` and `libssl.a`     ::Do NOT expect these OpenSSL files to work on every CPU architecture in the world. It is your prerogative to check.  Ask yourself, are you trying to write an app for old devices? new devices only? all iOS devices? only macOS?, etc ::

#### Fat Binaries
The OpenSSL-Universal Framework is a Fat Binary. That means it supports multiple CPU architectures in a single file.    To understand this, return to `Terminal`.  Navigate to your OpenSSL-Universal macOS files and run the command `file libcrypto.a`  This will tell you architecture the file is compiled against `x86_64`.  If you tried the iOS OpenSSL-Universal files it would have said `armv7`, `armv7s`, `arm64` + Simulators (`x86_64`).

#### Xcode Setup
You want to ensure Xcode knows;

1. Where the OpenSSL static libraries are located.
2. Where the OpenSSL header files are located for the C include statements.
Inside your workspace, go to the Target (not the Project).  The Target is the C app that is produced after a successful build. Select `Build Phases` and `Link Binary With Libraries`.  Select `+` and navigate to the static OpenSSL libraries that was included in the framework.  The magical result was, your `Target` and `Building Settings` `Library Search Paths` were populated without you typing anything. Now go to the  Target.  In `Build Settings` set the `Always Search User Paths` to `Yes`. Then add a new entry to the `User Header Search Paths`. This should be the location of the OpenSSL header files that were included in OpenSSLUniversal.
