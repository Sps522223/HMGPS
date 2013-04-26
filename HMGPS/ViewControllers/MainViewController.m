//
//  MainViewController.m
//  HMGPS
//
//  Created by Xiaohui Guo on 13-4-22.
//  Copyright (c) 2013年 PERSONAL OUT_SOFTWARE TECHNOLOGY CO.LTD. All rights reserved.
//

#import "MainViewController.h"
#import "LoginViewController.h"
#import "CarListViewController.h"
#import "ContrailViewController.h"

@interface MainViewController ()

-(void)showLoginView;

@end

@implementation MainViewController
@synthesize cars;
@synthesize memberInfo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc{
    [memberInfo release];
    [infoLabel release];
    [super dealloc];
}

#pragma mark - UIViewController lifecyle

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [infoLabel setText:self.memberInfo];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self backgroundImage:nil];
    float button_height=100;
    float button_width=245;
    float x=(320-button_width)/2.0;
    float space=(viewHeight(self)-button_height*4)/5;
    
    UIImageView *memberInfoImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"UnKnow.png"]];
    [memberInfoImageView setFrame:CGRectMake(15, space, 290, 90)];
    [self.view addSubview:memberInfoImageView];
    [memberInfoImageView release];
    
    infoLabel=[[UILabel alloc]initWithFrame:CGRectMake(25, 20, 240, 50)];
    [infoLabel setTextAlignment:1];
    [infoLabel setTextColor:[UIColor blackColor]];
    [infoLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [infoLabel setNumberOfLines:2];
    [infoLabel setBackgroundColor:[UIColor clearColor]];
    [memberInfoImageView addSubview:infoLabel];
    
    float origin_y=memberInfoImageView.frame.origin.y+memberInfoImageView.frame.size.height;
    NSArray *images=[NSArray arrayWithObjects:@"Status",@"Line",@"LoginOut", nil];
    
    SEL action=nil;
    for (int i=0; i<3; i++) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_Normal.png",[images objectAtIndex:i]]] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_Highlighted.png",[images objectAtIndex:i]]] forState:UIControlStateHighlighted];
        [button setFrame:CGRectMake(x, origin_y+i*button_height, button_width, button_height)];
        if (0==i) {
            action=@selector(showStatus);
        }else if(1==i){
            action=@selector(showLines);
        }else{
            action=@selector(loginOut);
        }
        [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    [self showLoginView];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  - UIButton actions
//車輛狀態
-(void)showStatus{
    CarListViewController *carListViewController=[[CarListViewController alloc]initWithNibName:@"CarListViewController" bundle:nil];
    carListViewController.cars=self.cars;
    [self.navigationController pushViewController:carListViewController animated:YES];
    [carListViewController release];
}
//軌跡
-(void)showLines{
    ContrailViewController *contrailViewController=[[ContrailViewController alloc]initWithNibName:@"ContrailViewController" bundle:nil];
    contrailViewController.carArray=self.cars;
    [self.navigationController pushViewController:contrailViewController animated:YES];
    [contrailViewController release];
}

-(void)loginOut{
    [self showMBProgressHUDWithView:self.view title:@"登出中..."];
    NSDictionary *loginInfoDict=[AppCache loginInfo];
    NSString *message=[NSString stringWithFormat:@"$logout|%@|%@|%@*",[loginInfoDict objectForKey:ACCOUNT],[loginInfoDict objectForKey:ID],[loginInfoDict objectForKey:PWD]];
    [[HMSocket sharedSocket]sendMessage:message delegate:self];
}


#pragma mark - Private method

-(void)showLoginView{
    if (nil==loginNav) {
        LoginViewController *loginViewController=[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
        loginViewController.mainViewController=self;
        loginNav=[[UINavigationController alloc]initWithRootViewController:loginViewController];
        [loginNav setNavigationBarHidden:YES];
        [loginViewController release];
    }
    
    [self presentsViewController:loginNav animated:YES];
}

#pragma mark - HMSocket Delegate method

-(void)socket:(AsyncSocket *)socket recivedMessage:(NSString *)receive{
    [self removeMBProgressHUD];
    DLog(@"Main_receive:%@",receive);
    NSDictionary *loginInfoDict=[AppCache loginInfo];
    NSString *checkString=[NSString stringWithFormat:@"$rlogout|%@|%@|%@*",[loginInfoDict objectForKey:ACCOUNT],[loginInfoDict objectForKey:ID],[loginInfoDict objectForKey:PWD]];
    if (![checkString isEqualToString:receive]) {
        [self showAlertViewWithMessage:@"登出失敗"];
    }else{
        [self showLoginView];
    }
}

@end
