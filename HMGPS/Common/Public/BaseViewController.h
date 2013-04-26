//
//  BaseViewController.h
//  KTV
//
//  Created by Xiaohui Guo  on 12-10-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "BaseService.h"
//#import "CommonParser.h"
/*
 其他UIViewController的父类,均需要继承之
 1.when view.bounds changes,自动匹配宽度
 2.兼容iphone5
 */

@interface BaseViewController : UIViewController<UITextFieldDelegate>

@end
