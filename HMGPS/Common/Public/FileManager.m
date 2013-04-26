//
//  FileManager.m
//  TaxiTest
//
//  Created by Xiaohui Guo  on 13-3-20.
//  Copyright (c) 2013年 FJKJ. All rights reserved.
//

#import "FileManager.h"

@implementation FileManager

#define DOCUMENTS [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

//获取图片文件夹路径
+(NSString *)getImageForderpath{
    NSString *imagePath=[DOCUMENTS stringByAppendingPathComponent:@"images"];
    return imagePath;
}
//根据图片名获取下载图片路径
+(NSString *)getImagePathWithFileName:(NSString *)fileName{
    if (fileName==nil||[fileName isEqualToString:@""]) {
        NSLog(@"No such image exits ,fileName is %@",fileName);
        return nil;
    }
    NSString *path=[[self getImageForderpath] stringByAppendingPathComponent:[fileName lastPathComponent]];
    //LOG(@"image path :%@",path);
    return path;
}

+(void)setFilePackage:(NSString *)packageName{
    NSString *filePath=[DOCUMENTS stringByAppendingPathComponent:packageName];
    BOOL isExists=[[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if (isExists) {
        
    }else{
        BOOL success= [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
        if (success) {
            NSLog(@"create package %@ successed!",packageName);
        }else{
            NSLog(@"create package failed!");
        }
    }
    
}

+(NSDictionary *)getDictWithKey:(NSString *)key{
    NSString *plistPath=[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Resource.plist"];
    NSDictionary *dict=[[NSDictionary dictionaryWithContentsOfFile:plistPath] objectForKey:key];
    return dict;
}

@end
