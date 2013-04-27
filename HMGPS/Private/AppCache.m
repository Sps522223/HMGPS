//
//  AppCache.m
//  HMGPS
//
//  Created by Xiaohui Guo on 13-4-23.
//  Copyright (c) 2013年 PERSONAL OUT_SOFTWARE TECHNOLOGY CO.LTD. All rights reserved.
//

#import "AppCache.h"


@implementation AppCache

+(void)saveLoginInfo:(NSDictionary *)loginInfoDict{
    if (nil!=loginInfoDict) {
        [[NSUserDefaults standardUserDefaults]setObject:loginInfoDict forKey:LOGIN_INFO];
    }
    
}

+(NSDictionary *)loginInfo{
    return [[NSUserDefaults standardUserDefaults]objectForKey:LOGIN_INFO];
}

+(void)saveLoginInfoWithBool:(BOOL)save{
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithBool:save] forKey:IS_SAVE_INFO];
}

+(BOOL)isSaveLoginInfo{
    return [[[NSUserDefaults standardUserDefaults]objectForKey:IS_SAVE_INFO] boolValue];
}

+(void)saveIsShowPwdWithBool:(BOOL)show{
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithBool:show] forKey:SHOW_PWD];
}

+(BOOL)isShowPwd{
    return [[[NSUserDefaults standardUserDefaults]objectForKey:SHOW_PWD] boolValue];
}

@end
