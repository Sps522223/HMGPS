//
//  CarCell.h
//  HMGPS
//
//  Created by Xiaohui Guo on 13-4-24.
//  Copyright (c) 2013年 PERSONAL OUT_SOFTWARE TECHNOLOGY CO.LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarCell : UITableViewCell

@property(nonatomic,retain)IBOutlet UILabel *numberLabel;
@property(nonatomic,retain)IBOutlet UILabel *plateNumberLabel;
@property(nonatomic,retain)IBOutlet UILabel *statusLabel;
@property(nonatomic,retain)IBOutlet UILabel *speedLabel;
@property(nonatomic,retain)IBOutlet UILabel *infoLabel;
@end
