//
//  XHPullingRefreshTableView.m
//  MyPullTest
//
//  Created by xiao hui on 12-8-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "XHPullingRefreshTableView.h"
#import <QuartzCore/QuartzCore.h>

#define XHOffsetY 60.f
#define XHMargin 5.f
#define XHLabelHeight 20.f
#define XHLabelWidth 100.f
#define XHArrowWidth 20.f  
#define XHArrowHeight 40.f

#define kTextColor [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define XHBGColor [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0]
#define XHAnimationDuration .18f

@interface LoadingView () 
- (void)updateRefreshDate :(NSDate *)date;
- (void)setState:(XHPullingRefreshTableViewState)state animated:(BOOL)animated;
- (void)layouts;
@end

@implementation LoadingView
@synthesize atTop=_atTop;
@synthesize state=_state;
@synthesize loading=_loading;
@synthesize _stateLabel;

-(id)initWithFrame:(CGRect)frame atTop:(BOOL)top{
    self=[super initWithFrame:frame];
    if (self) {
        self.atTop = top;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = XHBGColor;
        UIFont *font = [UIFont systemFontOfSize:12.f];
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.font = font;
        _stateLabel.textColor = kTextColor;
        _stateLabel.textAlignment = 1;
        _stateLabel.backgroundColor = XHBGColor;
        _stateLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _stateLabel.text = NSLocalizedString(@"下拉刷新", @"");
        [self addSubview:_stateLabel];
        
        _dateLabel = [[UILabel alloc]init];
        _dateLabel.font = font;
        _dateLabel.textColor = kTextColor;
        _dateLabel.textAlignment = 1;
        _dateLabel.backgroundColor = XHBGColor;
        _dateLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:_dateLabel];
        
        _arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20) ];
        
        _arrow = [CALayer layer];
        _arrow.frame = CGRectMake(0, 0, 20, 20);
        _arrow.contentsGravity = kCAGravityResizeAspect;
        
        _arrow.contents = (id)[UIImage imageWithCGImage:[UIImage imageNamed:@"blueArrow.png"].CGImage scale:1 orientation:UIImageOrientationDown].CGImage;
        
        [self.layer addSublayer:_arrow];
        
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:_activityView];
        
        [self layouts];
    }
    
    return self;
}

- (void)layouts {
    
    CGSize size = self.frame.size;
    CGRect stateFrame,dateFrame,arrowFrame;
    
    float x = 0,y,margin;
    margin = (XHOffsetY - 2*XHLabelHeight)/2;
    if (self.isAtTop) {
        y = size.height - margin - XHLabelHeight;
        dateFrame = CGRectMake(0,y,size.width,XHLabelHeight);
        
        y = y - XHLabelHeight;
        stateFrame = CGRectMake(0, y, size.width, XHLabelHeight);
        
        x = XHMargin;
        y = size.height - margin - XHArrowHeight;
        arrowFrame = CGRectMake(4*x, y, XHArrowWidth, XHArrowHeight);
        
        UIImage *arrow = [UIImage imageNamed:@"blueArrow"];
        _arrow.contents = (id)arrow.CGImage;
        
    } else {    //at bottom
        y = margin;
        stateFrame = CGRectMake(0, y, size.width, XHLabelHeight );
        
        y = y + XHLabelHeight;
        dateFrame = CGRectMake(0, y, size.width, XHLabelHeight);
        
        x = XHMargin;
        y = margin;
        arrowFrame = CGRectMake(4*x, y, XHArrowWidth, XHArrowHeight);
        
        UIImage *arrow = [UIImage imageNamed:@"blueArrowDown"];        
        _arrow.contents = (id)arrow.CGImage;
        _stateLabel.text = NSLocalizedString(@"更多...", @"");
    }
    
    _stateLabel.frame = stateFrame;
    [_stateLabel setBackgroundColor:[UIColor clearColor]];
    _dateLabel.frame = dateFrame;
    [_dateLabel setBackgroundColor:[UIColor clearColor]];
    _arrowImageView.frame = arrowFrame;
    _activityView.center =CGPointMake(60, 20);
    _arrow.frame = arrowFrame;
    _arrow.transform = CATransform3DIdentity;
}


- (void)setState:(XHPullingRefreshTableViewState)state {
    [self setState:state animated:YES];
}

- (void)setState:(XHPullingRefreshTableViewState)state animated:(BOOL)animated{
    float duration = animated ? XHAnimationDuration : 0.f;
    if (_state != state) {
        _state = state;
        if (_state == XHPullingRefreshTableViewStateLoading) {    //Loading
            
            _arrow.hidden = YES;
            _activityView.hidden = NO;
            [_activityView startAnimating];
            
            _loading = YES;
            _stateLabel.text=self.isAtTop?NSLocalizedString(@"正在刷新...", @""):NSLocalizedString(@"正在加载...", @"");
            
        } else if (_state == XHPullingRefreshTableViewStatePulling && !_loading) {    //Scrolling
            
            _arrow.hidden = NO;
            _activityView.hidden = YES;
            [_activityView stopAnimating];
            
            [CATransaction begin];
            [CATransaction setAnimationDuration:duration];
            _arrow.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
            [CATransaction commit];
            
            _stateLabel.text=self.isAtTop?NSLocalizedString(@"释放立即刷新", @""):NSLocalizedString(@"释放加載更多", @"");
            
        } else if (_state == XHPullingRefreshTableViewStateNormal && !_loading){    //Reset
            
            _arrow.hidden = NO;
            _activityView.hidden = YES;
            [_activityView stopAnimating];
            
            [CATransaction begin];
            [CATransaction setAnimationDuration:duration];
            _arrow.transform = CATransform3DIdentity;
            [CATransaction commit];
            
            _stateLabel.text=self.isAtTop?NSLocalizedString(@"下拉即可刷新", @""):NSLocalizedString(@"更多", @"");
            
        } else if (_state == XHPullingRefreshTableViewStateEnd) {
            if (!self.isAtTop) {    //footer
                _arrow.hidden = YES;
                _stateLabel.text = @"";
            }
        }
    }
}

- (void)setLoading:(BOOL)loading {
    _loading = loading;
}

- (void)updateRefreshDate :(NSDate *)date{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *dateString = [df stringFromDate:date];
    NSString *title = NSLocalizedString(@"今天", nil);
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                                               fromDate:date toDate:[NSDate date] options:0];
    int year = [components year];
    int month = [components month];
    int day = [components day];
    if (year == 0 && month == 0 && day < 3) {
        if (day == 0) {
            title = NSLocalizedString(@"今天",nil);
        } else if (day == 1) {
            title = NSLocalizedString(@"昨天",nil);
        } else if (day == 2) {
            title = NSLocalizedString(@"前天",nil);
        }
        df.dateFormat = [NSString stringWithFormat:@"%@ HH:mm",title];
        dateString = [df stringFromDate:date];
        
    } 
    _dateLabel.text = [NSString stringWithFormat:@"%@: %@",
                       NSLocalizedString(@"最后更新", @""),
                       dateString];
    [_dateLabel setHidden:YES];
    [df release];
}

@end

/***************************************************************************************************************/
#pragma mark - XHPullingRefreshTableView

@interface XHPullingRefreshTableView ()
- (void)scrollToNextPage;
- (void)flashMessage:(NSString *)msg;
@end

@implementation XHPullingRefreshTableView
@synthesize pullRefreshDelegete=_pullRefreshDelegete;
@synthesize reachedTheEnd=_reachedTheEnd;
@synthesize headerOnly=_headerOnly;
@synthesize autoScrollToNextPage=_autoScrollToNextPage;
@synthesize tableViewStyle;
@synthesize _footerView;

-(void)dealloc{
    [self removeObserver:self forKeyPath:@"contentSize"];
    [_headerView release];
    [_footerView release];
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        // Initialization code
        
        CGRect rect;
        
        if (self.tableViewStyle==XHPullingRefreshTableViewHeader) {
            rect= CGRectMake(0, 0 - frame.size.height, frame.size.width, frame.size.height);
            _headerView = [[LoadingView alloc] initWithFrame:rect atTop:YES];
            _headerView.atTop = YES;
            [self addSubview:_headerView];
        }else if(self.tableViewStyle==XHPullingRefreshTableViewFooter){
            rect = CGRectMake(0, frame.size.height, frame.size.width, frame.size.height);
            _footerView = [[LoadingView alloc] initWithFrame:rect atTop:NO];
            [_footerView setBackgroundColor:[UIColor clearColor]];
            _footerView.atTop = NO;
            [self addSubview:_footerView];
        }else{
            rect= CGRectMake(0, 0 - frame.size.height, frame.size.width, frame.size.height);
            _headerView = [[LoadingView alloc] initWithFrame:rect atTop:YES];
            _headerView.atTop = YES;
            [self addSubview:_headerView];
            
            rect = CGRectMake(0, frame.size.height, frame.size.width, frame.size.height);
            _footerView = [[LoadingView alloc] initWithFrame:rect atTop:NO];
            _footerView.atTop = NO;
            [self addSubview:_footerView];
        }
        
        
        [self addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame xhTableViewStyle:(XHPullingRefreshTableViewStyle)style pullingDelegate:(id<XHPullingRefreshTableViewDelegate>)aPullingDelegate {
    self.tableViewStyle=style;
    self = [self initWithFrame:frame style:UITableViewStylePlain];
    if (self) {
        self.pullRefreshDelegete = aPullingDelegate;
    }
    return self;
}

- (void)setReachedTheEnd:(BOOL)reachedTheEnd{
    _reachedTheEnd = reachedTheEnd;
    if (_reachedTheEnd){
        _footerView.state = XHPullingRefreshTableViewStateEnd;
    } else {
        _footerView.state = XHPullingRefreshTableViewStateNormal;
    }
}

- (void)setHeaderOnly:(BOOL)headerOnly{
    _headerOnly = headerOnly;
    _footerView.hidden = _headerOnly;
}

#pragma mark - Scroll methods

- (void)scrollToNextPage {
    float h = self.frame.size.height;
    float y = self.contentOffset.y + h;
    y = y > self.contentSize.height ? self.contentSize.height : y;
    [UIView animateWithDuration:.7f 
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut 
                     animations:^{
                         self.contentOffset = CGPointMake(0, y);  
                     }
                     completion:^(BOOL bl){
                     }];
}

- (void)tableViewDidScroll:(UIScrollView *)scrollView {
    
    if (_headerView.state == XHPullingRefreshTableViewStateLoading || _footerView.state == XHPullingRefreshTableViewStateLoading) {
        return;
    }
    
    CGPoint offset = scrollView.contentOffset;
    CGSize size = scrollView.frame.size;
    CGSize contentSize = scrollView.contentSize;
    
    float yMargin = offset.y + size.height - contentSize.height;
    if (offset.y < -XHOffsetY) {   //header totally appeard
        _headerView.state = XHPullingRefreshTableViewStatePulling;
    } else if (offset.y > -XHOffsetY && offset.y < 0){ //header part appeared
        _headerView.state = XHPullingRefreshTableViewStateNormal;
    } else if ( yMargin > XHOffsetY){  //footer totally appeared
        if (_footerView.state != XHPullingRefreshTableViewStateEnd) {
            _footerView.state = XHPullingRefreshTableViewStatePulling;
        }
    } else if ( yMargin < XHOffsetY && yMargin > 0) {//footer part appeared
        if (_footerView.state != XHPullingRefreshTableViewStateEnd) {
            _footerView.state = XHPullingRefreshTableViewStateNormal;
        }
    }
}

- (void)tableViewDidEndDragging:(UIScrollView *)scrollView {
    
    //    CGPoint offset = scrollView.contentOffset;
    //    CGSize size = scrollView.frame.size;
    //    CGSize contentSize = scrollView.contentSize;
    if (_headerView.state == XHPullingRefreshTableViewStateLoading || _footerView.state == XHPullingRefreshTableViewStateLoading) {
        return;
    }
    if (_headerView.state == XHPullingRefreshTableViewStatePulling) {
        //    if (offset.y < -kPROffsetY) {
        _isFooterInAction = NO;
        _headerView.state = XHPullingRefreshTableViewStateLoading;
        
        [UIView animateWithDuration:XHAnimationDuration animations:^{
            self.contentInset = UIEdgeInsetsMake(XHOffsetY, 0, 0, 0);
        }];
        if (_pullRefreshDelegete && [_pullRefreshDelegete respondsToSelector:@selector(pullingTableViewDidStartRefreshing:)]) {
            [_pullRefreshDelegete pullingTableViewDidStartRefreshing:self];
        }
    } else if (_footerView.state == XHPullingRefreshTableViewStatePulling) {
        //    } else  if (offset.y + size.height - contentSize.height > kPROffsetY){
        if (self.reachedTheEnd || self.headerOnly) {
            return;
        }
        _isFooterInAction = YES;
        _footerView.state = XHPullingRefreshTableViewStateLoading;
        [UIView animateWithDuration:XHAnimationDuration animations:^{
            self.contentInset = UIEdgeInsetsMake(0, 0, XHOffsetY, 0);
        }];
        if (_pullRefreshDelegete && [_pullRefreshDelegete respondsToSelector:@selector(pullingTableViewDidStartLoading:)]) {
            [_pullRefreshDelegete pullingTableViewDidStartLoading:self];
        }
    }
}

- (void)tableViewDidFinishedLoading {
    [self tableViewDidFinishedLoadingWithMessage:nil];  
}

- (void)tableViewDidFinishedLoadingWithMessage:(NSString *)msg{
    
    if (_headerView.loading) {
        _headerView.loading = NO;
        [_headerView setState:XHPullingRefreshTableViewStateNormal animated:NO];
        NSDate *date = [NSDate date];
        if (_pullRefreshDelegete && [_pullRefreshDelegete respondsToSelector:@selector(pullingTableViewRefreshingFinishedDate)]) {
            date = [_pullRefreshDelegete pullingTableViewRefreshingFinishedDate];
        }
        [_headerView updateRefreshDate:date];
        [UIView animateWithDuration:XHAnimationDuration*2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        } completion:^(BOOL bl){
            if (msg != nil && ![msg isEqualToString:@""]) {
                [self flashMessage:msg];
            }
        }];
    }
    else if (_footerView.loading) {
        _footerView.loading = NO;
        [_footerView setState:XHPullingRefreshTableViewStateNormal animated:NO];
        NSDate *date = [NSDate date];
        if (_pullRefreshDelegete && [_pullRefreshDelegete respondsToSelector:@selector(pullingTableViewLoadingFinishedDate)]) {
            date = [_pullRefreshDelegete pullingTableViewRefreshingFinishedDate];
        }
        [_footerView updateRefreshDate:date];
        
        [UIView animateWithDuration:XHAnimationDuration animations:^{
            self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        } completion:^(BOOL bl){
            if (msg != nil && ![msg isEqualToString:@""]) {
                [self flashMessage:msg];
            }
        }];
    }
}

- (void)flashMessage:(NSString *)msg{
    //Show message
    __block CGRect rect = CGRectMake(0, self.contentOffset.y - 20, self.bounds.size.width, 20);
    
    if (_msgLabel == nil) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.frame = rect;
        _msgLabel.font = [UIFont systemFontOfSize:14.f];
        _msgLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _msgLabel.backgroundColor = [UIColor orangeColor];
        _msgLabel.textAlignment = 1;
        [self addSubview:_msgLabel];    
    }
    _msgLabel.text = msg;
    
    rect.origin.y += 20;
    [UIView animateWithDuration:.4f animations:^{
        _msgLabel.frame = rect;
    } completion:^(BOOL finished){
        rect.origin.y -= 20;
        [UIView animateWithDuration:.4f delay:1.2f options:UIViewAnimationOptionCurveLinear animations:^{
            _msgLabel.frame = rect;
        } completion:^(BOOL finished){
            [_msgLabel removeFromSuperview];
            _msgLabel = nil;            
        }];
    }];
}

- (void)launchRefreshing {
    [self setContentOffset:CGPointMake(0,0) animated:NO];
    [UIView animateWithDuration:XHAnimationDuration animations:^{
        self.contentOffset = CGPointMake(0, -XHOffsetY-1);
    } completion:^(BOOL bl){
        [self tableViewDidEndDragging:self];
    }];
}

#pragma mark - 

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    CGRect frame = _footerView.frame;
    CGSize contentSize = self.contentSize;
    frame.origin.y = contentSize.height < self.frame.size.height ? self.frame.size.height : contentSize.height;
    _footerView.frame = frame;
    if (self.autoScrollToNextPage && _isFooterInAction) {
        [self scrollToNextPage];
        _isFooterInAction = NO;
    } else if (_isFooterInAction) {
        CGPoint offset = self.contentOffset;
        if (_footerView.state!=XHPullingRefreshTableViewStateNormal) {
            offset.y += 44.f;
            self.contentOffset = offset;
        }
        
    }
    
}

@end
