//
//  Car.h
//  HMGPS
//
//  Created by Xiaohui Guo on 13-4-24.
//  Copyright (c) 2013年 PERSONAL OUT_SOFTWARE TECHNOLOGY CO.LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Car : NSObject{
    NSString *oriStatus;
    int angle;
}


@property(nonatomic,copy)NSString *cID;
@property(nonatomic,assign)float longitude;
@property(nonatomic,assign)float latitude;
@property(nonatomic,copy)NSString *status;
@property(nonatomic,copy)NSString *plateNumber;//车牌
@property(nonatomic,copy)NSString *speed;
@property(nonatomic,copy)NSString *direction;//方位角
@property(nonatomic,assign)int statellite;//卫星
@property(nonatomic,assign)int acc;
@property(nonatomic,copy)NSString *driver;
@property(nonatomic,copy)NSString *time;
@property(nonatomic,copy)NSString *address;
@property(nonatomic,copy)NSString *statusCode;

-(Car *)initWithCarInfo:(NSArray *)carInfoArray;

@end
