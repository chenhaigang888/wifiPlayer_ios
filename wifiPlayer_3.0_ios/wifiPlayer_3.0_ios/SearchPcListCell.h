//
//  SearchPcListCell.h
//  wifiPlayer_3.0_ios
//
//  Created by 陈 海刚 on 13-5-3.
//  Copyright (c) 2013年 陈 海刚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchPcListCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UIImageView * image_;
@property (nonatomic, retain) IBOutlet UILabel * name_;
@property (nonatomic, retain) IBOutlet UILabel * osInfo_;
@property (nonatomic, retain) IBOutlet UILabel * ipAddr_;

@end
