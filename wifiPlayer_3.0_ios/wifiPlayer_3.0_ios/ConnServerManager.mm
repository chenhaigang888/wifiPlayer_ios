//
//  NSObject+ConnServerManager.m
//  wifiPlayer_3.0_ios
//
//  Created by 陈 海刚 on 13-4-20.
//  Copyright (c) 2013年 陈 海刚. All rights reserved.
//

#import "ConnServerManager.h"
#define PORT 9528


@implementation ConnServerManager:NSObject

@synthesize _inputStream;
@synthesize _outputStream;
@synthesize srcb;
@synthesize ipAddr_;
@synthesize pv;
@synthesize downLoadFileName;
@synthesize alert;


- (void) setDownloadFileName:(NSString*)downLoadFileName_
{
    self.downLoadFileName = downLoadFileName_;
}

-(id) initWithCallBack:(id<ServReplyCallBack>) srcb_
{
    self.srcb = srcb_;
    return self;
}

- (void)dealloc
{
    [pv release];
    [_inputStream release];
    [_outputStream release];
    [srcb release];
    [ipAddr_ release];
    [pv release];
    [downLoadFileName release];
    [alert release];
    [super dealloc];
}

- (void)initNetworkCommunicationWithIPADDR:(NSString*)ipAddr
{
    isDownload = NO;
    ipAddr_ = ipAddr;
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL,(CFStringRef)ipAddr, PORT, &readStream, &writeStream);   
     _inputStream = (NSInputStream *)readStream;
     _outputStream = (NSOutputStream*)writeStream;
    [_inputStream setDelegate:self];  
    [_outputStream setDelegate:self];  
    [_inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];  
    [_inputStream open];  
    [_outputStream open];
}


-(void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
    NSString *event;
    switch (streamEvent) {
        case NSStreamEventNone:
            event = @"NSStreamEventNone";
            break;
        case NSStreamEventOpenCompleted://流事件打开完成时
            event = @"NSStreamEventOpenCompleted";
            break;
        case NSStreamEventHasBytesAvailable://字面意思是字节可以用的流事件（就是可以读取数据的时候）
            event = @"NSStreamEventHasBytesAvailable";
            if (theStream == _inputStream)
            {
                int len;
                while([_inputStream hasBytesAvailable] && !isDownload)
                {
                    uint8_t headArr[16];
                    len = [_inputStream read:headArr maxLength:16];
                    Head head;
                    head = head.resolveHead(headArr);
                   
                    switch (head.getCmd()){
                            
                        case CONN_SERVER_REPLY://连接服务器返回
                            [self connServerReplyWith:head];
                            break;
                        case OPEN_DIR_REPLY://打开文件夹
                            [self connServerReplyWith:head];
                            break;
                        case OPEN_FILE_REPLY:// 打开文件返回
                            break;
                        case COPY_FILE_2_PHONE_REPLY:// 拷贝文件到手机上返回
                            [self copyFile2Phone:head];
                            break;
                        case DEL_FILE_REPLY://删除文件（文件夹）返回
                            break;
                        default:
                            break;
                    }
                }
            }
            break;
        case NSStreamEventHasSpaceAvailable://流事件，有可用空间（应该就是可以往外写数据）
            event = @"NSStreamEventHasSpaceAvailable";
            if (flag ==0 && theStream == _outputStream) {
//                //输出
//                UInt8 buff[] = "Hello Server!"; 
//                [_outputStream write:buff maxLength: strlen((const char*)buff)+1]; 
//                //关闭输出流
//                [_outputStream close];
//                [self sendData:@"dd"];
            }
            break;
        case NSStreamEventErrorOccurred://流发生错误
            event = @"NSStreamEventErrorOccurred";
            [self close]; 
            break;
        case NSStreamEventEndEncountered://测试了一下服务器断开连接的时候此处执行
            event = @"NSStreamEventEndEncountered";
            NSLog(@"服务器貌似主动断开了连接");
            NSLog(@"Error----:%d:%@",[[theStream streamError] code], [[theStream streamError] localizedDescription]);
            [self close];
            break;
        default:
//            [self close];  
            event = @"Unknown";
            break;
    }
    
//    NSLog(@"event——%@",event);
    
}

-(void) sendDataWithCmd:(int)cmd andBody:(NSString*)bodyContent
{
    const char * s = [bodyContent UTF8String];
    Head * head_ = new Head(cmd,strlen(s),0,0);
    char* h = head_->getHeadArray();
    
    
    NSInteger sendLen = [_outputStream write:(uint8_t *)h maxLength:16];
    sendLen = [_outputStream write:(uint8_t *)s maxLength:strlen(s)];
    delete head_;
}


-(void)close
{
    NSLog(@"------------socket 关闭------------");
    [_outputStream close];
    [_outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_outputStream setDelegate:nil];
    [_inputStream close];
    [_inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_inputStream setDelegate:nil];
}

// 连接服务器返回
-(void)connServerReplyWith:(Head)head
{
    int count = head.getBodyLenth();
    std::cout<<"cout:"<<count<<std::endl;
    uint8_t bodyArr[count];
    memset(bodyArr+count,'\0',1);
    
    int len = 0;
    int copySize = 0;
    uint8_t temp[count];
    
    while ((len = [_inputStream read:temp maxLength:count - copySize]) != -1) {
        for (int i=0; i<len; i++) {
            bodyArr[i+copySize] = temp[i];
        }
        copySize += len;
        if (copySize == count) {
            len = 0;
            copySize = 0;
            break;
        }
    }
    
    [srcb recvCmd:head.getCmd() andBody:(char*)bodyArr];
}



//拷贝文件到手机上
-(void) copyFile2Phone:(Head)head
{
    [self downloadBefore];
    NSString * i = [NSString stringWithFormat:@"%d",head.getBodyLenth()];
    [self performSelectorInBackground:@selector(downLoad:) withObject:i];
}

//下载前
-(void) downloadBefore
{
    isDownload = YES;
    alert = [[UIAlertView alloc] initWithTitle:@"传输进度"
                                       message:[downLoadFileName stringByAppendingString:@"\n"]
                                      delegate:self
                             cancelButtonTitle:nil
                             otherButtonTitles:nil];
    pv = [[UIProgressView alloc] initWithFrame:CGRectMake(15.0f, 80.0f, 255.0f, 25.0f)];
    
    [alert addSubview:pv];
    [alert show];
    [pv release];
    [alert release];
}

//下载完成
-(void) downloadFinish
{
    isDownload = NO;
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    UIAlertView * alertF = [[UIAlertView alloc] initWithTitle:@"拷贝完成"
                                                      message:downLoadFileName
                                                     delegate:self
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil];
    
    [alertF show];
    [alertF release];
}

//下载文件的时候更新ui
-(void) updateUI:(NSString*)f
{
    float p = [f floatValue];
    if (p == 1.0f) {
        [self downloadFinish];
    }
    [pv setProgress:p];
}


-(void) downLoad:(NSString*)bodyLen_
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [NSThread sleepForTimeInterval:3];
    int bodyLen = [bodyLen_ intValue];
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask , YES);
//    NSLog(@"copyFile2Phone_Path:，%@", [paths objectAtIndex:0]);
    NSString * fileName = [@"/" stringByAppendingString:downLoadFileName];
    NSString * filePath = [[paths objectAtIndex:0] stringByAppendingString:fileName];
    NSFileManager * fileManager = [[NSFileManager alloc] init];
    [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    BOOL isExit = [fileManager fileExistsAtPath:filePath];
    
    //获取要接收文件的大小
    uint8_t temp_head[bodyLen];
    memset(temp_head+bodyLen,'\0',1);
    [_inputStream read:temp_head maxLength:bodyLen];
    char * c = (char*)temp_head;
    NSString * fileLentStr = [NSString stringWithUTF8String:c];
    
    if (isExit) {//如果文件创建成功
//        NSLog(@"文件存在");
        FILE * _imgFileHandle =NULL;
        _imgFileHandle = fopen([filePath UTF8String], "a+");
        if (_imgFileHandle != NULL) {
            long long fileLen = [fileLentStr longLongValue];//要接收的文件的大小
            long long fileCurrLen = 0;//当前接收的长度
            uint8_t temp[1024];
            int len = 0;
            while ((len = [_inputStream read:temp maxLength:1024]) != -1) {
                fileCurrLen += len;
                fwrite(temp, 1, len, _imgFileHandle);
                float f = (double)fileCurrLen/(double)fileLen;
                NSString * ff = [NSString stringWithFormat:@"%f",f ];
                [self performSelectorOnMainThread:@selector(updateUI:) withObject:ff waitUntilDone:NO];
                if (fileCurrLen == fileLen) {//如果当前接收到的文件的大小小于要读取的大小就继续接收
                    fclose(_imgFileHandle);
                    break;
                }
            }
        }
    } else {
//        NSLog(@"文件不存在");
    }
    [pool release];
    NSLog(@"下载完成");
}


@end
