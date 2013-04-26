//
//  BaseViewController.m
//  KTV
//
//  Created by Xiaohui Guo  on 12-10-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"
#import "CMethods.h"
#import "UIViewController+Utilities.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark - UIViewController lifecyle
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //[self titleView];
    CGRect frame=self.view.frame;
    frame.size.height=viewHeight(self);
    self.view.frame=frame;
    
    
    for(UITextField *textField in [self.view subviews]){
        if ([textField isKindOfClass:[UITextField class]]) {
            [textField setDelegate:self];
        }
    }
    
 
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark - ToFitFrame
-(void)autoFitFrame{
    CGRect rect=self.view.frame;
    //LOG(@"rect.frame.origin.y:%f",rect.origin.y);
    if (rect.origin.y<0) {
        [self toFitFrame:self.view distance:-rect.origin.y duration:.2 isUp:NO];
    }
    
    
}

#pragma mark - Touches method
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    for(UIView *view in [self.view subviews]){
        if ([view isKindOfClass:[UITextField class]]||[view isKindOfClass:[UISearchBar class]]||[view isKindOfClass:[UITextView class]]) {
            [view resignFirstResponder];
        }
    }
    [self autoFitFrame];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self autoFitFrame];
    return YES;
}

#pragma mark - BaseService Delegate method
-(void)responseString:(NSString *)string error:(NSError *)error{
    
}

#pragma mark - CommonParser Delegate method
-(void)parserFinishedWithString:(NSString *)string{
    
}

@end
