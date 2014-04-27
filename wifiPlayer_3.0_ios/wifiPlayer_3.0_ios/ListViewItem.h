//
//  ListViewItem.h
//  wifiPlayer_3.0_ios
//
//  Created by 陈 海刚 on 13-4-14.
//  Copyright (c) 2013年 陈 海刚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListViewItem : UITableViewCell

@property(nonatomic, retain) IBOutlet UILabel * name;
@property(nonatomic, retain) IBOutlet UILabel * size;
@property(nonatomic, retain) IBOutlet UILabel * createTime;
@property(nonatomic, retain) IBOutlet UIImageView * image_;

@end
