//
//  ViewController.h
//  wifiPlayer_3.0_ios
//
//  Created by 陈 海刚 on 13-4-14.
//  Copyright (c) 2013年 陈 海刚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListViewItem.h"
#import "ConnServerManager.h"
#import "ServReplyCallBack.h"
#import "SBJson.h"
#import "DDAlertPrompt.h"
#import "SearchPc.h"
#import "ShareCell.h"
#import "MiidiAdView.h"
#import "MiidiAdViewDelegate.h"

#import "MiidiAdWallSpendPointsDelegate.h"
#import "MiidiAdWallAwardPointsDelegate.h"
#import "MiidiAdWallGetPointsDelegate.h"
#import "MiidiAdWallShowAppOffersDelegate.h"
#import "MiidiAdWall.h"


@interface ViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,UIAlertViewDelegate,ServReplyCallBack,UIActionSheetDelegate,MiidiAdViewDelegate,MiidiAdWallShowAppOffersDelegate
, MiidiAdWallAwardPointsDelegate
, MiidiAdWallSpendPointsDelegate
, MiidiAdWallGetPointsDelegate>
{
    NSMutableArray * files;
    UITableView * filesTableView;
    UIView * view;
//    ConnServerManager * conn;
    ConnServerManager * connServ;
//    NSMutableDictionary* files;
    NSInteger currClick;
    NSArray * shareName;
    NSArray * shareImg;
    UIActionSheet * as;
    MiidiAdView * adView;
}

@property (nonatomic, retain) NSMutableArray * files;
@property (nonatomic, retain) IBOutlet UITableView * filesTableView;
@property (nonatomic, retain) ConnServerManager * connServ;
@property (nonatomic, retain) NSArray * shareName;
@property (nonatomic, retain) NSArray * shareImg;
@property (nonatomic, retain) UIActionSheet * as;
@property (nonatomic, retain) MiidiAdView * adView;
@property (nonatomic, retain) UIView * view;


-(IBAction) shareBtnClick:(id)sender;//分享按钮

-(IBAction) recommendBtnClick:(id)sender;//推荐软件

-(IBAction) connPcBtnClick:(id)sender;//连接电脑

-(IBAction) mainBtnClick:(id)sender;//主目录

-(NSString*) getFileSuffix:(NSString*)filePath;//获取文件的后缀名

@end
