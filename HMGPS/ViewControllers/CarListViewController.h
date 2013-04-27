//
//  CarListViewController.h
//  HMGPS
//
//  Created by Xiaohui Guo on 13-4-24.
//  Copyright (c) 2013年 PERSONAL OUT_SOFTWARE TECHNOLOGY CO.LTD. All rights reserved.
//

#import "BaseViewController.h"
#import "Car.h"
#import "XHPullingRefreshTableView.h"

typedef enum {
    CarListTypeStatus   =0,
    CarListTypeContrail         //軌跡
}CarListType;


@interface CarListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,XHPullingRefreshTableViewDelegate>{
    Car *car;
    UIColor *color;
    IBOutlet UIImageView *statusImageView;
    XHPullingRefreshTableView *carListTableView;
    BOOL *flag;
    int number;
    int resourceCount;
    int showCount;
}

@property(nonatomic,retain)NSArray *cars;
@property(nonatomic,assign)CarListType carListType;
@property(nonatomic,retain)NSMutableArray *tableArray;//显示的数据源

@end
