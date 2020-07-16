var exec        = require('cordova/exec'),
    ua          = navigator.userAgent.toLowerCase(),
    isIOS       = ua.indexOf('ipad') > -1 || ua.indexOf('iphone') > -1,
    isIPAD      = ua.indexOf('ipad') > -1,
    isMac       = ua.indexOf('macintosh') > -1,
    isWin       = window.Windows !== undefined,
    isAndroid   = !isWin && ua.indexOf('android') > -1,
    isWinPC     = isWin && Windows.System.Profile.AnalyticsInfo.versionInfo.deviceFamily.includes('Desktop'),
    isDesktop   = isMac || isWinPC;

exports.printImage = function (imagePath, success, error) {
    exec(success, error, 'HoneywellPrinter', 'printImage', [imagePath]);
};
