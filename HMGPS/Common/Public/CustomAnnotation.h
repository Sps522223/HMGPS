//
//  TravelNoteAnnotation.h
//  hztour-iphone
//
//  Created by xiaohui on 12-3-26.
//  Copyright (c) 2012年 teemax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>


@interface CustomAnnotation : NSObject<MKAnnotation>{
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
    long tag;
}
@property(nonatomic,readonly)CLLocationCoordinate2D coordinate;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *subtitle;
@property(nonatomic,assign)long tag;

-(id)initWithCoordinate:(CLLocationCoordinate2D)coords;

@end
