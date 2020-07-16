/********* honeywell-printer.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>

@interface HoneywellPrinter : CDVPlugin {
  // Member variables go here.
}

- (void)printImage:(CDVInvokedUrlCommand*)command;
@end

@implementation HoneywellPrinter

- (void)printImage:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* imagePath = [command.arguments objectAtIndex:0];

    if (imagePath != nil && [imagePath length] > 0) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:imagePath];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
