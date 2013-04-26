//
//  ContrailViewController.m
//  HMGPS
//
//  Created by Xiaohui Guo on 13-4-25.
//  Copyright (c) 2013年 PERSONAL OUT_SOFTWARE TECHNOLOGY CO.LTD. All rights reserved.
//

#import "ContrailViewController.h"
#import "UIViewController+Utilities.h"
#import "CarListViewController.h"

@interface ContrailViewController ()

-(void)showDatePicker:(DatePickerType)datePickerType button:(UIButton *)button;

-(NSDate *)dateWithYMD:(NSString *)date hour:(NSString *)hours;

@end

@implementation ContrailViewController
@synthesize carArray;
@synthesize endDate;
@synthesize startDate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc{
    [car release];
    [newCar release];
    [dropListView release];
    [carArray release];
    [selectCarButton release];
    [plateNumberLabel release];
    [startTimeLabel release];
    [endTimeLabel release];
    [startDayButton release];
    [startHourButton release];
    [endDayButton release];
    [endHourButton release];
    [searchButton release];
    //[datePicker release];
    [dateView release];
    //[maxDate release];
    //[currentDateString release];
    [startDate release];
    [endDate release];
    //[timeArray release];
    //[day release];
    //[hour release];
    [gregorian release];
    //[message release];
    [loginInfoDict release];
    //[carString release];
    //[receiveArray release];
    [contrailCarArray release];
    [contrailImageView release];
    //[selectedDate release];
    [super dealloc];
}

#pragma mark - UIViewController lifecyle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self backgroundImage:nil];
    [self backButton];
    car=[self.carArray objectAtIndex:0];
    [selectCarButton setTitle:[car plateNumber] forState:UIControlStateNormal];
    if (nil==startDate) {
        self.endDate=[self dateFromDate:[NSDate date]];
        [endDayButton setTitle:[self stringFromDate:endDate dateFormate:@"yyyy/MM/dd"] forState:UIControlStateNormal];
        [endHourButton setTitle:[self stringFromDate:[NSDate date] dateFormate:@"HH:mm"] forState:UIControlStateNormal];
        self.startDate=[NSDate dateWithTimeIntervalSinceNow:-12*60*60];
        NSString *startDateStr=[self stringFromDate:self.startDate dateFormate:@"yyyy/MM/dd HH:mm"];
        timeArray=[startDateStr componentsSeparatedByString:@" "];
        [startDayButton setTitle:[timeArray objectAtIndex:0] forState:UIControlStateNormal];
        [startHourButton setTitle:[timeArray objectAtIndex:1] forState:UIControlStateNormal];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIButton actions

-(IBAction)selectCar:(id)sender{
    if (nil==dropListView) {
        dropListView=[[DropListView alloc]initWithStyle:UITableViewStylePlain];
        dropListView.resourceArray=self.carArray;
        [dropListView setDropListDelegate:self];
        [dropListView.view setFrame:CGRectMake(114, 120, 139, 200)];
        [self.view addSubview:dropListView.view];
    }
    [dropListView dropListViewHidden:NO];
}
-(IBAction)selectStartDay:(id)sender{
    [self showDatePicker:DatePickerTypeYMD button:sender];
}
-(IBAction)selectStartHour:(id)sender{
    [self showDatePicker:DatePickerTypeHour button:sender];
}
-(IBAction)selectEndDay:(id)sender{
    [self showDatePicker:DatePickerTypeYMD button:sender];
}
-(IBAction)selectEndHour:(id)sender{
    [self showDatePicker:DatePickerTypeHour button:sender];
}
-(IBAction)search:(id)sender{
    [self showMBProgressHUDWithView:self.view title:@"查詢中..."];
    if (nil==loginInfoDict) {
        loginInfoDict=[[AppCache loginInfo] retain];
    }
 
    message=[NSString stringWithFormat:@"$findlog|%@|%@|%@|%@|%@|%@*",[loginInfoDict objectForKey:ACCOUNT],[loginInfoDict objectForKey:ID],[loginInfoDict objectForKey:PWD],car.cID,[NSString stringWithFormat:@"%@ %@:00",startDayButton.currentTitle,startHourButton.currentTitle],[NSString stringWithFormat:@"%@ %@:00",endDayButton.currentTitle,endHourButton.currentTitle]];
    [[HMSocket sharedSocket] sendMessage:message delegate:self];
}

#pragma mark - UIPrivate method

-(void)showDatePicker:(DatePickerType)datePickerType button:(UIButton *)button{
    buttonTag=[button tag];
    if (nil==dateView) {
        dateView=[[UIView alloc]initWithFrame:CGRectMake(0, viewHeight(self), 320, 260)];
        UIToolbar *toolbar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
        [toolbar setBarStyle:UIBarStyleBlack];
        UIBarButtonItem *canleButton=[[UIBarButtonItem alloc]initWithTitle:@"確定" style:UIBarButtonItemStyleDone target:self action:@selector(dismissDateView)];
        toolbar.items=[NSArray arrayWithObject:canleButton];
        [dateView addSubview:toolbar];
        datePicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 44, 320, 216)];
        [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        [dateView addSubview:datePicker];
        [self.view addSubview:dateView];
    }
    if (DatePickerTypeYMD==datePickerType) {//年月日
        [datePicker setDatePickerMode:UIDatePickerModeDate];
        maxDate=[NSDate date];
        if (button==startDayButton) {
             selectedDate=[self dateWithYMD:startDayButton.currentTitle hour:startHourButton.currentTitle];
        }else{
            selectedDate=[self dateWithYMD:endDayButton.currentTitle hour:endHourButton.currentTitle];
        }
       
        
    }else{//时分
        [datePicker setDatePickerMode:UIDatePickerModeTime];
        if (button==startHourButton) {
            selectedDate=[self dateWithYMD:startDayButton.currentTitle hour:startHourButton.currentTitle];
            maxDate=[self dateWithYMD:endDayButton.currentTitle hour:endHourButton.currentTitle];
            
        }else{
            maxDate=[NSDate date];
            selectedDate=[self dateWithYMD:endDayButton.currentTitle hour:endHourButton.currentTitle];
        }
        
    }
    [datePicker setDate:selectedDate animated:YES];
    [datePicker setMaximumDate:maxDate];
    if (dateView.frame.origin.y==viewHeight(self)) {
        [self toFitFrame:dateView distance:260 duration:0.2 isUp:YES];
    }
    
    
}

-(void)datePickerValueChanged:(UIDatePicker *)picker{
    currentDateString=[self stringFromDate:picker.date dateFormate:@"yyyy/MM/dd HH:mm"];
    timeArray=[currentDateString componentsSeparatedByString:@" "];
    day=[timeArray objectAtIndex:0];
    hour=[timeArray objectAtIndex:1];
    DLog(@"currentDateString:%@",currentDateString);
    UIButton *button=(UIButton *)[self.view viewWithTag:buttonTag];
    if (button==startDayButton||button==startHourButton) {//开始时间，年月日
        if (button==startDayButton) {
            [startDayButton setTitle:day forState:UIControlStateNormal];
        }else{
            [startHourButton setTitle:hour forState:UIControlStateNormal];
        }
        DLog(@"DateString:%@",[NSString stringWithFormat:@"%@ %@",day,startHourButton.currentTitle]);
        self.startDate=[self dateFormString:[NSString stringWithFormat:@"%@ %@",day,startHourButton.currentTitle]];
        DLog(@"currentDate:%@",self.startDate);
        DLog(@"endDate:%@",self.endDate);
        //获取两日期相差天数
        gregorian=[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        comps=[gregorian components:kCFCalendarUnitHour|kCFCalendarUnitMinute fromDate:self.startDate toDate:self.endDate options:0];
        compareHour=[comps hour];
        compareMinute=[comps minute];
        DLog(@"相差小时:%d",compareHour);
        DLog(@"相差分钟:%d",compareMinute);
        if (12<compareHour||(12==compareHour&&0<compareMinute)||0>compareHour) {//大于12小时，则修改结束日期
            self.endDate=[NSDate dateWithTimeInterval:12*60*60 sinceDate:startDate];
            timeArray=[[self stringFromDate:self.endDate dateFormate:@"yyyy/MM/dd HH:mm"] componentsSeparatedByString:@" "];
            [endDayButton setTitle:[timeArray objectAtIndex:0] forState:UIControlStateNormal];
            [endHourButton setTitle:[timeArray objectAtIndex:1] forState:UIControlStateNormal];
        }else if((0==compareHour&&0>compareMinute)||0>compareHour){//同小时，但是分钟超出
            [startHourButton setTitle:endHourButton.currentTitle forState:UIControlStateNormal];
        }
        
    }else{
        if (button==endDayButton) {
            [endDayButton setTitle:day forState:UIControlStateNormal];
        }else{
            [endHourButton setTitle:hour forState:UIControlStateNormal];
        }
        self.endDate=[self dateFormString:[NSString stringWithFormat:@"%@ %@",day,endHourButton.currentTitle]];
        //获取两日期相差天数
        gregorian=[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        comps=[gregorian components:kCFCalendarUnitHour|kCFCalendarUnitMinute fromDate:self.startDate toDate:self.endDate options:0];
        compareHour=[comps hour];
        compareMinute=[comps minute];
        DLog(@"相差小时:%d",compareHour);
        DLog(@"相差分钟:%d",compareMinute);
        if (12<compareHour||(12==compareHour&&0<compareMinute)||0>compareHour) {
            self.startDate=[NSDate dateWithTimeInterval:-12*60*60 sinceDate:[self dateFormString:[NSString stringWithFormat:@"%@ %@",day,endHourButton.currentTitle]]];
            timeArray=[[self stringFromDate:startDate dateFormate:@"yyyy/MM/dd HH:mm"] componentsSeparatedByString:@" "];
            [startDayButton setTitle:[timeArray objectAtIndex:0] forState:UIControlStateNormal];
            [startHourButton setTitle:[timeArray objectAtIndex:1] forState:UIControlStateNormal];
        }else if((0==compareHour&&0>compareMinute)||0>compareHour){//同小时，但是分钟超出
            [startHourButton setTitle:endHourButton.currentTitle forState:UIControlStateNormal];
        }
        
    }
    
}

-(NSDate *)dateWithYMD:(NSString *)date hour:(NSString *)hours{
    return [self dateFormString:[NSString stringWithFormat:@"%@ %@",date,hours]];
}

-(void)dismissDateView{
    [self toFitFrame:dateView distance:260 duration:0.2 isUp:NO];
}

#pragma mark -DropListView Delegte method

-(void)dropListView:(DropListView *)dropListView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    car=[self.carArray objectAtIndex:indexPath.row];
    [selectCarButton setTitle:car.plateNumber forState:UIControlStateNormal];
}

#pragma mark - HMSocket Delegate method

-(void)socket:(AsyncSocket *)socket recivedMessage:(NSString *)receive{
    [self removeMBProgressHUD];
    if (nil==contrailCarArray) {
        contrailCarArray=[[NSMutableArray alloc]init];
    }
    [contrailCarArray removeAllObjects];
    receiveArray=[[receive stringByReplacingOccurrencesOfString:@"*" withString:@""] componentsSeparatedByString:@"|"];
    
    if ([[receiveArray objectAtIndex:0] isEqualToString:@"$rfindlog"]) {
        recordCount=[[receiveArray objectAtIndex:1] intValue];
        if (0<recordCount) {
            for (int i=2; i<recordCount; i++) {
                carString=[receiveArray objectAtIndex:i];
                newCar=[[Car alloc]initWithCarInfo:[carString componentsSeparatedByString:@","]];
                [contrailCarArray addObject:newCar];
            }
            CarListViewController *carListViewController=[[CarListViewController alloc]initWithNibName:@"CarListViewController" bundle:nil];
            carListViewController.cars=contrailCarArray;
            carListViewController.carListType=CarListTypeContrail;
            [self.navigationController pushViewController:carListViewController animated:YES];
            [carListViewController release];
        }else{
            [self showAlertViewWithMessage:@"未查詢到軌跡信息"];
        }
    }
}

@end
