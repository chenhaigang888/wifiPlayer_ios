//
//  SearchPcListCell.m
//  wifiPlayer_3.0_ios
//
//  Created by 陈 海刚 on 13-5-3.
//  Copyright (c) 2013年 陈 海刚. All rights reserved.
//

#import "SearchPcListCell.h"

@interface SearchPcListCell()

@end

@implementation SearchPcListCell


@synthesize image_;
@synthesize name_;
@synthesize osInfo_;
@synthesize ipAddr_;

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
    [name_ release];
    [osInfo_ release];
    [ipAddr_ release];
    [super dealloc];
}

@end
