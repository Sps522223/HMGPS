//
//  CMethods.m
//  TaxiTest
//
//  Created by Xiaohui Guo  on 13-3-13.
//  Copyright (c) 2013年 FJKJ. All rights reserved.
//

#import "CMethods.h"
#import <stdlib.h>
#import <time.h>

@implementation CMethods

//window 高度
CGFloat windowHeight(){
    return [UIScreen mainScreen].bounds.size.height;
    
}

//statusBar隐藏与否的高
CGFloat heightWithStatusBar(){
    return NO==[UIApplication sharedApplication].statusBarHidden ? windowHeight()-20 :windowHeight();

}

//view 高度
CGFloat viewHeight(UIViewController *viewController){
    if (nil==viewController) {
        return heightWithStatusBar();
    }
    return YES==viewController.navigationController.navigationBarHidden ? heightWithStatusBar():heightWithStatusBar()-44;
    
}


//當前语言环境
NSString* currentLanguage()
{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString *languangeType;
    NSString* preferredLang = [languages objectAtIndex:0];
    if ([preferredLang isEqualToString:@"zh-Hant"]){
        languangeType=@"ft";
    }else{
        languangeType=@"jt";
    }
    NSLog(@"Preferred Language:%@", preferredLang);
    return languangeType;
}

BOOL iPhone5(){
    if (568==windowHeight()) {
        return YES;
    }
    return NO;
}

//数学意义上的随机数在计算机上已被证明不可能实现。通常的随机数是使用随机数发生器在一个有限大的线性空间里取一个数。“随机”甚至不能保证数字的出现是无规律的。使用系统时间作为随机数发生器是常见的选择
NSMutableArray* randrom(int count,int totalCount){
    int x;
    int i;
    NSMutableArray *array=[[NSMutableArray alloc]init];
    time_t t;
    srand((unsigned) time(&t));
    for(i=0; i<count; i++){
        x=rand() % totalCount;
        printf("%d ", x);
        [array addObject:[NSString stringWithFormat:@"%d",x]];
    }
    printf("\n");
    return [array autorelease];
}


@end
