//
//  MainViewController.h
//  HMGPS
//
//  Created by Xiaohui Guo on 13-4-22.
//  Copyright (c) 2013年 PERSONAL OUT_SOFTWARE TECHNOLOGY CO.LTD. All rights reserved.
//

#import "BaseViewController.h"
#import "HMSocket.h"

@interface MainViewController : BaseViewController<HMSocketDelegate>{
    UINavigationController *loginNav;
    UILabel *infoLabel;
}

@property(nonatomic,retain)NSArray *cars;
@property(nonatomic,copy)NSString *memberInfo;
@end
