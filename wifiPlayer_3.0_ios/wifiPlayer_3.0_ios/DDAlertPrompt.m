//
//  DDAlertPrompt.m
//  DDAlertPrompt (Released under MIT License)
//
//  Created by digdog on 10/27/10.
//  Copyright 2010 Ching-Lan 'digdog' HUANG. http://digdog.tumblr.com
//
//  Permission is hereby granted, free of charge, to any person obtaining
//  a copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//   
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//   
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "DDAlertPrompt.h"
#import <QuartzCore/QuartzCore.h>

//=====================================================================================================

@interface DDAlertPrompt () 
@property(nonatomic, retain) UITableView *tableView;
@property(nonatomic, retain) UITextField *plainTextField;
@property(nonatomic, retain) UITextField *secretTextField;
@property(nonatomic, retain) UITextField *dataTextField;


- (void)orientationDidChange:(NSNotification *)notification;
@end


@implementation DDAlertPrompt

@synthesize tableView = tableView_;
@synthesize plainTextField = plainTextField_;
@synthesize secretTextField = secretTextField_;
@synthesize dataTextField = dataTextField_;
@synthesize mySwitch_;
@synthesize editTextArray;
@synthesize isSwitch_;

/*
-(BOOL)_needsKeyboard {
	// Private API hack by @0xced (Cedric Luthi) for possible keyboard responder issue: http://twitter.com/0xced/status/29067229352
	return [UIDevice instancesRespondToSelector:@selector(isMultitaskingSupported)];
}
*/

- (id)initWithTitle:(NSString *)title delegate:(id /*<UIAlertViewDelegate>*/)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitles editTextTitle:(NSMutableArray*)editTextArray_ isSwitch:(bool)yesOrNo{
    self.editTextArray = editTextArray_;
    self.isSwitch_ = yesOrNo;
    
    if ((self = [super initWithTitle:title message:[self constructionString:[editTextArray count] isSwitch:yesOrNo] delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil])) {
		// FIXME: This is a workaround. By uncomment below, UITextFields in tableview will show characters when typing (possible keyboard reponder issue).
		if ([editTextArray count]==0) {
            
        }else{
            [self addSubview:self.plainTextField];
            
            tableView_ = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
            tableView_.delegate = self;
            tableView_.dataSource = self;
            tableView_.scrollEnabled = NO;//能否滚动
            tableView_.opaque = NO;//是否有透明
            tableView_.layer.cornerRadius = 3.0f;//圆角半径
            tableView_.editing = YES;
            tableView_.rowHeight = 28.0f;
            [self addSubview:tableView_];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
            [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        }
        
	}
    
    if(yesOrNo){
        UILabel* myLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10.0f, 60.0f+28.0f*[editTextArray count], 150.0f, 28.0f)] autorelease];
        mySwitch_ = [[UISwitch alloc] initWithFrame:CGRectMake(190.0f, 60.0f+28.0f*[editTextArray count], 0, 0)];
        myLabel.text = @"关闭\\打开（开关）";
        myLabel.textColor = [UIColor whiteColor];
        myLabel.backgroundColor = [UIColor clearColor];
        
       
        [self addSubview:mySwitch_];
        [self addSubview:myLabel];
    }
    
	return self;
}


- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
	[[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
	
	[tableView_ setDataSource:nil];
	[tableView_ setDelegate:nil];
	[tableView_ release];
    [editTextArray release];
    [mySwitch_ release];
    [super dealloc];
}

#pragma mark layout

- (void)layoutSubviews {
	// We assume keyboard is on.
	if ([[UIDevice currentDevice] isGeneratingDeviceOrientationNotifications]) {
		if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
			self.center = CGPointMake(160.0f, (460.0f - 216.0f)/2 + 12.0f);
            if (isSwitch_) {
                [self setBounds:CGRectMake(0, 0 + 12.0f, 285.0f, 40.0f+126.0f+28.0f*[editTextArray count])];
            }else{
                [self setBounds:CGRectMake(0, 0 + 12.0f, 285.0f, 126.0f+28.0f*[editTextArray count])];
            }
			self.tableView.frame = CGRectMake(12.0f, 51.0f, 260.0f, 28.0f*[editTextArray count]);//计算tableView需要多少高度
		} else {
			self.center = CGPointMake(240.0f, (300.0f - 162.0f)/2 + 12.0f);
			self.tableView.frame = CGRectMake(12.0f, 35.0f, 260.0f, 56.0f);		
		}
	}
}

- (void)orientationDidChange:(NSNotification *)notification {
	[self setNeedsLayout];
}

#pragma mark Accessors

- (UITextField *)plainTextField{
    if ([editTextArray count]!=0) {
        if (!plainTextField_) {
            plainTextField_ = [[UITextField alloc] initWithFrame:CGRectMake(5.0f, 0.0f, 255.0f, 28.0f)];
            //内容居中垂直对齐
            plainTextField_.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            //清除输入框里面原有数据的方式为：当输入的时候清除
            plainTextField_.clearButtonMode = UITextFieldViewModeWhileEditing;
            plainTextField_.placeholder = [editTextArray objectAtIndex:0];
        }
    }
	
	return plainTextField_;
}

- (UITextField *)secretTextField {
	
	if (!secretTextField_) {
		secretTextField_ = [[UITextField alloc] initWithFrame:CGRectMake(5.0f, 0.0f, 255.0f, 28.0f)];
		secretTextField_.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		secretTextField_.secureTextEntry = YES;
		secretTextField_.clearButtonMode = UITextFieldViewModeWhileEditing;
		secretTextField_.placeholder = [editTextArray objectAtIndex:1];
	}
	return secretTextField_;
}

- (UITextField *)dataTextField{
	
	if (!dataTextField_) {
		dataTextField_ = [[UITextField alloc] initWithFrame:CGRectMake(5.0f, 0.0f, 255.0f, 28.0f)];
		dataTextField_.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		dataTextField_.secureTextEntry = YES;
		dataTextField_.clearButtonMode = UITextFieldViewModeWhileEditing;
		dataTextField_.placeholder = [editTextArray objectAtIndex:2];
	}
	return dataTextField_;
}

#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [editTextArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	static NSString *AlertPromptCellIdentifier = @"DDAlertPromptCell";

    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:AlertPromptCellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:AlertPromptCellIdentifier] autorelease];
    }
	
	if (![cell.contentView.subviews count]) {
		if (indexPath.row==1) {
			[cell.contentView addSubview:self.secretTextField];			
		} else if(indexPath.row==0){
			[cell.contentView addSubview:self.plainTextField];
		}else if (indexPath.row==2){
            [cell.contentView addSubview:self.dataTextField];
        }
        
	}
    return cell;	
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

//根据editTextArray的数量来计算需要几个"\n"
-(NSString*) constructionString:(NSInteger)editTextNum isSwitch:(bool)yesOrNo
{
    NSString *temp = @"";
    switch (editTextNum) {
            
            case 0:
            temp = @"";
            break;
        case 1:
            temp = @"\n\n";
            break;
        case 2:
            temp = @"\n\n\n";
            break;
        case 3:
            temp = @"\n\n\n\n";
            break;
        default:
            break;
    }
    if (yesOrNo) {
        temp = [temp stringByAppendingString:@"\n\n"];
    }
    return temp;
}

@end
