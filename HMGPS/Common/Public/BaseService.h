//
//  BaseService.h
//  phoneChatGirl
//
//  Created by Xiaohui Guo  on 12-7-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "SBJSON.h"
/*
 
 NSString *url =[NSString stringWithFormat:@"%@a_member!login.action",[SysConfig getWebApi]];
 NSString *param=[NSString stringWithFormat:@"username=%@&password=%@",[dict objectForKey:@"userName"],[dict objectForKey:@"password"]];
 NSString *responseString=[self postRequest:url withParam:param];
 */

@interface BaseService : NSObject

+(NSString *)postRequest:(NSString *)url withParam:(NSString *)param;


+(NSString *)getResponseWithUrl:(NSString *)url;

@end
