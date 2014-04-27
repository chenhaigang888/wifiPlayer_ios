//
//  NSObject+SearchPc.h
//  wifiPlayer_3.0_ios
//
//  Created by 陈 海刚 on 13-5-2.
//  Copyright (c) 2013年 陈 海刚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncUdpSocket.h"
#import "SearchPcListCell.h"
#import "ListViewItem.h"
#import "ConnServerManager.h"
#import "ViewController.h"
#import "ServReplyCallBack.h"

#include <iostream>

#define searchAddr @"255.255.255.255"
#define info @"ios&6.0&chg"
#define conn_info @"Hello! I'm Client"

using namespace std;

@interface SearchPc : NSObject<UITableViewDelegate, UITableViewDataSource>
{
    AsyncUdpSocket *udpSocket;
    NSMutableArray * pcs;
    UITableView * utv;
    UIAlertView *alert_;
    ConnServerManager * connServ;
    
}

@property (nonatomic, retain)AsyncUdpSocket *udpSocket;
@property (nonatomic, retain)NSMutableArray * pcs;
@property (nonatomic, retain)ConnServerManager * connServ;
@property (nonatomic, retain)UITableView * utv;
@property (nonatomic, retain)UIAlertView *alert_;

-(id)initWithViewController:(id) vc;

-(void)openUDPServer;

//-(void)send:(NSString*)msg withSocket:(AsyncUdpSocket*)udpSocket_;
-(void)send:(NSString*)msg withSocket:(NSString*)ipAddr andPort:(int)port;

+(NSString*) getSeparator;

@end
