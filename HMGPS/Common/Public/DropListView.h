//
//  QuestionView.h
//  KTV
//
//  Created by Guo xiao hui on 12-11-21.
//
//

#import <UIKit/UIKit.h>
#import "Car.h"

@class DropListView;

@protocol DropListViewDelegate <NSObject>
@optional
-(void)dropListView:(DropListView *)dropListView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface DropListView : UITableViewController{
    Car *car;
}
@property(nonatomic,retain)NSArray *resourceArray;
@property(nonatomic,assign)id<DropListViewDelegate>dropListDelegate;

-(void)dropListViewHidden:(BOOL)hidden;

@end
