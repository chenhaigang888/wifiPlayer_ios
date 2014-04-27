//
//  NSObject+SearchPc.m
//  wifiPlayer_3.0_ios
//
//  Created by 陈 海刚 on 13-5-2.
//  Copyright (c) 2013年 陈 海刚. All rights reserved.
//

#import "SearchPc.h"

@implementation SearchPc


@synthesize udpSocket;
@synthesize pcs;
@synthesize connServ;
@synthesize utv;
@synthesize alert_;

static BOOL nibsRegistered = NO;//控制是否创建新的UITableViewCell
static NSString * separator;

+(NSString*) getSeparator
{
    return separator;
}

-(id)initWithViewController:(id) vc;
{
    pcs = [[NSMutableArray alloc] init];
    [udpSocket close];
    [udpSocket release];
    udpSocket = nil;
    //初始化udp
    udpSocket = [[AsyncUdpSocket alloc] initWithDelegate:self];
    [self openUDPServer];
    self.connServ = [[ConnServerManager alloc] initWithCallBack:vc];
    [self showResult];
    
    return self;
}

//建立基于UDP的Socket连接
-(void)openUDPServer{
	
	//绑定端口
	NSError *error = nil;
	[udpSocket bindToPort:9527 error:&error];
	//启动接收线程
	[udpSocket receiveWithTimeout:-1 tag:0];
    [udpSocket enableBroadcast:YES error:&error];
    
}


-(void)send:(NSString*)msg withSocket:(NSString*)ipAddr andPort:(int)port
{
    BOOL res = [udpSocket sendData:[msg dataUsingEncoding:NSASCIIStringEncoding]
                                 toHost:ipAddr
                                   port:port
                            withTimeout:-1
                                    tag:0];
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
	//无法发送时,返回的异常提示信息
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
													message:[error description]
												   delegate:self
										  cancelButtonTitle:@"取消"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
	
}

//接收到返回消息
- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"host_=%@", host);
    NSString * recvDate = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if ([recvDate isEqualToString:conn_info]) {
        [self send:@"ios&6.0&chg" withSocket:host andPort:port];
        NSLog(@"ddjdjsljfljsdlfkjlsdkjl");
    } else {
        NSLog(@"接收到的数据:%@", recvDate);
        NSMutableArray * temp = [self splitWithString:recvDate andChar:@"&"];
        [temp insertObject:host atIndex:3];
        [pcs insertObject:temp atIndex:pcs.count];
        
        [temp release];
        [utv reloadData];
        
        NSLog(@"pcs的长度：%i", pcs.count);
        NSLog(@"pcs:%@", pcs);
    }
    
    
    [recvDate release];
    [udpSocket receiveWithTimeout:-1 tag:1];
    
    return YES;
}



//没有接收到消息
- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error
{
	//无法接收时，返回异常提示信息
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
													message:[error description]
												   delegate:self
										  cancelButtonTitle:@"取消"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (void) showResult
{
    alert_ = [[UIAlertView alloc] initWithTitle:@"选择需要连接的设备"
													message:@"\n\n\n\n\n\n\n\n\n"
												   delegate:self
										  cancelButtonTitle:@"取消"
										  otherButtonTitles:nil];
    utv = [[UITableView alloc] initWithFrame:CGRectMake(15.0f, 50.0f, 255.0f, 180.0f)];
    utv.backgroundColor  = [UIColor clearColor];
    utv.separatorColor = [UIColor lightGrayColor];
    [utv setDataSource:self];
    [utv setDelegate:self];
    utv.rowHeight = 55;
    
    [alert_ addSubview:utv];
	[alert_ show];
}

#pragma mark -- 实现TableView数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [pcs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([pcs count] == 0) {
        return nil;
    }
	static NSString *SimpleCellIdentifier = @"SimpleCellIdentifier";
    if (!nibsRegistered) {
        UINib * uiNib = [UINib nibWithNibName:@"SearchPcListCell" bundle:nil];
        [tableView registerNib:uiNib forCellReuseIdentifier:SimpleCellIdentifier];
        nibsRegistered = YES;
    }
    
	SearchPcListCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleCellIdentifier];
    
	if (cell == nil) {
		cell = [[[SearchPcListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleCellIdentifier] autorelease];
	}
    NSInteger position = [indexPath row];
    NSMutableArray * temp = [pcs objectAtIndex:position];
    cell.name_.text = [temp objectAtIndex:2];
    cell.osInfo_.text = [[temp objectAtIndex:0] stringByAppendingString:[temp objectAtIndex:1]];
    cell.ipAddr_.text = [temp objectAtIndex:3];
    if ([[temp objectAtIndex:0] isEqualToString:@"Mac OS X"]) {
        separator = @"/";
        cell.image_.image = [UIImage imageNamed:@"mac@macx.png"];
    } else if ([[temp objectAtIndex:0] isEqualToString:@"android"]) {
        separator = @"/";
        cell.image_.image = [UIImage imageNamed:@"android@androidx.png"];
    } else if ([[temp objectAtIndex:0] isEqualToString:@"ios"]) {
        separator = @"/";
        cell.image_.image = [UIImage imageNamed:@"ios@iosx.png"];
    } else {
        separator = @"\\";
        cell.image_.image = [UIImage imageNamed:@"win@winx.png"];
    }
    
	return cell;
}

#pragma mark -- 实现TableView委托方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [alert_ dismissWithClickedButtonIndex:0 animated:YES];
    [alert_ release];
	NSInteger row = [indexPath row];
    SearchPcListCell *cell = (SearchPcListCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    [connServ initNetworkCommunicationWithIPADDR:cell.ipAddr_.text];
    [connServ sendDataWithCmd:CONN_SERVER andBody:@" "];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

    [pcs removeAllObjects];
//    [self release];
}

//字符串分割 
- (NSMutableArray *) splitWithString:(NSString*)str andChar:(NSString*)s
{
    int prePosition = 0;//上一次截取的位置
    int currPosition = 0;//需要截取的长度
    int second = 0;
    NSString * tempStr;
    NSMutableArray * contens = [[NSMutableArray alloc] init];
    const char * str_ = [str UTF8String];
    char s_ = [s UTF8String][0];
    int len = strlen(str_);
    for (int i=0; i<len; i++) {
        char temp = str_[i];
        
        if (temp == s_) {
            if (second > 0) {
                prePosition++;
            }
            if (prePosition == 1) {
                currPosition = i;
            } else {
                currPosition = i - prePosition;
            }
            tempStr = [str substringWithRange:NSMakeRange(prePosition,currPosition)];
            [contens insertObject:tempStr atIndex:second++];
            prePosition = i;
        }
    }
    tempStr = [str substringFromIndex:++prePosition];
    [contens insertObject:tempStr atIndex:second];
    return contens;
}

//alertView点击操作
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    switch (buttonIndex) {
        case 0:
            [pcs removeAllObjects];
            nibsRegistered = NO;//重置，使界面可以创新的UITableViewCell
            break;
            
        default:
            break;
    }
    
}

- (void)dealloc
{
    [udpSocket release];
    [pcs release];
    [utv release];
    [alert_ release];
    [connServ release];
    [separator release];
    [super dealloc];
}


@end
