//
//  CategoryFilterViewController.h
//  Placeley
//
//  Created by APR on 1/25/14.
//  Copyright (c) 2014 APR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterCell.h"
#import <QuartzCore/QuartzCore.h>

@protocol filterOptionDelegate <NSObject>
@optional
- (void)filterOptionSelected:(NSString *)categoryName;
-(void)FilterDone;

@end

@interface CategoryFilterViewController : UIViewController
{
    NSMutableArray *arrLocalFilterCatName;
   
    NSMutableArray *selectedIndexPaths;
  
}
@property(nonatomic,strong) IBOutlet UIView *transparentView;
@property(nonatomic,strong) IBOutlet UIView *viewPopUpLocal,*viewPopUpGlobal;
@property(nonatomic,strong) IBOutlet UITableView *tbleFilter;
@property(nonatomic,strong) IBOutlet  UIButton *btnFilterClose,*btnDone;
-(void)FilterOpenViewAnimations;
-(IBAction)btn_FilterClose:(id)sender;

/*!
 Custom Delegate==================
 */
@property (nonatomic, assign) id<filterOptionDelegate> delegate;
@end
