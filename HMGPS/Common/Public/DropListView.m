//
//  QuestionView.m
//  KTV
//
//  Created by Guo xiao hui on 12-11-21.
//
//

#import "DropListView.h"
#import <QuartzCore/QuartzCore.h>

@implementation DropListView
@synthesize resourceArray;
@synthesize dropListDelegate;
/*
 - (id)initWithStyle:(UITableViewStyle)style {
 // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 self = [super initWithStyle:style];
 if (self) {
 // Custom initialization.
 }
 return self;
 }
 */

-(void)dealloc{
    [resourceArray release];
    [car release];
    [super dealloc];
}

#pragma mark - UIViewController lifecyle
-(void)viewDidLoad{
    [super viewDidLoad];
    self.tableView.layer.borderWidth = 1;
	self.tableView.layer.borderColor = [[UIColor blackColor] CGColor];
}


#pragma mark - Other method
-(void)dropListViewHidden:(BOOL)hidden {
    NSInteger height = hidden ? 0 : 200;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.2];
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, height)];
    [UIView commitAnimations];

}


#pragma mark - UITableView Datasource method
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [resourceArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 30;
}
-(UITableViewCell *)tableView:(UITableView *)tableViews cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier=@"cell";
    UITableViewCell *cell=[tableViews dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
        [cell.textLabel setFont:[UIFont systemFontOfSize:12]];
        
    }
    car=[resourceArray objectAtIndex:indexPath.row];
    [cell.textLabel setText:car.plateNumber];
    return cell;
}

#pragma mark -UITableView Delegte method
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dropListViewHidden:YES];
    if ([dropListDelegate respondsToSelector:@selector(dropListView:didSelectRowAtIndexPath:)]) {
        [dropListDelegate dropListView:self didSelectRowAtIndexPath:indexPath];
    }
    
}
@end
