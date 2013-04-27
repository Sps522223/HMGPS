//
//  LoginViewController.h
//  HMGPS
//
//  Created by Xiaohui Guo on 13-4-22.
//  Copyright (c) 2013年 PERSONAL OUT_SOFTWARE TECHNOLOGY CO.LTD. All rights reserved.
//

#import "BaseViewController.h"
#import "HMSocket.h"
#import "MainViewController.h"
#import "Car.h"

@interface LoginViewController : BaseViewController<HMSocketDelegate>{
    IBOutlet UIImageView *comLogoImageView;
    IBOutlet UILabel *accountLabel;
    IBOutlet UIImageView *accountTextFieldBgImageView;
    IBOutlet UITextField *accountTextField;
    IBOutlet UILabel *idLabel;
    IBOutlet UIImageView *idTextFieldBgImageView;
    IBOutlet UITextField *idTextField;
    IBOutlet UILabel *pwdLabel;
    IBOutlet UIImageView *pwdTextFieldBgImageView;
    IBOutlet UITextField *pwdTextField;
    IBOutlet UIButton *showPwdButton;
    IBOutlet UIButton *rememberButton;
    IBOutlet UIButton *loginButton;
    Car *newCar;
}

@property(nonatomic,retain)MainViewController *mainViewController;

-(IBAction)showPwd:(id)sender;
-(IBAction)rememberMe:(id)sender;
-(IBAction)login:(id)sender;

@end
