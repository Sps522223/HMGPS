//
//  FileManager.h
//  TaxiTest
//
//  Created by Xiaohui Guo  on 13-3-20.
//  Copyright (c) 2013年 FJKJ. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 管理下载类
 */

@interface FileManager : NSObject

//Document 用于存放图片等的文件夹
+(void)setFilePackage:(NSString *)packageName;

//获取图片文件夹路径
+(NSString *)getImageForderpath;

//根据图片名获取下载图片路径
+(NSString *)getImagePathWithFileName:(NSString *)fileName;

//获取法令pislt文件
+(NSDictionary *)getDictWithKey:(NSString *)key;

@end
