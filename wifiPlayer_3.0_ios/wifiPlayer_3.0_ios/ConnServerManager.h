//
//  NSObject+ConnServerManager.h
//  wifiPlayer_3.0_ios
//
//  Created by 陈 海刚 on 13-4-20.
//  Copyright (c) 2013年 陈 海刚. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <sys/socket.h>

#include <netinet/in.h>
#include "Head.h"
#include <string.h>
#import "ServReplyCallBack.h"
#import "OnDownloadUpdateUI.h"


@interface ConnServerManager:NSObject<NSStreamDelegate,OnDownloadUpdateUI>
{
    int flag ; //操作标志 0为发送 1为接收
    id<ServReplyCallBack> srcb;
    NSString * ipAddr_;
    UIProgressView * pv;
    BOOL isDownload;
    NSString * downLoadFileName;
    UIAlertView * alert;

}

@property (nonatomic, retain) NSInputStream *_inputStream;
@property (nonatomic, retain) NSOutputStream *_outputStream;
@property (nonatomic, retain) id<ServReplyCallBack> srcb;
@property (nonatomic, retain) NSString * ipAddr_;
@property (nonatomic, retain) UIProgressView * pv;
@property (nonatomic, retain) NSString * downLoadFileName;
@property (nonatomic, retain) UIAlertView * alert;

-(id) initWithCallBack:(id<ServReplyCallBack>) srcb_;

- (void)initNetworkCommunicationWithIPADDR:(NSString*)ipAddr;
-(void) sendDataWithCmd:(int)cmd andBody:(NSString*)bodyContent;

-(void) copyFile2Phone:(Head)head;
-(void) downLoad:(NSString*)bodyLen_;

-(void) setDownloadFileName:(NSString*)downLoadFileName_;

@end
