//
//  ListViewItem.m
//  wifiPlayer_3.0_ios
//
//  Created by 陈 海刚 on 13-4-14.
//  Copyright (c) 2013年 陈 海刚. All rights reserved.
//

#import "ListViewItem.h"

@interface ListViewItem ()

@end

@implementation ListViewItem

@synthesize name;
@synthesize size;
@synthesize createTime;
@synthesize image_;

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

-(void)dealloc
{
    [name release];
    [size release];
    [createTime release];
    [image_ release];
    [super dealloc];
}

@end
