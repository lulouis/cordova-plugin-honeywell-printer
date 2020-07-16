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
    // NSString* imagePath = [command.arguments objectAtIndex:0];
    NSData* imagebitData = [command.arguments objectAtIndex:0];

    if (imagebitData != nil && [imagebitData length] > 0) {
        //imagebitData 将此数据传入到打印机

        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"打印指令发送OK"];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
