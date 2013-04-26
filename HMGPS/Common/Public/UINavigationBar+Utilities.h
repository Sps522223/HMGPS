//
//  UINavigationBar+drawRect.h
//  KTV
//
//  Created by Guo Xiaohui Guo  on 12-11-19.
//
//

#import <UIKit/UIKit.h>
/*
 ios 5.0以下导航条自定义
 */
@interface UINavigationBar (DrawRect)
-(void)drawRect:(CGRect)rect;
@end

/*
 ios5.0以上
 */
@interface UINavigationBar (NavImage)
-(void)setNavImage;
@end