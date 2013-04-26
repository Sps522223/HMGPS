//
//  HMSocket.h
//  HMGPS
//
//  Created by Xiaohui Guo on 13-4-23.
//  Copyright (c) 2013年 PERSONAL OUT_SOFTWARE TECHNOLOGY CO.LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"

/*
 连线测试位置:61.222.88.242:10151 (TCP)
 测试帐号:三个都是uni
 */

#define SOCKET_IP      @"61.222.88.242"
#define SOCKET_PORT    10151


@protocol HMSocketDelegate <NSObject>

-(void)socket:(AsyncSocket *)socket recivedMessage:(NSString *)receive;

@end


@interface HMSocket : NSObject{
    AsyncSocket *asyncSocket;
    NSError *error;
    BOOL connect;
    NSMutableData *mutableData;
    NSString *lastChar;
    NSString *receivedString;
}

@property(nonatomic,assign)id<HMSocketDelegate>delegate;

+(HMSocket *)sharedSocket;

-(void)sendMessage:(NSString *)message delegate:(id<HMSocketDelegate>)_delegate;//发送消息

@end
