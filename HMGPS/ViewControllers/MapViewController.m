//
//  MapViewController.m
//  HMGPS
//
//  Created by Xiaohui Guo on 13-4-25.
//  Copyright (c) 2013年 PERSONAL OUT_SOFTWARE TECHNOLOGY CO.LTD. All rights reserved.
//

#import "MapViewController.h"
#import "SVGeocoder.h"
#import "ContrailViewController.h"

@interface MapViewController ()

-(void)sendMessageWithCar:(Car *)car;

-(void)showCarInfoWithInfo:(NSArray *)info;

-(void)loadRouteWithGeoArray:(NSArray *)geoArray;

@end

@implementation MapViewController
@synthesize car;
@synthesize carArray;
@synthesize mapViewType;

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
    [carArray release];
    [infoLabel release];
    [carInfoString release];
    [carInfoArray release];
    [receiveArray release];
    [finalReceivedString release];
    [customAnnotation release];
    [carMapView release];
    [selectCarButton release];
    [dropListView release];
    [message release];
    [loginInfoDict release];
    [streetWebView release];
    [super dealloc];
}

#pragma mark - UIViewController lifecyle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self backgroundImage:nil];
    [self backButton];
    
    [carMapView setDelegate:self];
    [selectCarButton setTitle:self.car.plateNumber forState:UIControlStateNormal];
    
    if (MapViewTypeContrail==self.mapViewType) {
        [selectCarButton setHidden:YES];
        [infoLabel setFrame:CGRectMake(11, 45, 298, 82)];
        [carMapView setFrame:CGRectMake(11, 129, 298, viewHeight(self)-129-15)];
    }else if(MapViewTypeLine==self.mapViewType){//轨迹
        
        [selectCarButton setHidden:YES];
        [infoLabel setHidden:YES];
        [carMapView setFrame:CGRectMake(11, 45, 298, viewHeight(self)-45-15)];
        NSMutableArray *pointArray=[[NSMutableArray alloc]init];
        NSString *pointString=nil;
        for(car in self.carArray){
            pointString=[NSString stringWithFormat:@"%f,%f",car.latitude,car.longitude];
            [pointArray addObject:pointString];
        }
        [self loadRouteWithGeoArray:pointArray];
        [pointArray release];
        
    }else{
        UIButton *contrailButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [contrailButton setBackgroundImage:[UIImage imageNamed:@"Layer_Normal.png"] forState:UIControlStateNormal];
        [contrailButton setBackgroundImage:[UIImage imageNamed:@"Layer_Highlighted.png"] forState:UIControlStateHighlighted];
        [contrailButton setFrame:CGRectMake(246, 8, 69, 27)];
        [contrailButton addTarget:self action:@selector(showLayer)  forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:contrailButton];
    }
    
    if (MapViewTypeStatus==self.mapViewType||MapViewTypeContrail==self.mapViewType) {
        [self sendMessageWithCar:self.car];
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - HMSocket Delegate method

-(void)socket:(AsyncSocket *)socket recivedMessage:(NSString *)receive{
    [self removeMBProgressHUD];
    finalReceivedString=[receive stringByReplacingOccurrencesOfString:@"*" withString:@""];
    receiveArray=[finalReceivedString componentsSeparatedByString:@"|"];
    if ([@"$rquery" isEqualToString:[receiveArray objectAtIndex:0]]) {
        carInfoArray=[[receiveArray lastObject]componentsSeparatedByString:@","];
        [self showCarInfoWithInfo:carInfoArray];
    }
    
}

#pragma mark - Private method

-(void)sendMessageWithCar:(Car *)car2{
    if (nil==loginInfoDict) {
        loginInfoDict=[AppCache loginInfo];
    }
    [self showMBProgressHUDWithView:self.view title:@"正在獲取車輛信息..."];
    message=[NSString stringWithFormat:@"$query|%@|%@|%@|%@*",[loginInfoDict objectForKey:ACCOUNT],[loginInfoDict objectForKey:ID],[loginInfoDict objectForKey:PWD],car2.cID];
    [[HMSocket sharedSocket] sendMessage:message delegate:self];
}


-(void)showCarInfoWithInfo:(NSArray *)info{
    car=[[Car alloc] initWithCarInfo:info];
    cllocation2D=CLLocationCoordinate2DMake(car.latitude, car.longitude);
    [carMapView removeAnnotations:carMapView.annotations];
    customAnnotation=[[CustomAnnotation alloc]initWithCoordinate:cllocation2D];
    [carMapView addAnnotation:customAnnotation];
    [carMapView setCenterCoordinate:cllocation2D zoomLevel:17 animated:YES];
    [SVGeocoder reverseGeocode:cllocation2D completion:^(NSArray *placemarks, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (!error) {
            car.address=[[[[placemarks objectAtIndex:0] formattedAddress] componentsSeparatedByString:@" "] lastObject];
            carInfoString=[NSString stringWithFormat:@"車號:%@  狀態:%@  時速:%@\n方向:%@\n最後時間:%@\n地址:%@",car.plateNumber,car.status,car.speed,car.direction,car.time,car.address];
            [infoLabel setText:carInfoString];
        }
    }
     ];
    
}

#pragma mark - MKMapView Delegate method

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    static NSString *AnnotationIdentifier=@"annotation";
    MKPinAnnotationView  *pinView=(MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
    if (nil==pinView) {
        pinView=[[[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier]autorelease];
        [pinView setImage:[UIImage imageNamed:@"Pin_Icon.png"]];
    }
    return pinView;
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay{
	MKOverlayView *overlayView = nil;
    MKPolylineView *routeLineView = nil;
    if(nil==routeLineView){
        routeLineView = [[[MKPolylineView alloc] initWithPolyline:overlay] autorelease];
        routeLineView.fillColor = [UIColor redColor];
        routeLineView.strokeColor = [UIColor redColor];//路线颜色
        routeLineView.lineWidth = 2;//路线粗细
    }
    overlayView =routeLineView;
	return overlayView;
}


#pragma mark - Route

//绘制路线
-(void)loadRouteWithGeoArray:(NSArray *)geoArray{
    shouldZoom++;
	MKMapPoint northEastPoint;
	MKMapPoint southWestPoint;
    NSArray *pointArray=nil;
    MKPolyline *routeLine=nil;
    // 下面是一些点
    if ([geoArray count]) {
        MKMapPoint* pointArr = malloc(sizeof(CLLocationCoordinate2D) * [geoArray count]);
        for(int i = 0; i < [geoArray count]; i++)
        {
            pointArray=[[geoArray objectAtIndex:i] componentsSeparatedByString:@","];
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([[pointArray objectAtIndex:0] doubleValue], [[pointArray objectAtIndex:1] doubleValue]);
            //NSLog(@"%f,%f",latitude,longitude);
            MKMapPoint point = MKMapPointForCoordinate(coordinate);
            // if it is the first point, just use them, since we have nothing to compare to yet.
            if (i == 0) {
                northEastPoint = point;
                southWestPoint = point;
            }
            else
            {
                if (point.x > northEastPoint.x)
                    northEastPoint.x = point.x;
                if(point.y > northEastPoint.y)
                    northEastPoint.y = point.y;
                if (point.x < southWestPoint.x)
                    southWestPoint.x = point.x;
                if (point.y < southWestPoint.y)
                    southWestPoint.y = point.y;
            }
            
            pointArr[i] = point;
        }
        
         routeLine= [MKPolyline polylineWithPoints:pointArr count:[geoArray count]];
        
        if (nil!=routeLine) {
            [carMapView addOverlay:routeLine];
        }
        
        if (1==shouldZoom) {
            routeRect = MKMapRectMake(southWestPoint.x, southWestPoint.y, northEastPoint.x - southWestPoint.x, northEastPoint.y - southWestPoint.y);
            [self zoomInOnRoute];
        }
        
        free(pointArr);
        
    }
}

-(void) zoomInOnRoute{
    
	[carMapView setVisibleMapRect:routeRect];
    
}


#pragma mark - UIButton actions

-(IBAction)selectCar:(id)sender{
    if (nil==dropListView) {
        dropListView=[[DropListView alloc]initWithStyle:UITableViewStylePlain];
        dropListView.resourceArray=self.carArray;
        [dropListView setDropListDelegate:self];
        [dropListView.view setFrame:CGRectMake(91, 45, 139, 200)];
        [self.view addSubview:dropListView.view];
    }
    [dropListView dropListViewHidden:NO];
    
}

-(void)showLayer{
    UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:@"選擇地圖種類" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"一般",@"路況",@"衛星",@"街景", nil];
    [actionSheet showInView:self.view];
    [actionSheet release];
}

#pragma mark -DropListView Delegte method

-(void)dropListView:(DropListView *)dropListView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    car=[self.carArray objectAtIndex:indexPath.row];
    [selectCarButton setTitle:car.plateNumber forState:UIControlStateNormal];
    [self loadStreetWebView];
    [self sendMessageWithCar:car];
}


#pragma mark - UIActionsheet Delegate method

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (0==buttonIndex||1==buttonIndex||2==buttonIndex) {
        [carMapView setHidden:NO];
        [streetWebView setHidden:YES];
    }else if(3==buttonIndex){
        [carMapView setHidden:YES];
        [streetWebView setHidden:NO];
    }
    
    if (0==buttonIndex||1==buttonIndex) {
        [carMapView setMapType:MKMapTypeStandard];
        
    }else if(2==buttonIndex){
        [carMapView setMapType:MKMapTypeSatellite];
    }else if(3==buttonIndex){
        if (nil==streetWebView) {
            streetWebView=[[UIWebView alloc]initWithFrame:carMapView.frame];
            //[streetWebView setDelegate:self];
            [self.view addSubview:streetWebView];
        }
        [self loadStreetWebView];
    }
}

-(void)loadStreetWebView{
    //[self showMBProgressHUDWithView:self.view title:@"正在加載街景..."];
	NSString *htmlString = [NSString stringWithFormat:@"<html>\
							<head>\
							<meta id=\"viewport\" name=\"viewport\" content=\"width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;\">\
							<script src='http://maps.google.com/maps/api/js?sensor=false' type='text/javascript'></script>\
							</head>\
							<body onload=\"new google.maps.StreetViewPanorama(document.getElementById('p'),{position:new google.maps.LatLng(%f, %f)});\" style='padding:0px;margin:0px;'>\
							<div id='p' style='height:%f;width:%f;'></div>\
							</body>\
							</html>",self.car.latitude, self.car.longitude, streetWebView.frame.size.height, streetWebView.frame.size.width];
    [streetWebView loadHTMLString:htmlString baseURL:nil];
}

//#pragma mark - WebView Delegate method
//
//- (void)webViewDidStartLoad:(UIWebView *)webView{
//    
//}
//
//-(void)webViewDidFinishLoad:(UIWebView *)webView{
//    [self removeMBProgressHUD];
//}
//
//-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
//    [self removeMBProgressHUD];
//}

@end
