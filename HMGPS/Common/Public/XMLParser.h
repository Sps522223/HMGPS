//
//  XMLParser.h
//  kaiyuanproject
//
//  Created by 杨 隐峰 on 12-3-16.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface XMLParser : NSObject<NSXMLParserDelegate> {

	
}

-(void)parseXMLFileWithString:(NSString *)dataStr;

@end
