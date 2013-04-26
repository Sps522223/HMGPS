//
//  RegisterParser.m
//  Aviation
//
//  Created by Xiaohui Guo  on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CommonParser.h"

@implementation CommonParser
@synthesize commonStr;
@synthesize delegate;

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    //注册登录
    NSLog(@"didStart_elementName:%@",elementName);
    if ([elementName isEqualToString:@"body"]) {
        mutableString=[NSMutableString string];
    }
    
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    [mutableString appendString:string];
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    NSLog(@"elementName:%@",elementName);
    if ([elementName isEqualToString:@"body"]) {
        self.commonStr=mutableString;
    }
}

-(void)parserDidEndDocument:(NSXMLParser *)parser{
    NSLog(@"Parser str:%@",self.commonStr);
    if ([delegate respondsToSelector:@selector(parserFinishedWithString:)]) {
        [delegate parserFinishedWithString:commonStr];
    }
}
@end
