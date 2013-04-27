//
//  AppCache.h
//  HMGPS
//
//  Created by Xiaohui Guo on 13-4-23.
//  Copyright (c) 2013年 PERSONAL OUT_SOFTWARE TECHNOLOGY CO.LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 存放緩存數據
 
 */

#define LOGIN_INFO    @"Login_Info"
#define IS_SAVE_INFO @"Is_Save"
#define ACCOUNT       @"Account"
#define ID             @"id"
#define PWD            @"Pwd"
#define SHOW_PWD     @"Show_PWD"


@interface AppCache : NSObject

+(void)saveLoginInfo:(NSDictionary *)loginInfoDict;

+(NSDictionary *)loginInfo;

+(void)saveLoginInfoWithBool:(BOOL)save;

+(BOOL)isSaveLoginInfo;

+(void)saveIsShowPwdWithBool:(BOOL)show;

+(BOOL)isShowPwd;

@end
