//
//  ContrailViewController.h
//  HMGPS
//
//  Created by Xiaohui Guo on 13-4-25.
//  Copyright (c) 2013年 PERSONAL OUT_SOFTWARE TECHNOLOGY CO.LTD. All rights reserved.
//

#import "BaseViewController.h"
#import "Car.h"
#import "DropListView.h"
#import "HMSocket.h"

typedef enum {
    DatePickerTypeYMD   ,//年月日
    DatePickerTypeHour  ,//時分
}DatePickerType;



@interface ContrailViewController : BaseViewController<DropListViewDelegate,HMSocketDelegate>{
    Car *car;
    Car *newCar;
    DropListView *dropListView;
    IBOutlet UIButton *selectCarButton;
    IBOutlet UILabel *plateNumberLabel;
    IBOutlet UILabel *startTimeLabel;
    IBOutlet UILabel *endTimeLabel;
    IBOutlet UIButton *startDayButton;
    IBOutlet UIButton *startHourButton;
    IBOutlet UIButton *endDayButton;
    IBOutlet UIButton *endHourButton;
    IBOutlet UIButton *searchButton;
    UIView *dateView;
    UIDatePicker *datePicker;
    int buttonTag;//此时进行时间选择的button
    NSDate *maxDate;
    NSDate *startDate;
    NSDate *endDate;
    NSString *currentDateString;
    NSArray *timeArray;
    NSString *day;//指向年月日
    NSString *hour;
    int compareHour;//时差
    int compareMinute;//minute
    NSCalendar *gregorian;
    NSDateComponents *comps;
    NSString *message;
    NSDictionary *loginInfoDict;
    NSString *carString;
    NSArray *receiveArray;
    int recordCount;
    NSMutableArray *contrailCarArray;
    IBOutlet UIImageView *contrailImageView;
    NSDate *selectedDate;
}

@property(nonatomic,retain)NSArray *carArray;
@property(nonatomic,retain)NSDate *endDate;
@property(nonatomic,retain)NSDate *startDate;


-(IBAction)selectCar:(id)sender;
-(IBAction)selectStartDay:(id)sender;
-(IBAction)selectStartHour:(id)sender;
-(IBAction)selectEndDay:(id)sender;
-(IBAction)selectEndHour:(id)sender;
-(IBAction)search:(id)sender;

@end
