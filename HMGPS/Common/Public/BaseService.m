//
//  BaseService.m
//  
//
//  Created by Xiaohui Guo  on 12-7-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseService.h"

@implementation BaseService


+(NSString *)postRequest:(NSString *)url withParam:(NSString *)param{
    NSLog(@"%@?%@",url,param);
    NSString *responseString = nil;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    if(param != nil){
        NSData *postData = [param dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]; 
        [request setHTTPBody:postData];
    }
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    
    NSURLResponse *reponse;
    NSError *error = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&reponse error:&error];
    if (error) {
        NSLog(@"Something wrong: %@",[error description]);
    }else {
        if (responseData) {
            responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        }
    }
    return [responseString autorelease];
}


+(NSString *)getResponseWithUrl:(NSString *)url{
    NSURLRequest *request=[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    NSData *received=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *responseString=[[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    [request release];
    //NSLog(@"ResponseString:%@",responseString);
    return [responseString autorelease];
}

@end
