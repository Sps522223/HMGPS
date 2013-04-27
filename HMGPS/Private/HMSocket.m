//
//  HMSocket.m
//  HMGPS
//
//  Created by Xiaohui Guo on 13-4-23.
//  Copyright (c) 2013年 PERSONAL OUT_SOFTWARE TECHNOLOGY CO.LTD. All rights reserved.
//

#import "HMSocket.h"

@interface HMSocket ()
-(void)connectServer;//连接服务器
@end


@implementation HMSocket
@synthesize delegate;

-(void)dealloc{
    [mutableData release];
    [asyncSocket release];
    [receivedString release];
    [super dealloc];
}

static HMSocket *hmSocket;
+(HMSocket *)sharedSocket{
    if (hmSocket==nil) {
        hmSocket=[[HMSocket alloc]init];
    }
    return hmSocket;
}


-(void)connectServer{
    
    if (nil==asyncSocket) {
        asyncSocket=[[AsyncSocket alloc]initWithDelegate:self];
    }
    error= nil;
    connect=[asyncSocket connectToHost:SOCKET_IP onPort:SOCKET_PORT error:&error];
    
    if(!connect)
    {
        DLog(@"Error: %@", error);
    }else{
        DLog(@"Connect!");
    }
}

-(void)sendMessage:(NSString *)message delegate:(id<HMSocketDelegate>)_delegate{
    self.delegate=_delegate;
    if (![asyncSocket isConnected]) {
        [self connectServer];
    }
    
    DLog(@"Send message :%@",message);
    mutableData=nil;
    mutableData=[[NSMutableData alloc] init];
    NSData* aData= [message dataUsingEncoding:NSUTF8StringEncoding];
    [asyncSocket writeData:aData withTimeout:-1 tag:1];
    [asyncSocket readDataWithTimeout:-1 tag:0];
}


#pragma mark - AsyncSocket Delegate method

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    DLog(@"onSocket:%p didConnectToHost:%@ port:%hu", sock, host, port);
    [sock readDataWithTimeout:-1 tag:0];
}

-(void) onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    [mutableData appendData:data];
    receivedString= [[NSString alloc] initWithData:mutableData encoding:NSUTF8StringEncoding];
    lastChar=[receivedString substringWithRange:NSMakeRange([receivedString length]-1, 1)];
    if ([lastChar isEqualToString:@"*"]) {
        DLog(@"===%@",receivedString);
        if ([delegate respondsToSelector:@selector(socket:recivedMessage:)]) {
            [delegate socket:sock recivedMessage:receivedString];
        }
        
    }
    
    [sock readDataWithTimeout:-1 tag:0];
}

- (void)onSocket:(AsyncSocket *)sock didSecure:(BOOL)flag
{
    NSLog(@"onSocket:%p didSecure:YES", sock);
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    NSLog(@"onSocket:%p willDisconnectWithError:%@", sock, err);
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    //断开连接了
    NSLog(@"onSocketDidDisconnect:%p", sock);
}


@end
