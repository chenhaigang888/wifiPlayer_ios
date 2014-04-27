//
//  OnDownloadUpdateUI.h
//  wifiPlayer_3.0_ios
//
//  Created by 陈 海刚 on 13-5-7.
//  Copyright (c) 2013年 陈 海刚. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OnDownloadUpdateUI <NSObject>

-(void) updateUI:(NSString*)f;

-(void) downloadBefore;

-(void) downloadFinish;
@end
