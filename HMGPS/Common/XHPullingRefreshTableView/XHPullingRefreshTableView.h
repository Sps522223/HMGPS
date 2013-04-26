//
//  XHPullingRefreshTableView.h
//  MyPullTest
//
//  Created by xiao hui on 12-8-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum{
    XHPullingRefreshTableViewStateNormal   =0,  
    XHPullingRefreshTableViewStatePulling  =1,  
    XHPullingRefreshTableViewStateLoading  =2,  
    XHPullingRefreshTableViewStateEnd   
}
XHPullingRefreshTableViewState;

typedef enum {
    XHPullingRefreshTableViewHeader  =0,
    XHPullingRefreshTableViewFooter  =1,
    XHPullingRefreshTableViewBoth    
} 
XHPullingRefreshTableViewStyle;



@interface LoadingView : UIView {
    UILabel *_stateLabel;
    UILabel *_dateLabel;
    UIImageView *_arrowImageView;
    UIActivityIndicatorView *_activityView;
    CALayer *_arrow;
    BOOL _loading;
}

@property(nonatomic,getter = isLoading)BOOL loading;
@property(nonatomic,getter = isAtTop)BOOL atTop;
@property(nonatomic,assign)XHPullingRefreshTableViewState state;
@property(nonatomic,retain)UILabel *_stateLabel;

-(id)initWithFrame:(CGRect)frame atTop:(BOOL)top;
-(void)updateRefreshDate:(NSDate *)date;

@end

@protocol XHPullingRefreshTableViewDelegate;


@interface XHPullingRefreshTableView : UITableView<UIScrollViewDelegate>{
    LoadingView *_headerView;
    LoadingView *_footerView;
    UILabel *_msgLabel;
    BOOL _loading;
    BOOL _isFooterInAction;
    int _bottomRow;
}
@property(nonatomic,assign)id<XHPullingRefreshTableViewDelegate>pullRefreshDelegete;
@property(nonatomic,assign)BOOL reachedTheEnd;
@property (nonatomic,assign)BOOL autoScrollToNextPage;
@property(nonatomic,getter = isHeaderOnly)BOOL headerOnly;
@property(nonatomic,assign)XHPullingRefreshTableViewStyle tableViewStyle;
@property(nonatomic,retain)LoadingView *_footerView;

- (id)initWithFrame:(CGRect)frame xhTableViewStyle:(XHPullingRefreshTableViewStyle)style pullingDelegate:(id<XHPullingRefreshTableViewDelegate>)aPullingDelegate;

- (void)tableViewDidScroll:(UIScrollView *)scrollView;

- (void)tableViewDidEndDragging:(UIScrollView *)scrollView;

- (void)tableViewDidFinishedLoading;

- (void)tableViewDidFinishedLoadingWithMessage:(NSString *)msg;

- (void)launchRefreshing;
@end


@protocol XHPullingRefreshTableViewDelegate <NSObject>

@optional
-(void)pullingTableViewDidStartRefreshing:(XHPullingRefreshTableView *)tableView;

@optional
//Implement this method if headerOnly is false
- (void)pullingTableViewDidStartLoading:(XHPullingRefreshTableView *)tableView;
//Implement the follows to set date you want,Or Ignore them to use current date 
- (NSDate *)pullingTableViewRefreshingFinishedDate;
- (NSDate *)pullingTableViewLoadingFinishedDate;


@end



