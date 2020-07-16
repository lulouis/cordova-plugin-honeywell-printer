# cordova plugin honeywell printer

A Cordova plugin to print images in Android and iOS , our plugin just supports Honeywell printer models now .
本插件可用于手机端打印，打印机型号目前支持霍尼韦尔PC42t.

## Installation

### With cordova-cli

If you are using [cordova-cli](https://github.com/apache/cordova-cli), install
with:

    cordova plugin add https://github.com/lulouis/cordova-plugin-honeywell-printer.git

### With plugman

With a plain [plugman](https://github.com/apache/cordova-plugman), you should be
able to install with something like:

    plugman --platform <ios|android> --project <directory> --plugin https://github.com/lulouis/cordova-plugin-honeywell-printer.git

### Manually in iOS

TODO: Write these instructions

### Manually in Android

TODO: Write these instructions

## Use from Javascript

If you are using jQuery, AngularJS, WinJS or any Promise/A library (Bluebird), promise style is supported. Use something like:

    cordova.getAppVersion.getVersionNumber().then(function (version) {
        $('.version').text(version);
    });

If not, pass a callback function:

    cordova.getAppVersion.getVersionNumber(function (version) {
        alert(version);
    });

In addition to the version number you can also retrieve other details about your application:



## Credits

Original code based on the following Stack Overflow posts:

* [iOS](http://stackoverflow.com/a/14713364/3408)
* [Android](http://stackoverflow.com/a/3637686/3408)
