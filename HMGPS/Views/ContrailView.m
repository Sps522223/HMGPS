//
//  ContrailView.m
//  HMGPS
//
//  Created by Xiaohui Guo on 13-4-26.
//  Copyright (c) 2013年 PERSONAL OUT_SOFTWARE TECHNOLOGY CO.LTD. All rights reserved.
//

#import "ContrailView.h"

@implementation ContrailView
@synthesize numberLabel;
@synthesize plateNumberLabel;
@synthesize statusLabel;
@synthesize timeLabel;
@synthesize speedLabel;
@synthesize bgImageView;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)dealloc{
    [numberLabel release];
    [plateNumberLabel release];
    [statusLabel release];
    [timeLabel release];
    [speedLabel release];
    [bgImageView release];
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
