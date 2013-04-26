//
//  UIViewController+Utilities.h
//  TaxiTest
//
//  Created by Xiaohui Guo  on 13-3-13.
//  Copyright (c) 2013年 FJKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

#define bodySystemFont(size) [UIFont boldSystemFontOfSize:size]
#define systemFont(size) [UIFont systemFontOfSize:size]

@interface UIViewController (Utilities)

//背景图
-(void)backgroundImage:(NSString *)image;

-(void)backButton;

@end


/*
 
 加载等待界面
 不传message，则默认显示，调用[self showLoadingViewWithMessage:nil];
 
 */

@interface UIViewController (Loading)

-(void)showLoadingViewWithMessage:(NSString *)message;
-(void)removeLoadingView;
-(void)showSplishView;
-(void)showMBProgressHUDWithView:(UIView *)view  title:(NSString *)title;
-(void)removeMBProgressHUD;

@end


@interface UIViewController (TitleView)

-(void)titleView;

-(void)setTitleViewAndFootViewWithTitle:(NSString *)title;

-(void)titleViewWithTitle:(NSString *)title;

-(void)navTitle:(NSString *)title;

-(void)backItem;// 返回

@end


/*
 
 提示信息，用于delegate＝nil
 
 */
@interface UIViewController (AlertView)

-(void)showAlertViewWithMessage:(NSString *)msg;

@end

/*
 
 io6 版本及以下
 适合无block处理的情况
 
 */
@interface UIViewController (IOS6)

-(void)dismissViewControllerAnimated:(BOOL)animated;

-(void)presentsViewController:(UIViewController *)viewController animated:(BOOL)animated;

@end

/*
 
 处理视图移动
 
 */

@interface UIViewController (FitFrame)

-(void)toFitFrame:(UIView *)view distance:(NSInteger)distance duration:(NSTimeInterval)duration isUp:(BOOL)up;

@end

@interface UIViewController (NSDate)

-(NSString *)stringFromDate:(NSDate *)date dateFormate:(NSString *)format;

-(NSDate *)dateFromDate:(NSDate *)date;

-(NSDate *)dateFormString:(NSString *)string;

@end