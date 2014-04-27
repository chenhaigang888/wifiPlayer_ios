//
//  ShareCell.m
//  wifiPlayer_3.0_ios
//
//  Created by 陈 海刚 on 13-5-9.
//  Copyright (c) 2013年 陈 海刚. All rights reserved.
//

#import "ShareCell.h"

@implementation ShareCell

@synthesize image_;
@synthesize shareText;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [image_ release];
    [shareText release];
    [super dealloc];
}

@end
