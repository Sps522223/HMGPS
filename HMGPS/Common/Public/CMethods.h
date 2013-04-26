//
//  CMethods.h
//  TaxiTest
//
//  Created by Xiaohui Guo  on 13-3-13.
//  Copyright (c) 2013年 FJKJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <stdio.h>


@interface CMethods : NSObject

//window 高度
CGFloat windowHeight();

//statusBar隐藏与否的高
CGFloat heightWithStatusBar();

//view 高度
CGFloat viewHeight(UIViewController *viewController);

//字体


//系统语言环境
NSString* currentLanguage();

BOOL iPhone5();

//返回随机不重复树
NSMutableArray* randrom(int count,int totalCount);
@end
