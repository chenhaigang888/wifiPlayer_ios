//
//  ServReplyCallBack.h
//  wifiPlayer_3.0_ios
//
//  Created by 陈 海刚 on 13-4-30.
//  Copyright (c) 2013年 陈 海刚. All rights reserved.
//

#import <Foundation/Foundation.h>
//服务器返回，回调
@protocol ServReplyCallBack <NSObject>

-(void) recvCmd:(int)cmd andBody:(char*)body;
@end
