//
//  UIViewController+Utilities.m
//  TaxiTest
//
//  Created by Xiaohui Guo  on 13-3-13.
//  Copyright (c) 2013年 FJKJ. All rights reserved.
//

#import "UIViewController+Utilities.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "CMethods.h"

@implementation UIViewController (Utilities)

-(void)backgroundImage:(NSString *)image{
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, viewHeight(self))];
    if (nil==image) {
        image=@"Main_Bg.png";
    }
    [imageView setImage:[UIImage imageNamed:image]];
    [self.view insertSubview:imageView atIndex:0];
    [imageView release];
    
    UIImageView *partImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"main_part.png"]];
    [partImageView setFrame:CGRectMake(0, imageView.frame.size.height-259, 320, 259)];
    [imageView addSubview:partImageView];
    [partImageView release];
    
}

-(void)backButton{
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"Back_Normal.png"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"Back_Highlighted.png"] forState:UIControlStateHighlighted];
    [backButton setFrame:CGRectMake(5, 8, 69, 27)];
    [backButton addTarget:self action:@selector(backToPre)  forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    
}

-(void)backToPre{
    [self.navigationController popViewControllerAnimated:YES];
}

@end

@implementation UIViewController (Loading)
UIView *bgView;
//UIImageView *lodingImageView;
-(void)showLoadingViewWithMessage:(NSString *)message{
    AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    CGPoint centerPoint=appDelegate.window.center;
    bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 60)];
    bgView.center=centerPoint;
    bgView.backgroundColor=[UIColor colorWithRed:.1 green:.1 blue:.1 alpha:.8];
    bgView.layer.cornerRadius=10;
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(30, 20, 110, 20)];
    label.font=[UIFont systemFontOfSize:12];
    [label setTextAlignment:1];
    label.backgroundColor=[UIColor clearColor];
    if (message!=nil&&![message isEqualToString:@""]) {
        label.text=message;
    }else{
        label.text=NSLocalizedString(@"loading", nil);
    }
    label.textColor=[UIColor whiteColor];
    [bgView addSubview:label];
    [label release];
    UIActivityIndicatorView *avtivityView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [avtivityView setFrame:CGRectMake(5, 15, 30, 30)];
    [avtivityView startAnimating];
    [bgView addSubview:avtivityView];
    [avtivityView release];
    //lodingImageView=[[UIImageView alloc]initWithFrame:CGRectMake(5, 15, 30, 30)];
    //NSMutableArray *imgArray=[[NSMutableArray alloc]init];
    //for (int i=1; i<12; i++) {
    //    [imgArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"pro_anim%d.png",i]]];
    //}
    //lodingImageView.animationImages=(NSArray *)imgArray;
    //[imgArray release];
    //lodingImageView.animationDuration=1;
    //lodingImageView.animationRepeatCount=0;
    //[lodingImageView startAnimating];
    //[bgView addSubview:lodingImageView];
    
    appDelegate.window.userInteractionEnabled=NO;
    [appDelegate.window addSubview:bgView];
}


-(void)removeLoadingView{
    if (bgView!=nil) {
        [bgView removeFromSuperview];
    }
    
    AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    appDelegate.window.userInteractionEnabled=YES;
}

UIView *splishView;
-(void)showSplishView{
    CGPoint centerPoint=self.view.center;
    splishView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 60)];
    splishView.center=centerPoint;
    splishView.backgroundColor=[UIColor colorWithRed:.1 green:.1 blue:.1 alpha:.8];
    splishView.layer.cornerRadius=10;
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, 150, 20)];
    label.font=bodySystemFont(18);
    [label setTextAlignment:1];
    label.backgroundColor=[UIColor clearColor];
    label.textColor=[UIColor whiteColor];
    [label setText:@"回答正確"];
    [splishView addSubview:label];
    [label release];
    [self.view addSubview:splishView];
    AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    appDelegate.window.userInteractionEnabled=NO;
    [self performSelector:@selector(dismissAplishView) withObject:nil afterDelay:3];
}

-(void)dismissAplishView{
    [splishView removeFromSuperview];
    AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    appDelegate.window.userInteractionEnabled=YES;
}

MBProgressHUD *mbProgressHUD;
-(void)showMBProgressHUDWithView:(UIView *)view  title:(NSString *)title{
    mbProgressHUD=[[MBProgressHUD alloc]initWithView:view];
    [view addSubview:mbProgressHUD];
    [view bringSubviewToFront:mbProgressHUD];
    if (nil==title) {
        title=@"加載中...";
    }
    mbProgressHUD.labelText=title;
    [mbProgressHUD show:YES];
}

-(void)removeMBProgressHUD{
    if (mbProgressHUD) {
        [mbProgressHUD removeFromSuperview];
        [mbProgressHUD release];
        mbProgressHUD = nil;
    }
}

@end



@implementation UIViewController (TitleView)

-(void)titleView{
    UIImage *image=[UIImage imageNamed:@"App_Title.png"];
    UIImageView *imageView=[[UIImageView alloc] initWithImage:image];
    [imageView setFrame:CGRectMake(0, 0, image.size.width,image.size.height)];
    [self.view addSubview:imageView];
    [imageView release];
}

-(void)setTitleViewAndFootViewWithTitle:(NSString *)title{
    [self.navigationItem setHidesBackButton:YES];
    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(20, 1, 280, 35)];
    UIButton *mainButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [mainButton setBackgroundImage:[UIImage imageNamed:@"main_button.png"] forState:UIControlStateNormal];
    [mainButton setBackgroundImage:[UIImage imageNamed:@"main_button_highlighted.png"] forState:UIControlStateHighlighted];
    [mainButton setFrame:CGRectMake(0, 0, 51, 35)];
    [mainButton setTitle:NSLocalizedString(@"main", nil) forState:UIControlStateNormal];
    [mainButton addTarget:self action:@selector(backToMainView) forControlEvents:UIControlEventTouchUpInside];
    [mainButton.titleLabel setFont:bodySystemFont(16)];
    [titleView addSubview:mainButton];
    
    UIButton *titleButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [titleButton setBackgroundImage:[UIImage imageNamed:@"title.png"] forState:UIControlStateNormal];
    [titleButton setFrame:CGRectMake(51, 0, 175, 35)];
    [titleButton setTitle:NSLocalizedString(title, nil) forState:UIControlStateNormal];
    [titleButton.titleLabel setFont:bodySystemFont(16)];
    [titleButton setUserInteractionEnabled:NO];
    [titleView addSubview:titleButton];
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_button.png"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_button_highlighted.png"] forState:UIControlStateHighlighted];
    [backButton setFrame:CGRectMake(226, 0, 54, 35)];
    [backButton setTitle:NSLocalizedString(@"back", nil) forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backToPreView) forControlEvents:UIControlEventTouchUpInside];
    [backButton.titleLabel setFont:bodySystemFont(16)];
    [titleView addSubview:backButton];
    [self.navigationItem setTitleView:titleView];
    [titleView release];
    
    
    UIView *footView=[[UIView alloc]initWithFrame:CGRectMake(0, viewHeight(self)-49, 320, 49)];
    [self.view addSubview:footView];
    [footView release];
    
    NSArray *backgroundImages=[NSArray arrayWithObjects:@"g_08.png",@"g_09.png",@"g_10.png",@"g_11.png", nil];
    NSArray *keys=[NSArray arrayWithObjects:@"exchange",@"rent",@"rented",@"more", nil];
    for (int i=0; i<4; i++) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(i*80, 0, 80, 49)];
        [button setBackgroundImage:[UIImage imageNamed:[backgroundImages objectAtIndex:i]] forState:UIControlStateNormal];
        [button setTitle:NSLocalizedString([keys objectAtIndex:i], nil) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:bodySystemFont(16)];
        [footView addSubview:button];
        
    }
}

-(void)navTitle:(NSString *)title{
    self.navigationItem.hidesBackButton=YES;
    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [titleView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [titleView setBackgroundColor:[UIColor clearColor]];
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(backToPreView) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backBtn setFrame:CGRectMake(5, 7, 52, 30)];
    [titleView addSubview:backBtn];
    
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 180, 44)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextAlignment:1];
    [titleLabel setTextColor:[UIColor blackColor]];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [titleLabel setText:title];
    titleLabel.center=titleView.center;
    [titleView addSubview:titleLabel];
    [titleLabel release];
    
    
    UIButton *rootBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [rootBtn addTarget:self action:@selector(backToMainView) forControlEvents:UIControlEventTouchUpInside];
    [rootBtn setImage:[UIImage imageNamed:@"to_root.png"] forState:UIControlStateNormal];
    [rootBtn setFrame:CGRectMake(255, 7, 49, 30)];
    [titleView addSubview:rootBtn];
    
    self.navigationItem.titleView=titleView;
    [titleView release];
}


-(void)backToMainView{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)backToPreView{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)titleViewWithTitle:(NSString *)title{
    self.navigationItem.hidesBackButton=YES;
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(60, 0, 200, 44)];
    [titleLabel setTextAlignment:1];
    [titleLabel setText:title];
    [titleLabel setFont:bodySystemFont(20)];
    [titleLabel setTextColor:[UIColor blackColor]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    self.navigationItem.titleView=titleLabel;
    [titleLabel release];
}

-(void)backItem{
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    [backItem setTitle:@"返回"];
    self.navigationItem.backBarButtonItem=backItem;
    [backItem release];
}

@end

@implementation UIViewController (AlertView)

-(void)showAlertViewWithMessage:(NSString *)msg{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"溫馨提示" message:msg delegate:nil cancelButtonTitle:@"確定" otherButtonTitles:nil, nil];
    [alertView show];
    [alertView release];
}

@end


@implementation UIViewController (IOS6)

-(void)dismissViewControllerAnimated:(BOOL)animated{
#if __IPHONE_OS_VERSION_MAX_ALLOWED>=__IPHONE_6_0
    [self dismissViewControllerAnimated:animated completion:^{
        
    }];
#else
	[self dismissModalViewControllerAnimated:animated];
#endif
}

-(void)presentsViewController:(UIViewController *)viewController animated:(BOOL)animated{
#if __IPHONE_OS_VERSION_MAX_ALLOWED>=__IPHONE_6_0
    [self presentViewController:viewController animated:YES completion:^{
        
    }];
#else
    [self presentModalViewController:viewController animated:YES];
#endif
    
}

@end

@implementation UIViewController (FitFrame)

-(void)toFitFrame:(UIView *)view distance:(NSInteger)distance duration:(NSTimeInterval)duration isUp:(BOOL)up{
    CGRect frame=view.frame;
    int movementDistance=up?-distance:distance;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    view.frame=CGRectOffset(frame, 0, movementDistance);
    [UIView commitAnimations];
}

@end

@implementation UIViewController (NSDate)

-(NSString *)stringFromDate:(NSDate *)date dateFormate:(NSString *)format{
    NSCalendar *calendar=[NSCalendar currentCalendar];
    NSDate *calendarDate=[calendar dateFromComponents:[calendar components:(NSMinuteCalendarUnit|NSHourCalendarUnit|NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit) fromDate:date]];
    //LOG(@"calendarDate:%@",calendarDate);
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:format];
    NSString *dateString=[dateFormatter stringFromDate:calendarDate];
    [dateFormatter release];
    //DLog(@"dateString:%@",dateString);
    return dateString;
}

-(NSDate *)dateFromDate:(NSDate *)date{
    NSCalendar *calendar=[NSCalendar currentCalendar];
    NSDate *calendarDate=[calendar dateFromComponents:[calendar components:(NSMinuteCalendarUnit|NSHourCalendarUnit|NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit) fromDate:date]];
    return calendarDate;
}

-(NSDate *)dateFormString:(NSString *)string{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSDate *date=[dateFormatter dateFromString:string];
    [dateFormatter release];
    NSCalendar *calendar=[NSCalendar currentCalendar];
    NSDate *calendarDate=[calendar dateFromComponents:[calendar components:(NSMinuteCalendarUnit|NSHourCalendarUnit|NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit) fromDate:date]];
    
    return calendarDate;
}

@end
