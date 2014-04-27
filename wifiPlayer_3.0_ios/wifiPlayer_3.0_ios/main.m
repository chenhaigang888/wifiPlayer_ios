//
//  main.m
//  wifiPlayer_3.0_ios
//
//  Created by 陈 海刚 on 13-4-14.
//  Copyright (c) 2013年 陈 海刚. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import "MiidiManager.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
        
        //
        // 设置发布应用的应用id, 应用密码等信息,必须在应用启动的时候呼叫
        // 参数 appID		:开发者应用ID ;     开发者到 www.miidi.net 上提交应用时候,获取id和密码
        // 参数 appPassword	:开发者的安全密钥 ;  开发者到 www.miidi.net 上提交应用时候,获取id和密码
        // 参数 testMode		:广告条请求模式 ;    正式发布应用,务必设置为NO,否则不能计费
        //
        [MiidiManager setAppPublisher:@"12675"  withAppSecret:(NSString*)@"9mmg9fb965l2a3pw" withTestMode:(BOOL) NO];
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
