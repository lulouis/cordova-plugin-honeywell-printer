var exec        = require('cordova/exec'),
    channel     = require('cordova/channel'),
    ua          = navigator.userAgent.toLowerCase(),
    isIOS       = ua.indexOf('ipad') > -1 || ua.indexOf('iphone') > -1,
    isIPAD      = ua.indexOf('ipad') > -1,
    isMac       = ua.indexOf('macintosh') > -1,
    isWin       = window.Windows !== undefined,
    isAndroid   = !isWin && ua.indexOf('android') > -1,
    isWinPC     = isWin && Windows.System.Profile.AnalyticsInfo.versionInfo.deviceFamily.includes('Desktop'),
    isDesktop   = isMac || isWinPC;

var honeywell = function() {};

honeywell.prototype.printImage = function (bitmap,ipAddr,port,success, error) {
    exec(success, error, 'HoneywellPrinter', 'printImage', [bitmap,ipAddr,port]);
};

//support to send DP command
honeywell.prototype.sendCommand = function (commandList,ipAddr,port, success, error) {
    exec(success, error, 'HoneywellPrinter', 'sendCommand', [commandList,ipAddr,port]);
};

if (!window.plugins) {
    window.plugins = {};
}
  
if (!window.plugins.honeywell) {
    window.plugins.honeywell = new honeywell();
}

module.exports = new honeywell();