/********* honeywell-printer.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>

@interface HoneywellPrinter : CDVPlugin<NSStreamDelegate> {
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
    [self connectServer:hostAddr];

    [self sendSocket:imagebitData];

    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"打印指令发送OK"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

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
    //内容组装
    [outputStream write:msgData.bytes maxLength:msgData.length];
    NSLog(@"打印指令发送OK");
}

@end


//参考文件   https://www.jianshu.com/p/1c27afb3a933 
#pragma mark - NSStreamDelegate
-(void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode{
    switch(eventCode) {
            
        case NSStreamEventOpenCompleted:
            NSLog(@"客户端输入输出流打开完成");
            break;
            
        case NSStreamEventHasBytesAvailable:
            NSLog(@"客户端有字节可读");
            [self readData];
            break;
            
        case NSStreamEventHasSpaceAvailable:
            NSLog(@"客户端可以发送字节");
            break;
            
        case NSStreamEventErrorOccurred:
            NSLog(@"客户端连接出现错误");
            break;
            
        case NSStreamEventEndEncountered:
            NSLog(@"客户端连接结束");
            //关闭输入输出流
            [inputStream close];
            [outputStream close];
            
            //从主运行循环移除
            [inputStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
            [outputStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
            break;
        default:
            break;
            
    }
}