//
//  TravelNoteAnnotation.m
//  hztour-iphone
//
//  Created by xiaohui on 12-3-26.
//  Copyright (c) 2012年 teemax. All rights reserved.
//

#import "CustomAnnotation.h"

@implementation CustomAnnotation
@synthesize coordinate,title,subtitle,tag;

-(id)initWithCoordinate:(CLLocationCoordinate2D)coords{
    self=[super init];
    if (self) 
        coordinate=coords;
    return self;
}
-(void)dealloc{
    [title release];
    [subtitle release];
    [super dealloc];
}
@end

