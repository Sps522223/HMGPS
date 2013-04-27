//
//  UINavigationBar+drawRect.m
//  KTV
//
//  Created by Guo Xiaohui Guo  on 12-11-19.
//
//

#import "UINavigationBar+Utilities.h"

@implementation UINavigationBar (DrawRect)
-(void)drawRect:(CGRect)rect{
    UIImageView *imageView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nav_title.png"]] autorelease];
    [imageView setFrame:CGRectMake(0, 0, 320, 44)];
    [self drawRect:imageView.frame];
}
@end


@implementation UINavigationBar(NavImage)

-(void)setNavImage{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >=__IPHONE_5_0
    [self setBackgroundImage:[UIImage imageNamed:@"nav_title.png"] forBarMetrics:UIBarMetricsDefault];
#endif
}

@end