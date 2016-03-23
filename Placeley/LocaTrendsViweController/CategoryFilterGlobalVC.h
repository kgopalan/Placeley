//
//  CategoryFilterGlobalVC.h
//  Placeley
//
//  Created by APR on 1/25/14.
//  Copyright (c) 2014 APR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterCell.h"


@protocol filterOptionGlobalDelegate <NSObject>
@optional
- (void)filterOptionSelectedCategory:(NSString *)GlobalcategoryName;
-(void)filterOptionSelectedCity:(NSString *)GlobalCityName;
-(void)filterDoneGlobal;


@end


@interface CategoryFilterGlobalVC : UIViewController

{
    
    NSMutableArray *arrGlobalFiterCityName;
    NSMutableArray *arrGlobalFilterCatName;
    
    NSMutableArray *selectedCityIndexPaths;
    NSMutableArray *selectedCategoryIndexPaths;
    NSString *strGlobalCityNameSelect;
    
}
@property(nonatomic,strong) IBOutlet UIView *viewGlobalPop;

@property(nonatomic,strong) IBOutlet UITableView *tbleFilterGlobalCity,*tbleFilterGlobalCategory;
@property(nonatomic,strong) IBOutlet  UIButton *btnFilterClose,*btnDone;

-(IBAction)btn_FilterClose:(id)sender;


@property (nonatomic, assign) id<filterOptionGlobalDelegate> delegate;
-(void)FilterOpenViewAnimations;
-(void) getGlobalCity;

@end
