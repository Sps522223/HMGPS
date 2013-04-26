//
//  CarListViewController.m
//  HMGPS
//
//  Created by Xiaohui Guo on 13-4-24.
//  Copyright (c) 2013年 PERSONAL OUT_SOFTWARE TECHNOLOGY CO.LTD. All rights reserved.
//

#import "CarListViewController.h"
#import "SVGeocoder.h"
#import "MapViewController.h"
#import "CarView.h"
#import "ContrailView.h"

@interface CarListViewController ()

@end

@implementation CarListViewController
@synthesize cars;
@synthesize carListType;
@synthesize tableArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc{
    [statusImageView release];
    [carListTableView release];
    [cars release];
    [tableArray release];
    [super dealloc];
}

#pragma mark - UIViewController lifecyle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self backgroundImage:nil];
    [self backButton];
    flag = (BOOL*)malloc([self.cars count]*sizeof(BOOL));
    memset(flag, NO, [self.cars count]);
    
    carListTableView=[[XHPullingRefreshTableView alloc]initWithFrame:CGRectMake(11, 93, 298, viewHeight(self)-93-15) xhTableViewStyle:XHPullingRefreshTableViewFooter pullingDelegate:self];
    [carListTableView setDataSource:self];
    [carListTableView setDelegate:self];
    [carListTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [carListTableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:carListTableView];
    [self loadData];
    
    if (CarListTypeContrail==self.carListType) {
        [statusImageView setHidden:YES];
        UIButton *contrailButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [contrailButton setBackgroundImage:[UIImage imageNamed:@"Contrail_Normal.png"] forState:UIControlStateNormal];
        [contrailButton setBackgroundImage:[UIImage imageNamed:@"Contrail_Highlighted.png"] forState:UIControlStateHighlighted];
        [contrailButton setFrame:CGRectMake(246, 8, 69, 27)];
        [contrailButton addTarget:self action:@selector(showMap)  forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:contrailButton];
        
        UIImageView *memberInfoImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"UnKnow.png"]];
        [memberInfoImageView setFrame:CGRectMake(60, 33, 200, 60)];
        [self.view addSubview:memberInfoImageView];
        [memberInfoImageView release];
        
        UILabel *infoLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 5, 200, 50)];
        [infoLabel setTextAlignment:1];
        [infoLabel setTextColor:[UIColor blackColor]];
        [infoLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [infoLabel setNumberOfLines:2];
        [infoLabel setBackgroundColor:[UIColor clearColor]];
        car=[self.cars objectAtIndex:0];
        [infoLabel setText:[NSString stringWithFormat:@"車號:%@  駕駛員:%@\n查詢結果:%d筆",car.plateNumber,car.driver,[self.cars count]]];
        [memberInfoImageView addSubview:infoLabel];
        [infoLabel release];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource method

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
     return [self.tableArray count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (flag[section]) {
        return 1;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil==cell) {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
        UIView *bgView=[[UIView alloc]init];
        [bgView setBackgroundColor:[UIColor whiteColor]];
        cell.backgroundView=bgView;
        [bgView release];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    car=[self.tableArray objectAtIndex:indexPath.section];
    [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
    [cell.textLabel setText:car.address];
    return cell;
}

#pragma mark - UITableView Delegate method

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (CarListTypeStatus==self.carListType) {
        return 47.0f;
    }else{
        return 64.0f;
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    car=[self.tableArray objectAtIndex:section];
    if ([car.statusCode isEqualToString:@"st01"]) {
        color=[UIColor redColor];
    }else if ([car.statusCode isEqualToString:@"st02"]) {
        color=[UIColor colorWithRed:0.2 green:0.8 blue:0.2 alpha:1];
    }else if ([car.statusCode isEqualToString:@"st03"]) {
        color=[UIColor blackColor];
    }else if ([car.statusCode isEqualToString:@"st04"]) {
        color=[UIColor blackColor];
    }else if ([car.statusCode isEqualToString:@"st05"]) {
        color=[UIColor blackColor];
    }else{
        color=[UIColor blackColor];
    }
    if (CarListTypeStatus==self.carListType) {
        CarView *carView=[[[NSBundle mainBundle]loadNibNamed:@"CarView" owner:self options:nil]lastObject];
        [carView setTag:section];
        [carView.numberLabel setText:[NSString stringWithFormat:@"%d",section+1]];
        [carView.plateNumberLabel setText:car.plateNumber];
        [carView.speedLabel setText:car.speed];
        
        [carView.timeLabel setText:car.time];
        [carView.statusLabel setText:car.status];
        [carView.statusLabel setTextColor:color];
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showAddress:)];
        [carView addGestureRecognizer:tap];
        [tap release];
        return carView;
    }else{
        ContrailView *contrailView=[[[NSBundle mainBundle]loadNibNamed:@"ContrailView" owner:self options:nil]lastObject];
        [contrailView setTag:section];
        [contrailView.numberLabel setText:[NSString stringWithFormat:@"%d",section+1]];
        [contrailView.plateNumberLabel setText:car.time];
        [contrailView.speedLabel setText:car.speed];
        [contrailView.timeLabel setText:car.direction];
        [contrailView.statusLabel setText:car.status];
        [contrailView.statusLabel setTextColor:color];
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showAddress:)];
        [contrailView addGestureRecognizer:tap];
        [tap release];
        return contrailView;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    car=[self.tableArray objectAtIndex:indexPath.section];
    MapViewType mapViewType=0;
    MapViewController *mapViewController=[[MapViewController alloc]initWithNibName:@"MapViewController" bundle:nil];
    if (CarListTypeStatus==self.carListType) {
        mapViewType=MapViewTypeStatus;
    }else{
        mapViewType=MapViewTypeContrail;
    }
    mapViewController.carArray=self.cars;
    mapViewController.car=car;
    mapViewController.mapViewType=mapViewType;
    [self.navigationController pushViewController:mapViewController animated:YES];
    [mapViewController release];
}

#pragma mark - Tap

-(void)showAddress:(UITapGestureRecognizer *)tap{
    int tag=((CarView *)tap.view).tag;
    car=[self.tableArray objectAtIndex:tag];
    if (nil==car.address) {
        [self showMBProgressHUDWithView:self.view title:@"正在獲取地址..."];
        [SVGeocoder reverseGeocode:CLLocationCoordinate2DMake(car.latitude, car.longitude) completion:^(NSArray *placemarks, NSHTTPURLResponse *urlResponse, NSError *error) {
            [self removeMBProgressHUD];
            if (!error) {
                car.address=[[[[placemarks objectAtIndex:0] formattedAddress] componentsSeparatedByString:@" "] lastObject];
                flag[tag]=!flag[tag];
                [carListTableView reloadSections:[NSIndexSet indexSetWithIndex:tag] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
        ];
    }else{
        flag[tag]=!flag[tag];
        [carListTableView reloadSections:[NSIndexSet indexSetWithIndex:tag] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}

#pragma mark - UIButton actions

-(void)showMap{
    MapViewController *mapViewController=[[MapViewController alloc]initWithNibName:@"MapViewController" bundle:nil];
    mapViewController.carArray=self.cars;
    mapViewController.mapViewType=MapViewTypeLine;
    [self.navigationController pushViewController:mapViewController animated:YES];
    [mapViewController release];
}

#pragma mark - PullingRefreshTableViewDelegate

- (void)pullingTableViewDidStartLoading:(XHPullingRefreshTableView *)tableView{
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0f];
}

#pragma mark - Scroll

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [carListTableView tableViewDidScroll:scrollView];
        
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [carListTableView tableViewDidEndDragging:scrollView];
}

-(void)loadData{
    DLog(@"loadData....");
    if (nil==tableArray) {
        tableArray=[[NSMutableArray alloc]init];
    }
    resourceCount=[self.cars count];
    showCount=[self.tableArray count];
    if (20<=resourceCount-showCount) {
        for (number=showCount; number<showCount+20; number++) {
            [self.tableArray addObject:[self.cars objectAtIndex:number]];
        }
       carListTableView.reachedTheEnd  = NO;
    }else{
        [tableArray removeAllObjects];
        [tableArray addObjectsFromArray:self.cars];
        carListTableView.reachedTheEnd  = YES;
    }
        
    [carListTableView tableViewDidFinishedLoading];
    
    [carListTableView reloadData];
}

@end
