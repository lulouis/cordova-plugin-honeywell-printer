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
    NSArray* imagebitData = [command.arguments objectAtIndex:0];
    NSString* hostAddr = [command.arguments objectAtIndex:1];
    //参数检查
    if (hostAddr == nil || [hostAddr length] == 0) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"打印网络IP不正确"];
    }

    if (imagebitData == nil) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }

    if(pluginResult != nil) {
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        return;
    }
    //打印机连接
    [self connectServer:hostAddr];

    [self sendSocket:imagebitData];
    
    [inputStream close];
    [outputStream close];
    //从主运行循环移除
    [inputStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [outputStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];

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

- (void)sendSocket:(NSArray*)msgData{
    //默认为正序遍历
    long int count = [msgData count];
    for (int i = 0 ; i < count; i++) {
        NSString *msg = [msgData objectAtIndex:i];
        if ([msg hasPrefix:@"data:image/bmp;base64,"]) {
            NSString*base64String = [msg stringByReplacingOccurrencesOfString:@"data:image/bmp;base64,"withString:@""];
            NSData *byteData = [[NSData alloc] initWithBase64EncodedString:base64String options:NSDataBase64DecodingIgnoreUnknownCharacters];
            [outputStream write:byteData.bytes maxLength:byteData.length];
        } else {
            NSString *msg = [msgData objectAtIndex:i];
            NSData *byteData = [msg dataUsingEncoding:NSUTF8StringEncoding];
            [outputStream write:byteData.bytes maxLength:byteData.length];
        }
    }
    NSLog(@"打印指令发送OK");
}

//参考文件   https://www.jianshu.com/p/1c27afb3a933 
#pragma mark - NSStreamDelegate
-(void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode{
    switch(eventCode) {
            
        case NSStreamEventOpenCompleted:
            NSLog(@"客户端输入输出流打开完成");
            break;
            
        case NSStreamEventHasBytesAvailable:
            NSLog(@"客户端有字节可读");
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
@end

