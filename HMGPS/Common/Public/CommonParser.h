//
//  RegisterParser.h
//  Aviation
//
//  Created by Xiaohui Guo on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "XMLParser.h"

@protocol CommonParserDelegate <NSObject>

-(void)parserFinishedWithString:(NSString *)string;//解析结束后的回调方法

@end



/*
 string :要解析的字符串
 delegate:回调
 
 e.g.
 CommonParser *commonParser=[[CommonParser alloc]init];
 [commonParser setDelegate:self];
 [commonParser parseXMLFileWithString:string];
 [commonParser release];
 
 */

@interface CommonParser : XMLParser<NSXMLParserDelegate>{
    
    NSMutableString *mutableString;

}                                                           
@property(nonatomic,assign)id<CommonParserDelegate>delegate;
@property(nonatomic,retain)NSString *commonStr;

@end
