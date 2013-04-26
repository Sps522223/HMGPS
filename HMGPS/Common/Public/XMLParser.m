//
//  XMLParser.m
//  kaiyuanproject
//
//  Created by 杨 隐峰 on 12-3-16.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "XMLParser.h"


@implementation XMLParser

-(void)parseXMLFileWithString:(NSString *)dataStr{
    NSData *data=[dataStr dataUsingEncoding:NSUTF8StringEncoding];
	NSXMLParser *parser=[[NSXMLParser alloc] initWithData:data];
	[parser setDelegate:self];
	[parser setShouldProcessNamespaces:NO];
	[parser setShouldReportNamespacePrefixes:NO];
	[parser setShouldResolveExternalEntities:NO];
	[parser parse];
	
	NSLog(@"这里是XMLParser 解析到此结束");
}
@end
