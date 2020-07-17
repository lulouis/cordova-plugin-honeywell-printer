/********* honeywell-printer.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>

@interface HoneywellPrinter : CDVPlugin {
  // Member variables go here.
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
}

- (void)printImage:(CDVInvokedUrlCommand*)command;
@end

@implementation HoneywellPrinter

- (void)printImage:(CDVInvokedUrlCommand*)command
{
    //定义返回
    CDVPluginResult* pluginResult = nil;
    //参数获取
    NSData* imagebitData = [command.arguments objectAtIndex:0];
    NSString* hostAddr = [command.arguments objectAtIndex:1];
    //参数检查
    if (hostAddr == nil || [hostAddr length] == 0) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"打印网络IP不正确"];
    }

    if (imagebitData == nil || [imagebitData length] == 0) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }

    if(pluginResult != nil) {
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        return
    }
    //打印机连接
    [HoneywellPrinter connectServer:hostAddr];
    [HoneywellPrinter sendSocket:imagebitData];

    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"打印指令发送OK"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end

- (void)connectServer:(NSString*)host{

    int port = 9100;
    // 1.创建输入输出流，设置代理
    CFReadStreamRef readStreamRef;
    CFWriteStreamRef writeStreamRef;
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)host, port, &readStreamRef, &writeStreamRef);
    inputStream = (__bridge NSInputStream *)(readStreamRef);
    outputStream = (__bridge NSOutputStream *)(writeStreamRef);
    
    inputStream.delegate = self;
    outputStream.delegate = self;
    
    // 2.输入输出流必须加入主运行runLoop中
    [inputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [outputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    [inputStream open];
    [outputStream open];
}

- (void)sendSocket:(NSData*)msgData{
    [outputStream write:msgData.bytes maxLength:msgData.length];
    NSLog(@"打印指令发送OK");
}