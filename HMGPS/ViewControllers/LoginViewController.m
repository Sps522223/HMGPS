//
//  LoginViewController.m
//  HMGPS
//
//  Created by Xiaohui Guo on 13-4-22.
//  Copyright (c) 2013年 PERSONAL OUT_SOFTWARE TECHNOLOGY CO.LTD. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize mainViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc{
    [comLogoImageView release];
    [accountLabel release];;
    [accountTextFieldBgImageView release];
    [accountTextField release];
    [idTextFieldBgImageView release];
    [idTextField release];
    [pwdTextFieldBgImageView release];
    [pwdTextField release];
    [idLabel release];
    [pwdLabel release];
    [showPwdButton release];
    [rememberButton release];
    [rememberButton release];
    [mainViewController release];
    [newCar release];
    [super dealloc];
}

#pragma mark - UIViewController lifecyle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self backgroundImage:nil];
    
    if ([AppCache isSaveLoginInfo]) {
        [rememberButton setSelected:YES];
    }
    if ([AppCache isShowPwd]) {
        [showPwdButton setSelected:YES];
        [pwdTextField setSecureTextEntry:NO];
    }else{
        [pwdTextField setSecureTextEntry:YES];
    }
    
    NSDictionary *loginInfoDict=[AppCache loginInfo];
    [accountTextField setText:[loginInfoDict objectForKey:ACCOUNT]];
    [idTextField setText:[loginInfoDict objectForKey:ID]];
    [pwdTextField setText:[loginInfoDict objectForKey:PWD]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextField Delegate method

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    for(UIImageView *imageView in [self.view subviews]){
        if ([imageView isKindOfClass:[UIImageView class]]&&[imageView tag]>=10) {
            [imageView setImage:[UIImage imageNamed:@"TextField_Normal.png"]];
        }
    }
    UIImage *image=[UIImage imageNamed:@"TextField_Responder.png"];
    if (textField==accountTextField) {
        [accountTextFieldBgImageView setImage:image];
    }else if(textField==idTextField){
        [idTextFieldBgImageView setImage:image];
        if (self.view.frame.origin.y==0) {
            [self toFitFrame:self.view distance:100 duration:0.3f isUp:YES];
        }
    }else{
        [pwdTextFieldBgImageView setImage:image];
        if (self.view.frame.origin.y==0) {
            [self toFitFrame:self.view distance:100 duration:0.3f isUp:YES];
        }
        
    }
    
}


#pragma mark -  UIButton actions

-(IBAction)showPwd:(id)sender{
    //textField必须重新获得焦点的时候才会重新执行setSecureTextEntry
    [showPwdButton setSelected:!showPwdButton.isSelected];
    if ([showPwdButton isSelected]) {
        [pwdTextField setSecureTextEntry:NO];
    }else{
        [pwdTextField setSecureTextEntry:YES];
    }
    [AppCache saveIsShowPwdWithBool:[showPwdButton isSelected]];
    
}
-(IBAction)rememberMe:(id)sender{
    [rememberButton setSelected:!rememberButton.isSelected];
    [AppCache saveLoginInfoWithBool:[rememberButton isSelected]];
}

-(IBAction)login:(id)sender{
    [self showMBProgressHUDWithView:self.view title:@"登入中..."];
    NSDictionary *loginInfo=[NSDictionary dictionaryWithObjectsAndKeys:accountTextField.text,ACCOUNT,idTextField.text,ID,pwdTextField.text,PWD, nil];
    [AppCache saveLoginInfo:loginInfo];
    NSString *message=[NSString stringWithFormat:@"$login|%@|%@|%@*",accountTextField.text,idTextField.text,pwdTextField.text];
    [[HMSocket sharedSocket] sendMessage:message delegate:self];
}

#pragma mark - HMSocket Delegate method

-(void)socket:(AsyncSocket *)socket recivedMessage:(NSString *)receive{
    [self removeMBProgressHUD];
    DLog(@"Login_receive:%@",receive);
    NSArray *receiveArray=[receive componentsSeparatedByString:@"|"];
    if ([@"$rlogin" isEqualToString:[receiveArray objectAtIndex:0]]) {
        [socket disconnect];
        NSString *subString=[receiveArray lastObject];
        if ([subString isEqualToString:@"pw*"]) {
            [self showAlertViewWithMessage:@"密碼錯誤"];
        }else if ([subString isEqualToString:@"id*"]) {
            [self showAlertViewWithMessage:@"ID錯誤"];
        }else{
            NSArray *receiveCarArray=[receive componentsSeparatedByString:@"*$rfleet|"];
            NSString *tempCarString=[receiveCarArray lastObject];
            NSString *carString=[tempCarString stringByReplacingOccurrencesOfString:@"*" withString:@""];
            DLog(@"cars:%@",carString);
            NSMutableArray *carArray=[[NSMutableArray alloc]init];
            NSArray *cars=[carString componentsSeparatedByString:@"|"];
            
            for(NSString *string in cars){
                newCar=[[Car alloc]initWithCarInfo:[string componentsSeparatedByString:@","]];
                [carArray addObject:newCar];
            }
            
            NSString *loginInfo=[receiveCarArray objectAtIndex:0];
            mainViewController.memberInfo=[[loginInfo componentsSeparatedByString:@"|"] lastObject];
            mainViewController.cars=carArray;
            [carArray release];
            [self dismissViewControllerAnimated:YES];
        }
    }
    
    
}


@end
