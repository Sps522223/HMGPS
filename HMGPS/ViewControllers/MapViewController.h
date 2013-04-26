//
//  MapViewController.h
//  HMGPS
//
//  Created by Xiaohui Guo on 13-4-25.
//  Copyright (c) 2013年 PERSONAL OUT_SOFTWARE TECHNOLOGY CO.LTD. All rights reserved.
//

#import "BaseViewController.h"
#import "Car.h"
#import "HMSocket.h"
#import "MKMapView+ZoomLevel.h"
#import "CustomAnnotation.h"
#import "DropListView.h"

typedef enum {
    MapViewTypeStatus   =0,
    MapViewTypeContrail =1,
    MapViewTypeLine
     
}MapViewType;


@interface MapViewController : BaseViewController<HMSocketDelegate,MKMapViewDelegate,DropListViewDelegate,UIActionSheetDelegate,UIWebViewDelegate>{
    IBOutlet UILabel *infoLabel;
    IBOutlet MKMapView *carMapView;
    NSString *carInfoString;
    NSArray *carInfoArray;//接收到的信息拆分後的数组
    CLLocationCoordinate2D cllocation2D;
    NSArray *receiveArray;
    NSString *finalReceivedString;
    CustomAnnotation *customAnnotation;
    IBOutlet UIButton *selectCarButton;
    DropListView *dropListView;
    NSString *message;
    NSDictionary *loginInfoDict;
    MKMapRect routeRect;
    int shouldZoom;
    UIWebView *streetWebView;
}

@property(nonatomic,retain)Car *car;
@property(nonatomic,retain)NSArray *carArray;
@property(nonatomic,assign)MapViewType mapViewType;

-(IBAction)selectCar:(id)sender;

@end
