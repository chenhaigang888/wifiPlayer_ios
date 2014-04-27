//
//  ViewController.m
//  wifiPlayer_3.0_ios
//
//  Created by 陈 海刚 on 13-4-14.
//  Copyright (c) 2013年 陈 海刚. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize files;
@synthesize filesTableView;
@synthesize connServ;
@synthesize shareName;
@synthesize shareImg;
@synthesize as;
@synthesize adView;

//@synthesize conn;

static BOOL shareView = NO;


-(IBAction) shareBtnClick:(id)sender
{
    as = [[UIActionSheet alloc] initWithTitle:@"分享给朋友\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n" delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles: nil];
    
    UITableView * shareTable = [[UITableView alloc] initWithFrame:CGRectMake(17.0f, 50.0f, 290.0f, 230.0f)];
    shareTable.backgroundColor = [UIColor clearColor];
    shareTable.separatorColor = [UIColor clearColor];
    shareTable.rowHeight = 55;
    
    [shareTable setDataSource:self];
    [shareTable setDelegate:self];
    [shareTable setTag:1];
    [shareTable setScrollEnabled:NO];
    [as addSubview:shareTable];
    [as showInView:self.view];
    [as release];
}

//应用推荐
-(IBAction) recommendBtnClick:(id)sender
{
    [MiidiAdWall showAppOffers:self withDelegate:self];
}

+ (BOOL)showAppOffers: (UIViewController*)hostViewController withDelegate: (id<MiidiAdWallShowAppOffersDelegate>) delegate
{
    return YES;
}


-(IBAction) connPcBtnClick:(id)sender
{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"连接电脑"
                                                         message:@"请选择"
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                               otherButtonTitles:@"搜索",@"IP", nil];
    [alertView setTag:1];
    [alertView show];
    [alertView release];
}

-(IBAction) mainBtnClick:(id)sender
{
    
    [connServ sendDataWithCmd:CONN_SERVER andBody:@" "];
    
}

#pragma mark -- 实现TableView数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    switch (tableView.tag) {
        case 0:
            count = [files count];
            break;
        case 1:
            count = [shareName count];
            break;
            
        default:
            break;
    }
	return count;
}

-(UITableViewCell *) showPcFileListWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleCellIdentifier = @"SimpleCellIdentifier";
    static BOOL nibsRegistered = NO;
    
    if (!nibsRegistered) {
        UINib * uiNib = [UINib nibWithNibName:@"ListViewItem" bundle:nil];
        [tableView registerNib:uiNib forCellReuseIdentifier:SimpleCellIdentifier];
        nibsRegistered = YES;
    }
    
	ListViewItem *cell = [tableView dequeueReusableCellWithIdentifier:SimpleCellIdentifier];
    
	if (cell == nil) {
		cell = [[[ListViewItem alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleCellIdentifier] autorelease];
	}
    NSInteger position = [indexPath row];
    
    cell.name.text = [[files objectAtIndex:position] objectForKey:@"name"];
    cell.createTime.text = [[files objectAtIndex:position] objectForKey:@"createDate"];
    cell.size.text = [[files objectAtIndex:position] objectForKey:@"size"];
	
    UIImage * imges = nil;
    NSString * isSys = [[files objectAtIndex:position] objectForKey:@"sys"] ;
    NSString * isDir = [[files objectAtIndex:position] objectForKey:@"dir"];
    NSString * path = [[[files objectAtIndex:position] objectForKey:@"path"] lowercaseStringWithLocale:[NSLocale currentLocale]];
    
    if ((position == 0) && ![isSys isEqualToString:@"true"]) {
        imges = [UIImage imageNamed:@"pre@prex.png"];
    } else {
        if ([isSys isEqualToString:@"true"]) {//判断是否为系统分区
            imges = [UIImage imageNamed:@"dir@dirx.png"];
        } else {
            if ([isDir isEqualToString:@"true"]) {//判断是否为文件夹
                imges = [UIImage imageNamed:@"dir@dirx.png"];
            } else {//如果是文件
                if ([path hasSuffix:@"mp3"] || [path hasSuffix:@"wma"] || [path hasSuffix:@"wav"] || [path hasSuffix:@"ape"] || [path hasSuffix:@"flac"] || [path hasSuffix:@"aac"] || [path hasSuffix:@"m4a"]) {
                    imges = [UIImage imageNamed:@"music@musicx.png"];
                } else if ([path hasSuffix:@"mp4"] || [path hasSuffix:@"wmv"] || [path hasSuffix:@"rm"] || [path hasSuffix:@"rmvb"] || [path hasSuffix:@"mkv"] || [path hasSuffix:@"tp"] || [path hasSuffix:@"ts"] || [path hasSuffix:@"mov"] || [path hasSuffix:@"3gp"] || [path hasSuffix:@"avi"]){
                    imges = [UIImage imageNamed:@"video@videox.png"];
                } else if ([path hasSuffix:@"zip"] || [path hasSuffix:@"rar"]){
                    imges = [UIImage imageNamed:@"zip@zipx.png"];
                } else if ([path hasSuffix:@"png"] || [path hasSuffix:@"jpeg"] || [path hasSuffix:@"jpg"] || [path hasSuffix:@"gif"] || [path hasSuffix:@"bmp"]){
                    imges = [UIImage imageNamed:@"pic@picx.png"];
                } else {
                    imges = [UIImage imageNamed:@"white@whitex.png"];
                }
            }
        }
    }
    
    cell.image_.image = imges;
    return cell;
}

-(UITableViewCell *) showShareTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleCellIdentifier = @"ShareSimpleCellIdentifier";
    
    if (!shareView) {
        UINib * uiNib = [UINib nibWithNibName:@"ShareCell" bundle:nil];
        [tableView registerNib:uiNib forCellReuseIdentifier:SimpleCellIdentifier];
        shareView = YES;
    }
    
	ShareCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleCellIdentifier];
    
	if (cell == nil) {
		cell = [[[ShareCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleCellIdentifier] autorelease];
	}
    NSInteger position = [indexPath row];
    cell.image_.image = [UIImage imageNamed:[shareImg objectAtIndex:position]];
    cell.shareText.text = [shareName objectAtIndex:position];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = nil;
    switch (tableView.tag) {
        case 0:
            cell = [self showPcFileListWithTableView:tableView cellForRowAtIndexPath:indexPath];
            break;
        case 1:
            cell = [self showShareTableView:tableView cellForRowAtIndexPath:indexPath];
            break;
        default:
            break;
    }
	
	return cell;
}

-(void)pcFileClickWithTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    currClick = row;
    ListViewItem *cell = (ListViewItem*)[tableView cellForRowAtIndexPath:indexPath];
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"操作"
                                                         message:cell.name.text
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                               otherButtonTitles:@"打开文件",@"删除文件",@"拷贝到手机", nil];
    [alertView setTag:2];
    [alertView show];
    [alertView release];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)shareClickWithTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    shareView = NO;
    NSInteger row = [indexPath row];
    [as dismissWithClickedButtonIndex:0 animated:YES];
    
    switch (row) {
        case 0:
            NSLog(@"新浪微博");
            break;
        case 1:
            NSLog(@"腾讯微博");
            break;
        case 2:
            NSLog(@"E-mail");
            break;
        case 3:
            NSLog(@"取消");
            break;
        default:
            break;
    }
}

#pragma mark -- 实现TableView委托方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (tableView.tag) {
        case 0:
            [self pcFileClickWithTableView:tableView didSelectRowAtIndexPath:indexPath];
            break;
        case 1:
            [self shareClickWithTableView:tableView didSelectRowAtIndexPath:indexPath];
            break;
        default:
            break;
    }
}

//alertView点击操作
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   
    switch (alertView.tag) {
        case 0:
            
            break;
        case 1:
        [self connPcAlertViewClickWithBtnIndex:buttonIndex];
            break;
        case 2:
            [self fileOpWithBtnIndex:buttonIndex];
            break;
        case 3:
            [self inputIPAddrAlertViewWithBtnIndex:buttonIndex andAlertView:alertView];
            break;
        default:
            break;
    }
    
}

//输入ipAddr输入框的事件
- (void) inputIPAddrAlertViewWithBtnIndex:(NSInteger)btnIndex andAlertView:(UIAlertView *)alertView
{
    DDAlertPrompt * prompt = nil;
    SearchPc * spc;
    NSString * ipAddr;
    if ([alertView isKindOfClass:[DDAlertPrompt class]]) {
        prompt = (DDAlertPrompt*)alertView;
    }
    switch (btnIndex) {
        case 0:
            break;
        case 1:
            ipAddr = prompt.plainTextField.text;
            spc = [[SearchPc alloc] initWithViewController:self];
            [spc send:info withSocket:ipAddr andPort:9527];
            self.connServ = spc.connServ;
            break;
        default:
            break;
    }
}

//连接电脑操作
- (void) connPcAlertViewClickWithBtnIndex:(NSInteger)btnIndex
{
    DDAlertPrompt * prompt = nil;
    NSMutableArray* editTextArray = nil;
    SearchPc * spc = nil;
    switch (btnIndex) {
        
        case 1:
            spc = [[SearchPc alloc] initWithViewController:self];
            [spc send:info withSocket:searchAddr andPort:9527];
            self.connServ = spc.connServ;
            break;
        case 2:
            editTextArray = [[NSMutableArray alloc] init];
            [editTextArray insertObject:@"请输入你要连接的电脑ip" atIndex:0];
            prompt = [[DDAlertPrompt alloc] initWithTitle:@"IP"
                                                 delegate:self
                                        cancelButtonTitle:@"取消"
                                         otherButtonTitle:@"确定"
                                            editTextTitle:editTextArray
                                                 isSwitch:NO];
            prompt.tag = 3;
            [prompt show];
            [prompt release];
            break;
        default:
            break;
    }
}

//操作文件的方法
- (void) fileOpWithBtnIndex:(NSInteger)btnIndex
{
    NSString * fileName = [[files objectAtIndex:currClick] objectForKey:@"name"];
    NSString * currPath = [[files objectAtIndex:currClick] objectForKey:@"path"];
    NSString * isDir = [[files objectAtIndex:currClick] objectForKey:@"dir"];
    NSString * isSys = [[files objectAtIndex:currClick] objectForKey:@"sys"];
    NSInteger cmd = 0;//当前发送的控制命令
    switch (btnIndex) {
        case 1:
            
                if ([isSys isEqualToString:@"true"]) {//如果是系统目录
                    if ([[SearchPc getSeparator] isEqualToString:@"/"]) {
                        currPath = @"/";
                    } else {
                        currPath = fileName;
                    }
                    
                    cmd = OPEN_DIR;
                } else {//如果是文件夹或者文件
                    if (currClick == 0) {//如果为0，表示点击的是返回上一页目录选项
                        if ([currPath isEqualToString:@""]) {
                            cmd = CONN_SERVER;
                            currPath = @" ";
                        } else {
                            currPath = [self subString:currPath with:[SearchPc getSeparator]];
                            
                            if ([currPath isEqualToString:@""]) {
                                cmd = CONN_SERVER;
                                currPath = @" ";
                            } else {
                                cmd = OPEN_DIR;
                            }
                        }
                    } else {
                        if ([isDir isEqualToString:@"true"]) {//如果不是文件夹
                            cmd = OPEN_DIR;
                        } else {
                            cmd = OPEN_FILE;
                        }
                    }
                    
                }
            [connServ sendDataWithCmd:cmd andBody:currPath];
            break;
        case 2:
            [connServ sendDataWithCmd:DEL_FILE andBody:currPath];
            break;
        case 3:
            [connServ setDownLoadFileName:fileName];
            [connServ sendDataWithCmd:COPY_FILE_2_PHONE andBody:currPath];
            break;
        default:
            break;
    }
}

//截取字符串
-(NSString*) subString:(NSString*)str with:(NSString*)pointStr
{
    NSString * ss = @"";
    const char * cc = [str UTF8String];
    char c = [pointStr UTF8String][0];
    int position;
    int len = strlen(cc);
    for (int i=len; i>=0; i--) {
        char cs = cc[i];
        if (cs == c) {
            position = i;
            break;
        }
    }
    if (position == 0) {
        return ss;
    }
        ss = [str substringToIndex:position];
    return ss;
}

//服务器返回信息
-(void) recvCmd:(int)cmd andBody:(char*)body
{
    NSString * bodys = [NSString stringWithUTF8String:body];
//    NSLog(@"这个地方收到的内容：%@", bodys);
    self.files = [bodys JSONValue];
    [filesTableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    filesTableView.tag = 0;
    files = [[NSMutableArray alloc] init];
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    
    if (height == 480.0) {
        CGRect rectf = filesTableView.bounds;
        rectf.size.height = 338;
        [filesTableView setBounds:rectf];
        
    }
    NSLog(@"height:%f",height);
    
    //初始化分享视图内容
    NSArray * shareImg_ = [[NSArray alloc] initWithObjects:@"sina@sinax.png",@"tx@txx.png",@"eamil@eamilx.png",@"cancel@cancelx.png", nil];
    NSArray * shareName_ = [[NSArray alloc] initWithObjects:@"新浪微博",@"腾讯微博",@"E-mail",@"取消", nil];
    self.shareName = shareName_;
    self.shareImg = shareImg_;
    [shareName_ release];
    [shareImg_ release];
    //添加广告
    [self addAdView];
	// Do any additional setup after loading the view, typically from a nib.
}

// 请求广告条数据成功后调用
//
// 详解:当接收服务器返回的广告数据成功后调用该函数
// 补充：第一次返回成功数据后调用
- (void)didReceiveAd:(MiidiAdView *)adView;
{
    
}

// 请求广告条数据失败后调用
//
// 详解:当接收服务器返回的广告数据失败后调用该函数
// 补充：第一次和接下来每次如果请求失败都会调用该函数
- (void)didFailReceiveAd:(MiidiAdView *)adView  error:(NSError *)error
{
    
}


// 显示全屏广告成功后调用
//
// 详解:显示一次全屏广告内容后调用该函数
- (void)didShowAdWindow:(MiidiAdView *)adView
{
    
}

// 成功关闭全屏广告后调用
//
// 详解:全屏广告显示完成，关闭全屏广告后调用该函数
- (void)didDismissAdWindow:(MiidiAdView *)adView
{
    
}





#pragma mark -
#pragma mark  MiidiAdWallShowAppOffersDelegate


// 请求应用列表成功
//
// 详解:
//      广告墙请求成功后回调该方法
// 补充:

//
- (void)didReceiveOffers{
}

// 请求应用列表失败
//
// 详解:
//      广告墙请求失败后回调该方法
// 补充:

//
- (void)didFailToReceiveOffers:(NSError *)error{
}

#pragma mark Screen View Notification Methods

// 显示全屏页面
//
// 详解:
//      全屏页面显示完成后回调该方法
// 补充:

//
- (void)didShowWallView{
}

// 隐藏全屏页面
//
// 详解:
//      全屏页面隐藏完成后回调该方法
// 补充:

//
- (void)didDismissWallView{
}





///广告
-(void) addAdView
{
//    // 创建广告条实例
    MiidiAdView *adView_ = [[MiidiAdView alloc]initMiidiAdViewWithContentSizeIdentifier:MiidiAdSize320x50 delegate:self];
	
    // 设置位置
    CGRect frame1 = adView_.frame;
    frame1.origin.x = 0;
    frame1.origin.y = 0;
    adView_.frame = frame1;
    
    [self.view addSubview:adView_];
    [adView release];
}


- (void)dealloc
{
    [filesTableView release];
    [files release];
    [connServ release];
    [shareImg release];
    [shareName release];
    [as release];
    [adView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
