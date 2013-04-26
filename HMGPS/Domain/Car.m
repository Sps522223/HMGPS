//
//  Car.m
//  HMGPS
//
//  Created by Xiaohui Guo on 13-4-24.
//  Copyright (c) 2013年 PERSONAL OUT_SOFTWARE TECHNOLOGY CO.LTD. All rights reserved.
//

#import "Car.h"

@implementation Car
@synthesize cID;
@synthesize longitude;
@synthesize latitude;
@synthesize status;
@synthesize plateNumber;
@synthesize speed;
@synthesize direction;
@synthesize statellite;
@synthesize acc;
@synthesize driver;
@synthesize time;
@synthesize address;
@synthesize statusCode;

-(void)dealloc{
    [cID release];
    [status release];
    [plateNumber release];
    [driver release];
    [speed release];
    [direction release];
    [time release];
    [address release];
    [statusCode release];
    [super dealloc];
}

-(Car *)initWithCarInfo:(NSArray *)carInfoArray{
    self=[super init];
    if (self) {
        self.cID=[carInfoArray objectAtIndex:0];
        self.longitude=[[carInfoArray objectAtIndex:1] floatValue];
        self.latitude=[[carInfoArray objectAtIndex:2] floatValue];
        self.statusCode=[carInfoArray objectAtIndex:3];
        if ([self.statusCode isEqualToString:@"st01"]) {
            oriStatus=@"停留";
        }else if ([self.statusCode isEqualToString:@"st02"]) {
            oriStatus=@"行駛中";
        }else if ([self.statusCode isEqualToString:@"st03"]) {
            oriStatus=@"熄火";
        }else if ([self.statusCode isEqualToString:@"st04"]) {
            oriStatus=@"關機";
        }else if ([self.statusCode isEqualToString:@"st05"]) {
            oriStatus=@"無定位";
        }else{
            oriStatus=@"其他";
        }
        
        self.status=oriStatus;
        self.plateNumber=[carInfoArray objectAtIndex:4];
        self.speed=[carInfoArray objectAtIndex:5];
        angle=[[carInfoArray objectAtIndex:6] integerValue];
        if (0==angle) {
            self.direction=@"北";
        }else if(0<angle&&angle<90){
            self.direction=@"東北";
        }else if(angle==90){
            self.direction=@"東";
        }else if(90<angle&&angle<180){
            self.direction=@"東南";
        }else if(angle==180){
            self.direction=@"南";
        }else if(180<angle&&angle<270){
            self.direction=@"西南";
        }else if(angle==270){
            self.direction=@"西";
        }else if(270<angle&&angle<360){
            self.direction=@"西北";
        }
        
        self.statellite=[[carInfoArray objectAtIndex:7] integerValue];
        self.acc=[[carInfoArray objectAtIndex:8] integerValue];
        self.driver=[carInfoArray objectAtIndex:9];
        self.time=[carInfoArray objectAtIndex:10];
    }
    
    return self;
}



@end
