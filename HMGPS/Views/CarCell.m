//
//  CarCell.m
//  HMGPS
//
//  Created by Xiaohui Guo on 13-4-24.
//  Copyright (c) 2013年 PERSONAL OUT_SOFTWARE TECHNOLOGY CO.LTD. All rights reserved.
//

#import "CarCell.h"

@implementation CarCell
@synthesize numberLabel;
@synthesize speedLabel;
@synthesize statusLabel;
@synthesize plateNumberLabel;
@synthesize infoLabel;

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

-(void)dealloc{
    [numberLabel release];
    [speedLabel release];
    [statusLabel release];
    [plateNumberLabel release];
    [infoLabel release];
    [super dealloc];
}


@end
